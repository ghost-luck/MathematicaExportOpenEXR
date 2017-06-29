## Description

Tiny Mathematica package for exporting OpenEXR files.

| Type        | 32-bit float |
|-------------|--------------|
| Compression | none         |
| Channels    | 3 RGB only   |

## Installation

Place `Export.m` in the folder `$UserBaseDirectory/Formats/OpenEXR`

## Usage
```
coneflower = Import["ExampleData/coneflower.jpg"];
Export["test.exr", coneflower, "OpenEXR"];
```
