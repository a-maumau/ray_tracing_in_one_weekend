import math

import material
import misc
import ray
import vec3

type Hittable* = ref object of RootObj
    p: Point3
    normal: Vec3
    t: float64

method hit*(this: Hittable, r: Ray, t_min: float64, t_max: float64, rec: HitRecord): bool {.base.} =
    raiseAssert("you need impl. this function.")

type Sphere* = ref object of Hittable
    center: Point3
    radius: float64

proc newSphere*(center: Point3, radius: float64): Sphere =
    return Sphere(center: center, radius: radius)

method hit*(this: Sphere, r: Ray, t_min: float64, t_max: float64, rec: HitRecord): bool =
    var
        oc: Vec3 = r.origin() - this.center

        a: float64 = r.direction().lengthSquared()
        halfB: float64 = dot(oc, r.direction())
        c: float64 = oc.lengthSquared() - this.radius*this.radius

        discriminant: float64 = halfB*halfB - a*c;

    if discriminant < 0:
        return false
    
    var
        sqrtd: float64 = sqrt(discriminant)
        root: float64 = (-half_b - sqrtd) / a

    # find the nearest root that lies in the acceptable range (t_min, t_max)
    if root < t_min or t_max < root:
        root = (-half_b + sqrtd) / a

        if root < t_min or t_max < root:
            return false

    rec.t = root
    rec.p = r.at(rec.t)
    rec.normal = (rec.p - this.center) / this.radius

    return true
