#[
    scene setup for 5.1 in the Ray Tracing in One Weekend
]#

import strformat

import ../misc
import ../ray
import ../vec3


proc write_color(outputFile: File, pixelColor: Color) = 
    outputFile.write(fmt"{int(pixelColor.r()*255.999)} {int(pixelColor.g()*255.999)} {int(pixelColor.b()*255.999)}{'\n'}")

proc hitSphere(center: Point3, radius: float64, r: Ray): bool =
    var
        oc: Vec3 = r.origin() - center
        a: float64 = dot(r.direction(), r.direction())
        b: float64 = 2.0 * dot(oc, r.direction())
        c: float64 = dot(oc, oc) - radius*radius
        discriminant: float64 = b*b - 4*a*c

    return (discriminant > 0)

proc ray_color(r: Ray): Color =
    if hitSphere(newPoint3(0,0,-1), 0.5, r):
        return newColor(1, 0, 0)

    var
        unitDirection: Vec3 = unitVector(r.direction())
        t: float64 = 0.5*(unitDirection[1] + 1.0)

    return (1.0-t) * newColor(1.0, 1.0, 1.0) + t*newColor(0.5, 0.7, 1.0)

proc render_5_1*() =
    const
        # output image setup
        aspectRatio: float = 16.0 / 9.0
        imageWidth: int = 400
        imageHeight: int = int(float(imageWidth) / aspectRatio)

    var
        # camera setup
        viewportHeight: float = 2.0
        viewportWidth: float = aspectRatio * viewportHeight
        focalLength: float = 1.0

        # screen
        #screen: array[0..<imageHeight, array[0..<imageWidth, Color]]

        origin: Point3 = newPoint3(0, 0, 0)
        horizontal: Vec3 = newVec3(viewportWidth, 0, 0)
        vertical: Vec3 = newVec3(0, viewportHeight, 0)
        lowerLeftCorner: Vec3 = origin - horizontal/2 - vertical/2 - newVec3(0, 0, focalLength)

        r: Ray
        c: Color
        u, v: float64


    var outputFile : File = open("./outputs/scene_5_1.ppm", FileMode.fmWrite)
    write(outputFile, fmt"P3{'\n'}{imageWidth} {imageHeight}{'\n'}255{'\n'}")

    for h in countdown(imageHeight-1, 0):
        for w in 0..<imageWidth:
            u = float64(w/(imageWidth-1))
            v = float64(h/(imageHeight-1))

            r = newRay(origin, lowerLeftCorner + u*horizontal + v*vertical - origin)
            c = ray_color(r);

            writeColor(outputFile, c)

    outputFile.close()
