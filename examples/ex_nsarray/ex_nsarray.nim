import objcbridge/core, objcbridge/NSObject_p, objcbridge/NSArray_p,
  objcbridge/NSString_p, strutils, macros, unicode

# Force this to compile on macosx form the commandline.
block:
  {.passL: "-lobjc".}
  {.passL: "-framework AppKit".}

proc tester() =
  var a: NSArray
  a = NSArray_p.array()
  echo "Empty array has ", a.len
  #var b = arrayWithObject(@"Hey")

when isMainModule:
  tester()
