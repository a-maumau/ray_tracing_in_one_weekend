import std/random


proc rand*(): float64 =
    ## return [0, 1)
    return rand(0.999999999)

proc rand*(minVal: float64, maxVal: float64): float64 =
    ## return [minVal, maxVal)
    return minVal + (maxVal-minVal)*rand()
