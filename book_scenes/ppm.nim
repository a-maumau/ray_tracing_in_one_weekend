#[
    http://paulbourke.net/dataformats/ppm/
]#

import strformat

import misc

proc test_saveImage*(fileName: string, height: int, width: int) =
    var outputFile : File = open(fileName, FileMode.fmWrite)
    var r, g, b: float64

    write(outputFile, fmt"P3{'\n'}{width} {height}{'\n'}255{'\n'}")

    for h in countdown(height-1, 0):
        for w in 0..<width:
            r = float(w/(width-1)) * 255.999
            g = float(h/(height-1)) * 255.999
            b = 0.25*255.999

            write(outputFile, fmt"{int(r)} {int(g)} {int(b)}{'\n'}")

    outputFile.close()

proc test_saveImageWithColor*(fileName: string, height: int, width: int) =
    var outputFile : File = open(fileName, FileMode.fmWrite)

    write(outputFile, fmt"P3{'\n'}{width} {height}{'\n'}255{'\n'}")

    var c: Color
    for h in countdown(height-1, 0):
        for w in 0..<width:
            c = newColor(float(w/(width-1)) * 255.999, float(h/(height-1)) * 255.999, 0.25*255.999)

            write(outputFile, fmt"{int(c.r())} {int(c.g())} {int(c.b())}{'\n'}")

    outputFile.close()
