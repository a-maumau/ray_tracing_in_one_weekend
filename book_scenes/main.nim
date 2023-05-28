import ppm
import scene/scene_4_2
import scene/scene_5_1
import scene/scene_6_1
import scene/scene_6_7
import scene/scene_7_2
import scene/scene_8_2
import scene/scene_8_3
import scene/scene_8_5
import scene/scene_8_6
import scene/scene_9_5
import scene/scene_9_6
import scene/scene_10_3
import scene/scene_10_5
import scene/scene_11_1
import scene/scene_11_2
import scene/scene_13_1

if isMainModule:
    echo "running ppm test output"
    test_saveImage("./outputs/test_output.ppm", 256, 256)
    test_saveImageWithColor("./outputs/test_output_with_color.ppm", 256, 256)

    echo "running scene 4.2"
    render_4_2()
    echo "running scene 5.1"
    render_5_1()
    echo "running scene 6.1"
    render_6_1()
    echo "running scene 6.7"
    render_6_7()
    echo "running scene 7.2"
    render_7_2()
    echo "running scene 8.2"
    render_8_2()
    echo "running scene 8.3"
    render_8_3()
    echo "running scene 8.5"
    render_8_5()
    echo "running scene 8.6"
    render_8_6()
    echo "running scene 9.5"
    render_9_5()
    echo "running scene 9.6"
    render_9_6()
    echo "running scene 10.3"
    render_10_3()
    echo "running scene 10.5"
    render_10_5()
    echo "running scene 11.1"
    render_11_1()
    echo "running scene 11.2"
    render_11_2()
    echo "running scene 13.1"
    render_13_1()
