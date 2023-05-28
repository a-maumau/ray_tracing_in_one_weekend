import vec3
import renderable_object, material
import ray


type HittableList* = ref object of Hittable
    renderObjects: seq[Hittable]

proc newHittableList*(objs: seq[Hittable] = @[], initSize: int = 32): HittableList =
    return HittableList(renderObjects: objs)

proc add*(this: HittableList, obj: Hittable) =
    this.renderObjects.add(obj)

proc clear*(this: HittableList) = 
    this.renderObjects.setLen(0)

proc hit*(this: HittableList, r: Ray, t_min: float64, t_max: float64, rec: var HitRecord): bool =
    var
        tempRec: HitRecord = newHitRecord(newPoint3(0, 0, 0), newVec3(0, 0, 0), 0.0)
        hitAnything: bool = false
        closestSoFar: float64 = t_max

    for obj in this.renderObjects:
        if obj.hit(r, t_min, closestSoFar, tempRec):
            hitAnything = true
            closestSoFar = tempRec.t
            rec = tempRec

    return hitAnything
