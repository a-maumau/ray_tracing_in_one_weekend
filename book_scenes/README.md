Some of structures of files (codes) are may different because current nim version (1.16.2) can not handle cyclic imports.

This codes are just for reproducing the book's all scenes.

# Usage
```
> make

# all contained scene will be rendered so it will take some time to run
> make run
```

because scene 13.1 (final) will take too much time with single thread processing, the sampling and resolution are set to relatively low values.
if you only want to see specific scenes, please comment out some lines in the main.nim. 
