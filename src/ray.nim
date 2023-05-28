import vec3


type Ray* = ref object of RootObj
    orig: Point3
    dir: Vec3

proc newRay*(orig: Point3, dir: Vec3): Ray =
    return Ray(orig: orig, dir: dir)

proc origin*(r: Ray): Vec3 =
    return r.orig

proc direction*(r: Ray): Vec3 =
    return r.dir

proc at*(r: Ray, t: float64): Vec3 =
    return r.orig + t*r.dir
