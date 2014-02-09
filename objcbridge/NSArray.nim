import objcbridge/core, objcbridge/NSObject, strutils, macros, unsigned

import_objc_class(NSArray, """<Foundation/Foundation.h>"""):
  # Creating an array
  proc array*(): NSArray
  proc arrayWithArray*(): NSArray
  proc arrayWithObject*(an_object: NSObject): NSArray

  # Querying an Array
  proc containsObject(self: NSArray, an_object: NSObject): bool
  proc count(self: NSArray): uint


# Helper procs to ease conversion to Nimrod.
proc len*(x: NSArray): int {.inline.} = int(x.count)
