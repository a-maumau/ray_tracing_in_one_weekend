import math

import misc
import ray
import vec3

type Camera* = ref object of RootObj    
    origin: Point3

    horizontal: Vec3
    vertical: Vec3
    u, v, w: Vec3
    lowerLeftCorner: Point3

    lensRadius: float64
    focalLength: float64

proc newCamera*(
    lookFrom: Point3,
    lookAt: Point3,
    vup: Vec3,
    vfov: float64,
    aspectRatio: float64,
    aperture: float64,
    focusDist: float64 = 1.0
): Camera =
    # vfoc: vertical field-of-view in degrees

    var
        theta: float64 = degreesToRadians(vfov)
        h: float64 = tan(theta/2.0)
        viewportHeight: float64 = 2.0 * h
        viewportWidth: float64 = aspectRatio * viewportHeight

        w: Vec3 = unitVector(lookFrom - lookAt)
        u: Vec3 = unitVector(cross(vup, w))
        v: Vec3 = cross(w, u)

        horizontal: Vec3 = focusDist*viewportWidth*u
        vertical: Vec3 = focusDist*viewportHeight*v
        lowerLeftCorner: Vec3 = lookFrom - horizontal/2 - vertical/2 - focusDist*w

    return Camera(
        origin: lookFrom,
        horizontal: horizontal,
        vertical: vertical,
        u:u,
        v:v,
        w:w,
        lowerLeftCorner: lowerLeftCorner,
        lensRadius: aperture / 2.0
    )

proc moveTo*(this: var Camera, x: float64, y: float64, z: float64) =
    this.origin[0] = x
    this.origin[1] = y
    this.origin[2] = z

proc getSimpleRay*(this: Camera, s: float64, t: float64): Ray =
    return newRay(this.origin, this.lowerLeftCorner + s*this.horizontal + t*this.vertical - this.origin)

proc getRay*(this: Camera, s: float64, t: float64): Ray =
    var
        rd: Vec3 = this.lensRadius * randomInUnitDisk()
        offset: Vec3 = this.u * rd.x() + this.v * rd.y()

    return newRay(this.origin+offset, this.lowerLeftCorner + s*this.horizontal + t*this.vertical - this.origin - offset)
