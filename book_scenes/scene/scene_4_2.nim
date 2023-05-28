#[
    scene setup for 4.2 in the Ray Tracing in One Weekend
]#

import strformat

import ../misc
import ../ray
import ../vec3


proc write_color(outputFile: File, pixelColor: Color) = 
    outputFile.write(fmt"{int(pixelColor.r()*255.999)} {int(pixelColor.g()*255.999)} {int(pixelColor.b()*255.999)}{'\n'}")

proc ray_color(r: Ray): Color =
    var
        unitDirection: Vec3 = unitVector(r.direction())
        t: float64 = 0.5*(unitDirection[1] + 1.0)

    return (1.0-t) * newColor(1.0, 1.0, 1.0) + t*newColor(0.5, 0.7, 1.0)

proc render_4_2*() =
    const
        # output image setup
        aspectRatio = 16.0 / 9.0
        imageWidth = 400
        imageHeight = int(imageWidth / aspectRatio)

    var
        # camera setup
        viewportHeight: auto = 2.0
        viewportWidth: auto = aspectRatio * viewportHeight
        focalLength = 1.0

        # screen
        #screen: array[0..<imageHeight, array[0..<imageWidth, Color]]

        origin = newPoint3(0, 0, 0)
        horizontal = newVec3(viewportWidth, 0, 0)
        vertical = newVec3(0, viewportHeight, 0)
        lowerLeftCorner = origin - horizontal/2 - vertical/2 - newVec3(0, 0, focalLength)

        r: Ray
        c: Color
        u, v: float64


    var outputFile : File = open("./outputs/scene_4_2.ppm", FileMode.fmWrite)
    write(outputFile, fmt"P3{'\n'}{imageWidth} {imageHeight}{'\n'}255{'\n'}")

    for h in countdown(imageHeight-1, 0):
        for w in 0..<imageWidth:
            u = float64(w/(imageWidth-1))
            v = float64(h/(imageHeight-1))

            r = newRay(origin, lowerLeftCorner + u*horizontal + v*vertical - origin)
            c = ray_color(r);

            writeColor(outputFile, c)

    outputFile.close()
