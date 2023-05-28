import math


proc degreesToRadians*(degrees: float64): float64 =
    return degrees * PI / 180.0

proc clamp*(x: float64, min: float64, max: float64): float64 =
    if x < min: return min
    if x > max: return max
    return x
