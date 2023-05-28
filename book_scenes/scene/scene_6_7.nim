#[
    scene setup for 6.7 in the Ray Tracing in One Weekend
]#

import strformat

import ../hittable_list_legacy
import ../material
import ../misc
import ../ray
import ../renderable_object_legacy
import ../vec3


proc writeColor(outputFile: File, pixelColor: Color) = 
    outputFile.write(fmt"{int(pixelColor.r()*255.999)} {int(pixelColor.g()*255.999)} {int(pixelColor.b()*255.999)}{'\n'}")


proc rayColor(r: Ray, world: HittableList): Color =
    var rec: HitRecord

    if world.hit(r, 0, Inf, rec):
        return 0.5 * (rec.normal + newColor(1, 1, 1))

    var
        unitDirection: Vec3 = unitVector(r.direction())
        t: float64 = 0.5*(unitDirection.y() + 1.0);

    return (1.0-t) * newColor(1.0, 1.0, 1.0) + t*newColor(0.5, 0.7, 1.0)

proc render_6_7*() =
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

        # world object
        world: HittableList = newHittableList()

        origin: Point3 = newPoint3(0, 0, 0)
        horizontal: Vec3 = newVec3(viewportWidth, 0, 0)
        vertical: Vec3 = newVec3(0, viewportHeight, 0)
        lowerLeftCorner: Vec3 = origin - horizontal/2 - vertical/2 - newVec3(0, 0, focalLength)

        r: Ray
        pixelColor: Color
        u, v: float64

    # add objects in the world
    world.add(newSphere(newPoint3(0, 0, -1), 0.5))
    world.add(newSphere(newPoint3(0, -100.5, -1), 100.0))

    var outputFile : File = open("./outputs/scene_6_7.ppm", FileMode.fmWrite)
    write(outputFile, fmt"P3{'\n'}{imageWidth} {imageHeight}{'\n'}255{'\n'}")

    for h in countdown(imageHeight-1, 0):
        for w in 0..<imageWidth:
            u = float64(w/(imageWidth-1))
            v = float64(h/(imageHeight-1))

            r = newRay(origin, lowerLeftCorner + u*horizontal + v*vertical)
            pixelColor = rayColor(r, world)

            writeColor(outputFile, pixelColor)

    outputFile.close()
