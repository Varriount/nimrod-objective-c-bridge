import objcbridge/core, objcbridge/NSObject, objcbridge/NSArray,
  objcbridge/NSString, strutils, macros, unicode

# Force this to compile on macosx form the commandline.
block:
  {.passL: "-lobjc".}
  {.passL: "-framework AppKit".}

proc tester() =
  var a: NSArray
  a = NSArray.array()
  echo "Empty array has ", a.len
  #var b = arrayWithObject(@"Hey")

when isMainModule:
  tester()
