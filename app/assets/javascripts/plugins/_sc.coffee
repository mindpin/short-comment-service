win_load = ->
  sc_ele = document.querySelector("div[rel='short-comment']")
  width = sc_ele.attributes["data-width"]
  width = !width ? "100%" : width.value
  iframe_div = document.createElement("iframe");
  url = encodeURIComponent window.location.href
  iframe_div.src = "http://192.168.1.39:3000/posts/show?url=#{url}"
  iframe_div.setAttribute("style","border:0;width:#{width};")
  sc_ele.parentNode.insertBefore(iframe_div, sc_ele)
  sc_ele.remove()

if document.attachEvent
  window.attachEvent('onload', win_load)
else
  window.addEventListener('load', win_load, false)

