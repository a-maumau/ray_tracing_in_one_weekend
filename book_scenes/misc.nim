import math

import vec3


type
    Point3* = Vec3
    Color* = Vec3

proc newPoint3*(e1: float64 = 0.0, e2: float64 = 0.0, e3: float64 = 0.0): Point3 =
    return Point3(e: [e1, e2, e3])

proc newColor*(e1: float64 = 0.0, e2: float64 = 0.0, e3: float64 = 0.0): Color =
    return Color(e: [e1, e2, e3])

proc x*(p: Point3): float64 =
    return p.e[0]

proc y*(p: Point3): float64 =
    return p.e[1]

proc z*(p: Point3): float64 =
    return p.e[2]

proc r*(c: Color): float64 =
    return c.e[0]

proc g*(c: Color): float64 =
    return c.e[1]

proc b*(c: Color): float64 =
    return c.e[2]

proc degreesToRadians*(degrees: float64): float64 =
    return degrees * PI / 180.0

proc clamp*(x: float64, min: float64, max: float64): float64 =
    if x < min: return min
    if x > max: return max
    return x
