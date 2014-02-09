import objcbridge/core, objcbridge/NSObject, objcbridge/NSString,
  strutils, macros

# Force this to compile on macosx form the commandline.
block:
  {.passL: "-lobjc".}
  {.passL: "-framework AppKit".}

proc tester() =
  var a: NSString = @"brakalar"
  echo "a"

when isMainModule:
  tester()
