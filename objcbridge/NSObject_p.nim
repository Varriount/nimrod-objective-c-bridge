import objcbridge/core, objcbridge/NSObject_t, strutils, macros

export NSObject_t.NSObject

import_objc_class(NSObject, """<Foundation/Foundation.h>"""):
  proc new*(): NSObject
  proc alloc*(): NSObject
  proc dealloc*()
  proc retain*(self: NSObject): NSObject
  proc release*(self: NSObject)
  proc autorelease*(self: NSObject): NSObject
