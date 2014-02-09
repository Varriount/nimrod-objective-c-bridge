import objcbridge/core, objcbridge/NSObject, objcbridge/NSString,
  strutils, macros

# Force this to compile on macosx form the commandline.
block:
  {.passL: "-lobjc".}
  {.passL: "-framework AppKit".}

const
  normal_string = "hello '$1' literal string"

proc tester() =
  var a: NSString = @normal_string
  echo a
  a = @@(normal_string % "Yaya!")
  echo a

when isMainModule:
  tester()
