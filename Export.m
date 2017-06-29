(* ::Package:: *)

writeExr[filename_, image_] := 
 Module[{file, w, h, r, g, b, offsetTable, joinScanlines, writeOffset,
    offsetT, scanlines, writeScanlines},
  
  file = filename;
  {w, h} = ImageDimensions[image];
  {r, g, b} = Map[ImageData, ColorSeparate[image]];
  offsetTable[{w_, h_}] := Module[{nums, i, calcOffset, tableSize},
    nums = Table[i - 1, {i, 1, h}];
    tableSize = 8*h;
    calcOffset[scanlinenum_] := 
     313 + tableSize + scanlinenum*(4 + 4 + 3*w*4);
    Map[calcOffset, nums]
    ];
  joinScanlines[{colorOne_, colorTwo_, colorThree_}, height_] := 
   Module[{indexes, i, joinF},
    indexes = Table[i, {i, 1, height}];
    joinF[ind_] := 
     Join[colorOne[[ind]], colorTwo[[ind]], colorThree[[ind]]];
    Map[joinF, indexes]
    ];
  writeOffset[offset_] := 
   BinaryWrite[file, offset, "UnsignedInteger64"];
  
  writeScanlines[scanlines_] := 
   Module[{size, nums, data, writeScanlinePixels},
    size = 3*w*4;
    nums = Table[i - 1, {i, 1, h}];
    data = Transpose[{scanlines, nums}];
    writeScanlinePixels[{scanline_, y_}] := Module[{},
      BinaryWrite[file, y, "Integer32"];(*scanline number*)
      BinaryWrite[file, size, "Integer32"];(*scanline size*)
      BinaryWrite[file, scanline, "Real32"];
      ];
    Map[writeScanlinePixels, data]
    ];
  
  offsetT = offsetTable[{w, h}];
  scanlines = joinScanlines[{b, g, r}, h];
  
  BinaryWrite[file, 20000630, "Integer32"];(*OpenEXR magick number*)
  BinaryWrite[file, 2, "UnsignedInteger32"];(*OpenEXR version*)
  BinaryWrite[file, "channels", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "chlist", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 55, "Integer32"];(*attribute size*)
  BinaryWrite[file, "B", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 2, "Integer32"];(*pixel type: UINT=0, HALF=1, 
  FLOAT=2*)
  BinaryWrite[file, 0, "UnsignedInteger32"];(*pLinear*)
  BinaryWrite[file, 1, "UnsignedInteger32"];(*xSampling*)
  BinaryWrite[file, 1, "UnsignedInteger32"];(*ySampling*)
  BinaryWrite[file, "G", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 2, "Integer32"];
  BinaryWrite[file, 0, "UnsignedInteger32"];
  BinaryWrite[file, 1, "UnsignedInteger32"];
  BinaryWrite[file, 1, "UnsignedInteger32"];
  BinaryWrite[file, "R", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 2, "Integer32"];
  BinaryWrite[file, 0, "UnsignedInteger32"];
  BinaryWrite[file, 1, "UnsignedInteger32"];
  BinaryWrite[file, 1, "UnsignedInteger32"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "compression", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "compression", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 1, "UnsignedInteger32"];(*attribute size*)
  BinaryWrite[file, 0, "UnsignedInteger8"];(*NO_COMPRESSION=0*)
  BinaryWrite[file, "dataWindow", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "box2i", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 16, "Integer32"];(*attribute size*)
  BinaryWrite[file, 0, "Integer32"];(*xMin*)
  BinaryWrite[file, 0, "Integer32"];(*yMin*)
  BinaryWrite[file, w - 1, "Integer32"];(*xMax = x-1*)
  BinaryWrite[file, h - 1, "Integer32"];(*yMax = y-1*)
  BinaryWrite[file, "displayWindow", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "box2i", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 16, "Integer32"];(*attribute size*)
  BinaryWrite[file, 0, "Integer32"];(*xMin*)
  BinaryWrite[file, 0, "Integer32"];(*yMin*)
  BinaryWrite[file, w - 1, "Integer32"];(*xMax = x-1*)
  BinaryWrite[file, h - 1, "Integer32"];(*yMax = y-1*)
  BinaryWrite[file, "lineOrder", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "lineOrder", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 1, "Integer32"];(*attribute size*)
  BinaryWrite[file, 0, "Integer8"];(*INCREASING_Y=0, DECREASING_Y=1, RANDOM_Y=2*)
  BinaryWrite[file, "pixelAspectRatio", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "float", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 4, "Integer32"];(*attribute size*)
  BinaryWrite[file, 1., "Real32"];
  BinaryWrite[file, "screenWindowCenter", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "v2f", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 8, "Integer32"];(*attribute size*)
  BinaryWrite[file, 0., "Real32"];
  BinaryWrite[file, 0., "Real32"];
  BinaryWrite[file, "screenWindowWidth", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, "float", "Character8"];
  BinaryWrite[file, 0, "Integer8"];
  BinaryWrite[file, 4, "Integer32"];(*attribute size*)
  BinaryWrite[file, 1., "Real32"];
  BinaryWrite[file, 0, "Integer8"];
  
  Map[writeOffset, offsetT];
  writeScanlines[scanlines];
  
  Close[file];
]

ImportExport`RegisterExport[
    "OpenEXR",
    writeExr,
	"Sources" -> ImportExport`DefaultSources["Bitmap"],
	"BinaryFormat" -> True,
	"AlphaChannel" -> False
]
