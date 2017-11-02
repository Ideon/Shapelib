//
//  ShapelibError.swift
//  ShapeResearchPackageDescription
//
//  Created by Hans Petter Eikemo on 01/11/2017.
//

import Foundation


enum Error: Swift.Error {

    case notImplemented(message: String)

    case inaccessibleFile(filePath: String)
    case unknownShapeType(type: Int32)
    case unknownPartType(type: Int32)
    case unknownFieldType(type: UInt32)

}
