
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
    print(shapefile, shapefile.count)

    let shape = shapefile[0]
    print(shape)
} catch {
    print(error)
}
