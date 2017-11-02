//
//  ShapeField.swift
//  ShapeResearchPackageDescription
//
//  Created by Hans Petter Eikemo on 01/11/2017.
//

import Foundation
import Cshapelib

public struct ShapeField {

    public let fieldIndex: Int32
    public let fieldName: String
    public let type: FieldType

    public enum FieldType {
        case string
        case integer
        case double
        case logical
        case invalid
    }

}

public struct FieldLookup {

    public let count: Int

    public subscript(_ name: String) -> ShapeField? {
        guard let index = namesTable[name] else { return nil }
        return fields[index]
    }

    public subscript(_ index: Int) -> ShapeField {
        return fields[index]
    }

    internal let fields: [ShapeField]
    private let namesTable: [String: Int]

    public init(handle: DBFHandle) throws {
        let count = DBFGetFieldCount(handle)
        var fields = [ShapeField]()
        var namesTable = [String: Int]()
        for index in 0..<count {
            let name = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
            defer { name.deallocate(capacity: 1) }
            var width: Int32 = 0, decimals: Int32 = 0
            let type = DBFGetFieldInfo(handle, index, name, &width, &decimals)
            let fieldName = String(cString: name)
            try fields.append(ShapeField(fieldIndex: index, fieldName: fieldName, type: .init(fieldType: type)))
            namesTable[fieldName] = Int(index)
        }
        self.count = Int(count)
        self.fields = fields
        self.namesTable = namesTable
    }
    
}

extension ShapeField: CustomStringConvertible {

    public var description: String {
        return "#\(fieldIndex) \(fieldName) : \(type)"
    }

}

extension ShapeField.FieldType {

    init(fieldType: DBFFieldType) throws {
        switch fieldType {
        case FTString: self = .string
        case FTInteger: self = .integer
        case FTDouble: self = .double
        case FTLogical: self = .logical
        case FTInvalid: self = .invalid
        default: throw Error.unknownFieldType(type: fieldType.rawValue)
        }
    }
    
}

public enum Attribute {

    case string(String)
    case double(Double)
    case integer(Int)

}

extension Attribute: CustomStringConvertible {

    public var description: String {
        switch self {
        case .string(let value): return value
        case .double(let value): return value.description
        case .integer(let value): return value.description
        }
    }

}

extension ShapeField {

    func attribute(handle: DBFHandle, record: Int) throws -> Attribute? {
        if DBFIsAttributeNULL(handle, Int32(record), fieldIndex) == 1 { return nil }
        switch self.type {
        case .string:
            return .string(String(cString: DBFReadStringAttribute(handle, Int32(record), fieldIndex)!))
        case .double:
            return .double(DBFReadDoubleAttribute(handle, Int32(record), fieldIndex))
        case .integer:
            return .integer(Int(DBFReadIntegerAttribute(handle, Int32(record), fieldIndex)))
        case .logical: throw Error.notImplemented(message: "Can't handle logical types yet")
        case .invalid: throw Error.notImplemented(message: "Can't handle invalid types yet")
        }        
    }

}
