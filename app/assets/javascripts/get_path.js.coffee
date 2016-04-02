# Jquery custom plugin to find the path of HTML selector 
# found by jquery element finder
# For example : If you find a Jquery element like below:
#   var element = $(".someclass").parent(".someparent").find(".someelement")
# then the getPath will give you something like :
#   element.getPath() -> html>body>div:nth-child(53)>div:nth-child(3)>div:nth-child(4)>div>div>form>div>div>div:nth-child(7)>div>

jQuery.fn.extend getPath: ->
  path = undefined
  node = this
  while node.length
    realNode = node[0]
    name = realNode.localName
    if !name
      break
    name = name.toLowerCase()
    parent = node.parent()
    sameTagSiblings = parent.children(name)
    if sameTagSiblings.length > 1
      allSiblings = parent.children()
      index = allSiblings.index(realNode) + 1
      if index > 1
        name += ':nth-child(' + index + ')'
    path = name + (if path then '>' + path else '')
    node = parent
  path