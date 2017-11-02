//
//  Shape.swift
//  ShapeResearchPackageDescription
//
//  Created by Hans Petter Eikemo on 01/11/2017.
//

import Foundation
import Cshapelib
import simd

public struct Shape<T> {

    public let shapeIndex: Int32
    public let type: ShapeType
    public let parts: [Part<T>]
    public let attributes: [String: Attribute]

}

public struct Part<T> {
    public var type: PartType
    public var vertices: [T]
}

func vertices2(from shape: SHPObject, count: Int, offset: Int) -> [double2] {
    return (offset..<(offset+count)).map {
        double2(shape.padfX[$0],shape.padfY[$0])
    }
}


public enum ShapeType {
    case null
    case point
    case arc
    case polygon
    case multipoint
    case pointZ
    case arcZ
    case polygonZ
    case multipointZ
    case pointM
    case arcM
    case polygonM
    case multipointM
    case multipatch
}

extension ShapeType {

    init(type: Int32) throws {
        switch type {
        case SHPT_NULL: self = .null
        case SHPT_POINT: self = .point
        case SHPT_ARC: self = .arc
        case SHPT_POLYGON: self = .polygon
        case SHPT_MULTIPOINT: self = .multipoint
        case SHPT_POINTZ: self = .pointZ
        case SHPT_ARCZ: self = .arcZ
        case SHPT_POLYGONZ: self = .polygonZ
        case SHPT_MULTIPOINTZ:  self = .multipointZ
        case SHPT_POINTM: self = .pointM
        case SHPT_ARCM: self = .arcM
        case SHPT_POLYGONM: self = .polygonM
        case SHPT_MULTIPOINTM: self = .multipointM
        case SHPT_MULTIPATCH: self = .multipatch
        default: throw Error.unknownShapeType(type: type)
        }
    }

    public enum Dimensionality { case none, flat, volume, measure, complex }
    public var dimensionality: Dimensionality {
        switch self {
        case .null: return .none
        case .point, .arc, .polygon, .multipoint: return .flat
        case .pointZ, .arcZ, .polygonZ, .multipointZ: return .volume
        case .pointM, .arcM, .polygonM, .multipointM: return .measure
        case .multipatch: return .complex
        }
    }
}

public enum PartType {
    case triStrip
    case triFan
    case outerRing
    case innerRing
    case firstRing
    case ring
}

extension PartType {

    init(type: Int32) throws {
        switch type {
        case SHPP_TRISTRIP: self = .triStrip
        case SHPP_TRIFAN: self = .triFan
        case SHPP_OUTERRING: self = .outerRing
        case SHPP_INNERRING: self = .innerRing
        case SHPP_FIRSTRING: self = .firstRing
        case SHPP_RING: self = .ring
        default: throw Error.unknownPartType(type: type)
        }
    }

}
