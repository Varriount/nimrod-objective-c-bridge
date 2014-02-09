import objcbridge/core, strutils, macros

import_objc_class(NSObject, """<Foundation/Foundation.h>"""):
  proc new*(): NSObject
  proc release*(self: NSObject)
