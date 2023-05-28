#[
    scene setup for 13.1 in the Ray Tracing in One Weekend
]#

import math
import strformat

import ../camera
import ../hittable_list
import ../material
import ../misc
import ../rand
import ../ray
import ../renderable_object
import ../vec3


proc writeColor*(outputFile: File, pixelColor: var Color, samplesPerPixel: int) =
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

proc render_13_1*() =
    const
        # output image setup
        aspectRatio: float = 3.0 / 2.0
        imageWidth: int = 300 #1200
        imageHeight: int = int(float(imageWidth) / aspectRatio)

        samplesPerPixel: int = 50 #500
        maxDepth: int = 5 #50

    var
        lookFrom: Point3 = newPoint3(13, 2, 3)
        lookAt: Point3 = newPoint3(0, 0, 0)
        vup: Vec3 = newVec3(0, 1, 0)
        distToFocus: float64 = 10.0
        aperture: float64 = 0.1

        # camera setup
        cam: Camera = newCamera(
            lookFrom=lookFrom,
            lookAt=lookAt,
            vup=vup,
            vfov=20.0,
            aspectRatio=aspectRatio,
            aperture=aperture,
            focusDist=distToFocus
        )

        # world object
        world: HittableList = newHittableList()

        materialGround: Lambertian = newLambertian(newColor(0.5, 0.5, 0.5))
        material1: Dielectric = newDielectric(1.5)
        material2: Lambertian = newLambertian(newColor(0.4, 0.2, 0.1))
        material3: Metal = newMetal(newColor(0.7, 0.6, 0.5), 0.0)

        r: Ray
        pixelColor: Color
        u, v: float64

    # add objects in the world
    world.add(newSphere(newPoint3( 0.0, -1000.0, -1.0), 1000.0, materialGround))

    world.add(newSphere(newPoint3( 0.0, 1.0, 0.0), 1.0, material1))
    world.add(newSphere(newPoint3(-4.0, 1.0, 0.0), 1.0, material2))
    world.add(newSphere(newPoint3( 4.0, 1.0, 0.0), 1.0, material3))

    # add random small balls
    for a in -11..<11:
        for b in -11..<11:
            var
                chooseMat: float64 = rand()
                center: Point3 = newPoint3(float64(a)+0.9*rand(), 0.2, float64(b)+0.9*rand())

            if (center-newPoint3(4, 0.2, 0)).length() > 0.9:
                var sphereMaterial: Material

                if chooseMat < 0.8:
                    # diffuse
                    sphereMaterial = newLambertian(vec3.random()*vec3.random())
                    world.add(newSphere(center, 0.2, sphereMaterial))
                elif choose_mat < 0.95:
                    # metal
                    sphereMaterial = newMetal(random(0.5, 1), rand(0, 0.5))
                    world.add(newSphere(center, 0.2, sphereMaterial))
                else:
                    # glass
                    sphereMaterial = newDielectric(1.5)
                    world.add(newSphere(center, 0.2, sphereMaterial))

    var outputFile : File = open("./outputs/scene_13_1.ppm", FileMode.fmWrite)
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
