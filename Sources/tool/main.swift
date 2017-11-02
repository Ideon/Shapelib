
import Shapelib
import Foundation
import simd

let arguments = CommandLine.arguments[1...]
guard let path = arguments.last else { 
	print("No path provided")
	exit(0)
}

do {
    let shapefile = try Shapefile(at: path)

    print("Available fields")

    

    for field in shapefile.fields {

        print(field.fieldName, field.type, "example:", try shapefile.attribute(named: field.fieldName, forShape: 0) ?? "nil")
    }

    for shape in shapefile.allShapes {
        print(shape.shapeIndex, shape.attributes["FORMAL_EN"] ?? "nil", shape.attributes["SU_A3"] ?? "nil", shape.attributes["SOV_A3"] ?? "nil")
    }
//    print(shapefile, shapefile.count)

//    let shape = shapefile[0]
//    print(shape)
} catch {
    print(error)
}
