current_url = encodeURIComponent window.location.href
post_show_url = "http://192.168.1.39:3000/posts/show?url=#{current_url}"
post_show_css_url = "http://192.168.1.39:3000/assets/plugins/post_show.css"
post_show_js_url = "http://192.168.1.39:3000/assets/plugins/post_show.js"

win_load = (win_load_fun)->
  if document.attachEvent
    window.attachEvent('onload', win_load_fun)
  else
    window.addEventListener('load', win_load_fun, false)

create_XMLHttpRequest = -> 
  try
      #IE高版本创建XMLHTTP
      return new ActiveXObject("Msxml2.XMLHTTP");
  catch E
      try
          #IE低版本创建XMLHTTP
          return new ActiveXObject("Microsoft.XMLHTTP");
      catch E
          #兼容非IE浏览器，直接创建XMLHTTP对象
          return new XMLHttpRequest();

win_load ->
  sc_ele = document.querySelector("div[rel='short-comment']")
  width = sc_ele.attributes["data-width"]
  width = !width ? "100%" : width.value
  xml_hr = create_XMLHttpRequest()
  xml_hr.open("get", post_show_url, true);
  xml_hr.withCredentials = true;
  xml_hr.setRequestHeader("Content-Type","application/x-www-form-urlencoded"); 
  #指定响应函数
  xml_hr.onreadystatechange = ->
    if xml_hr.readyState == 4
      if xml_hr.status == 200
        text = xml_hr.responseText;
        div_ele = document.createElement("div");
        div_ele.setAttribute("style","width:#{width};")
        div_ele.innerHTML = text
        sc_ele.parentNode.insertBefore(div_ele, sc_ele)
        js_ele = document.createElement("script");
        js_ele.type = 'text/javascript';
        js_ele.src = post_show_js_url
        sc_ele.parentNode.insertBefore(js_ele, sc_ele)
        css_ele = document.createElement('link')
        css_ele.type = 'text/css'
        css_ele.rel = 'stylesheet'
        css_ele.media = 'screen'
        css_ele.href = post_show_css_url
        sc_ele.parentNode.insertBefore(css_ele, sc_ele)
        sc_ele.remove()
  xml_hr.send(null);

