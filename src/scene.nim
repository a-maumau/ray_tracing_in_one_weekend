#[
    scene setup for 13.1 in the Ray Tracing in One Weekend
]#
import std/cpuinfo
import system

import rand
import vec3
import camera, film, render
import renderable_object, hittable_list, material


proc createCamera(film: Film): Camera = 
    var
        lookFrom: Point3 = newPoint3(13, 2, 3)
        lookAt: Point3 = newPoint3(0, 0, 0)
        vup: Vec3 = newVec3(0, 1, 0)
        distToFocus: float64 = 10.0
        aperture: float64 = 0.1

        # camera setup
        cam: Camera = newCamera(
            film=film,
            lookFrom=lookFrom,
            lookAt=lookAt,
            vup=vup,
            vfov=20.0,
            aperture=aperture,
            focusDist=distToFocus
        )

    return cam

proc createWorld(): HittableList =
    var
        # world object
        world: HittableList = newHittableList()

        materialGround: Lambertian = newLambertian(newColor(0.5, 0.5, 0.5))
        material1: Dielectric = newDielectric(1.5)
        material2: Lambertian = newLambertian(newColor(0.4, 0.2, 0.1))
        material3: Metal = newMetal(newColor(0.7, 0.6, 0.5), 0.0)

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

    return world

proc renderScene*() =
    const
        # output image setup
        aspectRatio: float = 3.0 / 2.0
        imageWidth: int = 300 #1200
        imageHeight: int = int(float(imageWidth) / aspectRatio)

        samplesPerPixel: int = 128 #512
        maxDepth: int = 64

    var
        film: Film = newFilm(imageWidth, imageHeight)

        # camera setup
        cam: Camera

        # world object
        world: HittableList

        renderer: Renderer

    cam = createCamera(film)
    world = createWorld()
    renderer = newRenderer(cam, world, samplesPerPixel, maxDepth)

    # run with all core
    renderer.compute(threadNum=countProcessors())
    renderer.saveImage("./outputs/rendered_img.ppm")
