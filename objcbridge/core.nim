## Macros to interface with Objective-C classes and vice versa.
##
## This module provides the base macros used to generate wrappers for
## Objective-C code and vice versa, exposing Nimrod objects with a more
## Objective-C API.
##
## Source code for this package and related modules may be found at
## https://github.com/gradha/nimrod-objective-c-bridge.

when not defined(objc):
  {.fatal: "Sorry, this module only supports objc compilation!".}

import macros, strutils

const
  versionStr* = "0.3.1" ## Module version as a string.
  versionInt* = (major: 0, minor: 3, maintenance: 1) ## \
  ## Module version as an integer tuple.
  ##
  ## Major versions changes mean a break in API backwards compatibility, either
  ## through removal of symbols or modification of their purpose.
  ##
  ## Minor version changes can add procs (and maybe default parameters). Minor
  ## odd versions are development/git/unstable versions. Minor even versions
  ## are public stable releases.
  ##
  ## Maintenance version changes mean I'm not perfect yet despite all the kpop
  ## I watch.

iterator unroll_parameters(node: PNimrodNode, startPos = 0):
    tuple[name, ptype, default: PNimrodNode] =
  ## Unrolls the parameter list.
  ##
  ## Code definitions for parameters can be in the form "a, b, c = type". The
  ## iterator will return tuples with the name, nimrod type, and if any, the
  ## default parameter.
  node.expect_kind(nnkFormalParams)
  var pos = 0
  for ident_node_index in 1..len(node)-1:
    let ident_node = node[ident_node_index]
    ident_node.expect_kind(nnkIdentDefs)
    let
      defaultValue = ident_node.last
      paramType = ident_node[len(ident_node) - 2]
    for param_index in 0..len(ident_node) - 3:
      let param_node = ident_node[param_index]
      if pos >= startPos:
        yield (param_node, paramType, defaultValue)
      pos += 1


macro import_objc_class*(class_name, header: string, body: stmt): stmt {.immediate.} =
  ## Macro which generates a binding for an existing Objective-C class.
  ##
  ## Use this for existing classes which you want to call from Nimrod. Specify
  ## as `class_name` the name of the class (same as the objc version). The
  ## `header` parameter should specify the path to the header declaring the
  ## class, so it can be imported in the generated code.
  ##
  ## In the body of the macro you have to specify the procs that mimic the objc
  ## version. If you are interfacing against an instance method, you need to
  ## define the proc with a first parameter named ``self``. If you don't do
  ## this, the generated code will call a class method instead.
  ##
  ## All the objc classes interfaced like this will create a Nimrod type of the
  ## same name, but this type will automatically include the pointer ``*``,
  ## since Nimrod doesn't use asterisks. To access the real non pointer type
  ## you have to prefix the type with a ``T``.
  header.expectKind({nnkStrLit, nnkTripleStrLit})
  result = newNimNode(nnkStmtList)

  echo($class_name)
  # Generate the type for the class.
  var typedef = newNimNode(nnkTypeSection)
  # First create the base T prefixed type, equivalent to:
  # Txxx {.importc: "xxx", final, header: """yyy""".} = object
  typedef.add(newNimNode(nnkTypeDef).add(
    newNimNode(nnkPragmaExpr).add(
      newIdentNode("T" & $class_name),
      newNimNode(nnkPragma).add(
        newNimNode(nnkExprColonExpr).add(
          newIdentNode("importc"), newStrLitNode($class_name)),
        newIdentNode("final"),
        newNimNode(nnkExprColonExpr).add(
          newIdentNode("header"), header)
        )),
    newEmptyNode(),
    newNimNode(nnkObjectTy).add(
      newEmptyNode(), newEmptyNode(), newEmptyNode())))
  # Now append the `normal` type referencing the Txxx version. Equivalent to:
  # xxx = ref Txxx
  typedef.add(newNimNode(nnkTypeDef).add(
    newIdentNode($class_name),
    newEmptyNode(),
    newNimNode(nnkRefTy).add(newIdentNode("T" & $class_name))))
  result.add(typedef)

  # Iterate the body looking for proc definitions.
  for inode in body.children:
    case inode.kind:
    of nnkProcDef:
      # A proc definition should have 7 nodes, the last being empty of body
      inode.expect_min_len(7)
      inode[6].expect_kind(nnkEmpty)
      var c = inode.copyNimTree
      c[0].expect_kind(nnkIdent)
      let
        proc_name = $c[0]
        params = c[3]
        pragmas = c[4]
      params.expect_kind(nnkFormalParams)
      pragmas.expect_kind(nnkEmpty)

      # Convenience mangling for unique methods like alloc or new.
      case toLower(proc_name)
      of "new": c[0] = newIdentNode("new" & $class_name)
      else: nil

      params.expect_min_len(1)
      let ret_type = params[0]
      # Detect based on convention of first parameter name if method is static.
      var static_method = true
      if params.len > 1:
        let first_param_name = $params[1][0]
        if cmpIgnoreStyle(first_param_name, "self") == 0:
          static_method = false

      # Prepare to start emitting raw objc code replacing params.
      var emit_body = newNimNode(nnkStmtList)
      emit_body.add(newNimNode(nnkPragma).add(
        newNimNode(nnkExprColonExpr)))
      let e = emit_body[0][0]
      e.add(newIdentNode("emit"))

      var
        start_param = 0
        code: string
      # Procs with a return value should use the objc return keyword.
      if ret_type.kind == nnkEmpty:
        code = "["
      else:
        code = "result = ["

      # Define how do we start to emit the method.
      if static_method:
        code.add($class_name & " " & proc_name)
      else:
        code.add("`self` " & proc_name)
        start_param = 1

      # Loop over the parameters, carefully adding the first without name.
      var did_add_first = false
      for pname, ptype, pdefault in params.unroll_parameters(start_param):
        if did_add_first:
          code.add($pname & ":`" & $pname & "` ")
        else:
          did_add_first = true
          code.add(":`" & $pname & "` ")

      code.add("];")

      # Ok, replace the last node with the body we just built.
      let lit = newNimNode(nnkTripleStrLit)
      lit.strVal = code
      e.add(lit)
      c[6] = emit_body

      # Add some pragmas for values with a return type.
      #if ret_type.kind == nnkEmpty:
      #  let p = newNimNode(nnkPragma).add(
      #    newIdentNode("NoStackFrame")).add(
      #    newIdentNode("inline"))
      #  #echo treeRepr(p)
      #  c[4] = p

      result.add(c)
      #echo treeRepr(c)
    else:
      echo "Ignoring unexpected node ", repr(inode.kind)
