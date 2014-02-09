import objcbridge/core, strutils, macros

import_objc_class(NSObject, """<Foundation/Foundation.h>"""):
  proc new*(): NSObject
  proc alloc*(): NSObject
  proc dealloc*()
  proc retain*(self: NSObject): NSObject
  proc release*(self: NSObject)
  proc autorelease*(self: NSObject): NSObject
