//
//  Shapefile.swift
//  ShapeResearchPackageDescription
//
//  Created by Hans Petter Eikemo on 01/11/2017.
//

import Foundation
import Cshapelib
import simd

public class Shapefile {

    private let handle: SHPHandle
    private let dbHandle: DBFHandle

    private let lookup: FieldLookup

    public init(at path: String) throws {
        guard
            let handle = SHPOpen(path, "rb"),
            let dbHandle = DBFOpen(path, "rb")
            else { throw Error.inaccessibleFile(filePath: path) }
        self.handle = handle
        self.dbHandle = dbHandle

        lookup = try FieldLookup(handle: dbHandle)

        var numberOfShapes: Int32 = 0, shapeType: Int32 = 0;
        var min = [0.0, 0.0, 0.0, 0.0], max = [0.0, 0.0, 0.0, 0.0]
        SHPGetInfo(handle, &numberOfShapes, &shapeType, &min, &max);

        self.type = try ShapeType(type: shapeType)
        self.count = Int(numberOfShapes)
        self.minBounds = (min[0],min[1],min[2],min[3])
        self.maxBounds = (max[0],max[1],max[2],max[3])
    }

    deinit {
        SHPClose(handle)
        DBFClose(dbHandle)
    }

    public let type: ShapeType
    public let count: Int
    public let minBounds: (Double,Double,Double,Double)
    public let maxBounds: (Double,Double,Double,Double)

    public subscript(index: Int) -> Shape<double2> {
        guard
            index < count,
            let shapeHandle = SHPReadObject(handle, Int32(index))
            else { fatalError("Index out of bounds") }
        defer { SHPDestroyObject(shapeHandle) }
        let object = shapeHandle.pointee
        let type = try! ShapeType(type: object.nSHPType)
        var parts = [Part<double2>]()
        for p in 0..<Int(object.nParts) {
            let type = try! PartType(type: object.panPartType[p])
            let start = Int(object.panPartStart[p])
            let end = p+1 >= Int(object.nParts) ? Int(object.nVertices) : Int(object.panPartStart[p+1])
            parts.append( Part(type: type, vertices: vertices2(from: object, count: end-start, offset: start)) )
        }

        var attributes = [String: Attribute]()
        for i in 0..<lookup.count {
            let field = lookup[i]
            if case let attribute?? = try? field.attribute(handle: dbHandle, record: i) {
                attributes[field.fieldName] = attribute
            }
        }
        return Shape(shapeIndex: object.nShapeId, type: type, parts: parts, attributes: attributes)
    }

}
