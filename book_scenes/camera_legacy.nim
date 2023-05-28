import math

import misc
import ray
import vec3

type Camera* = ref object of RootObj    
    origin: Point3
    aspectRatio: float
    viewportHeight: float
    viewportWidth: float
    focalLength: float

    horizontal: Vec3
    vertical: Vec3
    lowerLeftCorner: Vec3

proc newCamera*(
    aspectRatio: float = 16.0 / 9.0,
    viewportHeight: float = 2.0,
    viewportWidth: float = 2.0 * (16.0/9.0),
    focalLength: float = 1.0
): Camera =
    var
        origin: Point3 = newPoint3(0, 0, 0)
        horizontal: Vec3 = newVec3(viewportWidth, 0, 0)
        vertical: Vec3 = newVec3(0, viewportHeight, 0)
        lowerLeftCorner: Vec3 = origin - horizontal/2 - vertical/2 - newVec3(0, 0, focalLength)

    return Camera(
        origin: origin,
        aspectRatio: aspectRatio,
        viewportHeight: viewportHeight,
        viewportWidth: viewportWidth,
        focalLength: focalLength,
        horizontal: horizontal,
        vertical: vertical,
        lowerLeftCorner: lowerLeftCorner
    )

proc newCamera*(vfov: float64, aspectRatio: float64, focalLength: float = 1.0): Camera =
    # vfoc: vertical field-of-view in degrees

    var
        theta: float64 = degreesToRadians(vfov)
        h: float64 = tan(theta/2.0)
        viewportHeight: float64 = 2.0 * h
        viewportWidth: float64 = aspectRatio * viewportHeight

        origin: Point3 = newPoint3(0, 0, 0)
        horizontal: Vec3 = newVec3(viewportWidth, 0, 0)
        vertical: Vec3 = newVec3(0, viewportHeight, 0)
        lowerLeftCorner: Vec3 = origin - horizontal/2 - vertical/2 - newVec3(0, 0, focalLength)

    return Camera(
        origin: origin,
        aspectRatio: aspectRatio,
        viewportHeight: viewportHeight,
        viewportWidth: viewportWidth,
        focalLength: focalLength,
        horizontal: horizontal,
        vertical: vertical,
        lowerLeftCorner: lowerLeftCorner
    )

proc newCamera*(
    lookFrom: Point3,
    lookAt: Point3,
    vup: Vec3,
    vfov: float64,
    aspectRatio: float64,
    focalLength: float = 1.0
): Camera =
    # vfoc: vertical field-of-view in degrees

    var
        theta: float64 = degreesToRadians(vfov)
        h: float64 = tan(theta/2.0)
        viewportHeight: float64 = 2.0 * h
        viewportWidth: float64 = aspect_ratio * viewport_height

        origin: Point3 = newPoint3(0, 0, 0)
        horizontal: Vec3 = newVec3(viewportWidth, 0, 0)
        vertical: Vec3 = newVec3(0, viewportHeight, 0)
        lowerLeftCorner: Vec3 = origin - horizontal/2 - vertical/2 - newVec3(0, 0, focalLength)

    return Camera(
        origin: origin,
        aspectRatio: aspectRatio,
        viewportHeight: viewportHeight,
        viewportWidth: viewportWidth,
        focalLength: focalLength,
        horizontal: horizontal,
        vertical: vertical,
        lowerLeftCorner: lowerLeftCorner
    )

proc moveTo*(this: var Camera, x: float64, y: float64, z: float64) =
    this.origin[0] = x
    this.origin[1] = y
    this.origin[2] = z

proc getRay*(this: Camera, u: float64, v: float64): Ray =
    return newRay(this.origin, this.lowerLeftCorner + u*this.horizontal + v*this.vertical)
