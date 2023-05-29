import strformat
import threadpool
{.experimental: "parallel".}

import rand
import vec3
import camera, film
import hittable_list, material
import ray
import io/ppm


type Renderer* = ref object of RootObj
    camera*: Camera
    world*: HittableList
    samplesPerPixel*: int
    maxDepth*: int

proc newRenderer*(
    camera: Camera,
    world: HittableList,
    samplesPerPixel: int,
    maxDepth: int
): Renderer =
    return Renderer(
        camera: camera,
        world: world,
        samplesPerPixel: samplesPerPixel,
        maxDepth: maxDepth
    )

proc rayColor(world: HittableList, r: Ray, depth: int): Color =
    if depth <= 0:
        return newColor(0, 0, 0)

    var
        rec: HitRecord
        scattered: Ray
        attenuation: Color

    if world.hit(r, 0.001, Inf, rec):
        if rec.mat.scatter(r, rec, attenuation, scattered):
            return attenuation * rayColor(world, scattered, depth-1)

        return newColor(0, 0, 0)

    var
        unitDirection: Vec3 = unitVector(r.direction())
        t: float64 = 0.5*(unitDirection.y() + 1.0);

    return (1.0-t) * newColor(1.0, 1.0, 1.0) + t*newColor(0.5, 0.7, 1.0)

proc threadCompute(
    this: Renderer,
    panePixels: var seq[Color],
    width: int,
    height: int,
    samplesPerPixel: int
) =
    var
        u, v: float64
        pixelColor = newColor(0, 0, 0)

    for h in countdown(height-1, 0):
        for w in 0..<width:
            pixelColor.setToZero()

            for i in 0..<samplesPerPixel:
                u = (float64(w)+rand())/float64(this.camera.film.width-1)
                v = (float64(h)+rand())/float64(this.camera.film.height-1)

                pixelColor += rayColor(this.world, this.camera.getRay(u, v), this.maxDepth)

            panePixels[h*width + w].setTo(pixelColor)

proc compute*(this: var Renderer) =
    ## compute the raytracing in single core.
    var
        width: int = this.camera.film.width
        height: int = this.camera.film.height

        u, v: float64
        pixelColor: Color = newColor(0, 0, 0)

    # clear the remaining image on film
    this.camera.film.clear()

    for h in countdown(height-1, 0):
        stdout.write("\rScanlines remaining: ", fmt"{h:>3}")
        flushFile(stdout)

        for w in 0..<width:
            pixelColor.setToZero()

            for i in 0..<this.samplesPerPixel:
                u = (float64(w)+rand())/float64(width-1)
                v = (float64(h)+rand())/float64(height-1)

                pixelColor += rayColor(this.world, this.camera.getRay(u, v), this.maxDepth)

            this.camera.film[h*width + w] = this.camera.film[h*width + w]+pixelColor

    stdout.write("\n")

proc compute*(this: Renderer, threadNum: int) =
    ## compute the raytracing with given thread nums
    ## compare to the single thread, this result in little bit darker.
    var
        width = this.camera.film.width
        height = this.camera.film.height

        # ignoring fraction
        samplePerThread = int(this.samplesPerPixel/threadNum)
        parallelColor: seq[seq[Color]] = @[]

    for th in 0..<threadNum:
        parallelColor.add(newSeq[Color](width*height))
        for i in 0..<height*width:
            parallelColor[th][i] = newColor(0, 0, 0)

    # clear the remaining image on film
    this.camera.film.clear()

    parallel:
        for th in 0..<threadNum:
            spawn(this.threadCompute(parallelColor[th], width, height, samplePerThread))
        sync()

    for th in 0..<threadNum:
        for i in 0..<height*width:
                this.camera.film[i] = this.camera.film[i]+parallelColor[th][i]

proc saveImage*(this: Renderer, filePath: string) =
    saveImagePPM(filePath, this.camera.film, this.samplesPerPixel)
