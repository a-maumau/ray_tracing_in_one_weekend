#[
    scene setup for 11.1 in the Ray Tracing in One Weekend
]#

import math
import strformat

import ../camera_legacy
import ../hittable_list
import ../material
import ../misc
import ../rand
import ../ray
import ../renderable_object
import ../vec3


proc writeColor(outputFile: File, pixelColor: var Color, samplesPerPixel: int) =
    # divide the color by the number of samples.
    var
        scale: float64 = 1.0 / float64(samplesPerPixel)
        r: float64 = sqrt(pixelColor.r()*scale)
        g: float64 = sqrt(pixelColor.g()*scale)
        b: float64 = sqrt(pixelColor.b()*scale)

    outputFile.write(fmt"{int(clamp(r, 0.0, 0.999)*255.999)} ")
    outputFile.write(fmt"{int(clamp(g, 0.0, 0.999)*255.999)} ")
    outputFile.write(fmt"{int(clamp(b, 0.0, 0.999)*255.999)}{'\n'}")

proc rayColor(r: Ray, world: HittableList, depth: int): Color =
    if depth <= 0:
        return newColor(0, 0, 0)

    var
        rec: HitRecord
        scattered: Ray
        attenuation: Color

    if world.hit(r, 0.001, Inf, rec):
        if rec.mat.scatter(r, rec, attenuation, scattered):
            return attenuation * rayColor(scattered, world, depth-1)

        return newColor(0, 0, 0)

    var
        unitDirection: Vec3 = unitVector(r.direction())
        t: float64 = 0.5*(unitDirection.y() + 1.0);

    return (1.0-t) * newColor(1.0, 1.0, 1.0) + t*newColor(0.5, 0.7, 1.0)

proc render_11_1*() =
    const
        # output image setup
        aspectRatio: float = 16.0 / 9.0
        imageWidth: int = 400
        imageHeight: int = int(float(imageWidth) / aspectRatio)

        #viewportHeight: float = 2.0
        #viewportWidth: float = aspectRatio * viewportHeight
        focalLength: float = 1.0

        samplesPerPixel = 100
        maxDepth = 20
    var
        # camera setup
        cam: Camera = newCamera(vfov=90.0, aspectRatio=aspectRatio, focalLength=focalLength)

        # world object
        world: HittableList = newHittableList()

        R: float64 = cos(PI/4)
        materialLeft: Lambertian = newLambertian(newColor(0, 0, 1))
        materialRight: Lambertian = newLambertian(newColor(1, 0, 0))

        r: Ray
        pixelColor: Color
        u, v: float64

    # add objects in the world
    world.add(newSphere(newPoint3(-R,    0.0, -1.0),   R, materialLeft))
    world.add(newSphere(newPoint3( R,    0.0, -1.0),   R, materialRight))

    var outputFile : File = open("./outputs/scene_11_1.ppm", FileMode.fmWrite)
    write(outputFile, fmt"P3{'\n'}{imageWidth} {imageHeight}{'\n'}255{'\n'}")

    for h in countdown(imageHeight-1, 0):
        stdout.write("\rScanlines remaining: ", fmt"{h:>3}")
        flushFile(stdout)
        for w in 0..<imageWidth:
            pixelColor = newColor(0, 0, 0)

            for sample_i in 0..<samplesPerPixel:
                u = float64((float64(w)+rand())/(imageWidth-1))
                v = float64((float64(h)+rand())/(imageHeight-1))

                r = cam.getRay(u, v);
                pixelColor += rayColor(r, world, maxDepth)

            writeColor(outputFile, pixelColor, samplesPerPixel)

    stdout.write("\n")

    outputFile.close()