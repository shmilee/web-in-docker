/*
 * https://tylercipriani.com/blog/2014/07/12/crossbrowser-javascript-scrollbar-detection/
var hasScrollbar = function() {
  // The Modern solution
  if (typeof window.innerWidth === 'number')
    return window.innerWidth > document.documentElement.clientWidth

  // rootElem for quirksmode
  var rootElem = document.documentElement || document.body

  // Check overflow style property on body for fauxscrollbars
  var overflowStyle

  if (typeof rootElem.currentStyle !== 'undefined')
    overflowStyle = rootElem.currentStyle.overflow

  overflowStyle = overflowStyle || window.getComputedStyle(rootElem, '').overflow

    // Also need to check the Y axis overflow
  var overflowYStyle

  if (typeof rootElem.currentStyle !== 'undefined')
    overflowYStyle = rootElem.currentStyle.overflowY

  overflowYStyle = overflowYStyle || window.getComputedStyle(rootElem, '').overflowY

  var contentOverflows = rootElem.scrollHeight > rootElem.clientHeight
  var overflowShown    = /^(visible|auto)$/.test(overflowStyle) || /^(visible|auto)$/.test(overflowYStyle)
  var alwaysShowScroll = overflowStyle === 'scroll' || overflowYStyle === 'scroll'

  return (contentOverflows && overflowShown) || (alwaysShowScroll)
}

if (!hasScrollbar()) {
  var footer= document.getElementById("footerwrap");
  footer.style.cssText="position:fixed; overflow:hidden; bottom:0px";
}
*/

var body = document.getElementsByTagName("body")[0]
body.style.cssText="\
  min-height:100vh;\
  display:flex;\
  -webkit-flex-direction:column;\
  -webkit-box-orient:vertical;\
  -moz-box-orient:vertical;\
  -o-box-orient:vertical;\
  -ms-flex-direction:column;\
  flex-direction:column"
var toolpage = document.getElementById("tool-page");
toolpage.style.cssText="-webkit-flex:1; overflow: hidden";

