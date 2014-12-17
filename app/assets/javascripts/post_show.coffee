add_click = (ele, click_fun)->
  if ele.attachEvent
    ele.attachEvent('onclick', click_fun)
  else
    ele.addEventListener('click', click_fun, false)

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

vote_logic = (url)->
  comments_ele = document.querySelector("div.comments")
  comments_eles = document.querySelectorAll("div.comments a")
  for comment_ele in comments_eles
    add_click comment_ele,
      (event)->
        has_voted = comments_ele.attributes["data-has-voted"].value
        has_voted = has_voted == "true" ? true : false
        if has_voted
          alert("你已经赞过一次了")
          return
        ele = event.target
        comment_id = ele.attributes["data-comment-id"].value
        xml_hr = create_XMLHttpRequest()
        xml_hr.open("post", '/posts/votes', true);
        xml_hr.setRequestHeader("Content-Type","application/x-www-form-urlencoded"); 
        #指定响应函数
        xml_hr.onreadystatechange = ->
            if xml_hr.readyState == 4
                if xml_hr.status == 200
                  comments_ele.setAttribute("data-has-voted", true)
                  voted = document.querySelector("div.voted")
                  voted.innerText = "已经赞过评论 '#{ele.innerText}'"
        xml_hr.send("url=#{url}&comment_id=#{comment_id}");

create_comment_logic = (url)->
  comment_form_ele = document.querySelector("div.comment-form")
  if !comment_form_ele
    return
  text_ele = document.querySelector("div.comment-form input[type='text']")
  submit_ele = document.querySelector("div.comment-form input[type='submit']")
  add_click submit_ele, (event)->
    comment_content = text_ele.value
    xml_hr = create_XMLHttpRequest()
    xml_hr.open("post", '/posts/comments', true);
    xml_hr.setRequestHeader("Content-Type","application/x-www-form-urlencoded"); 
    #指定响应函数
    xml_hr.onreadystatechange = ->
      if xml_hr.readyState == 4
        if xml_hr.status == 200
          ele = document.createElement("div");
          ele.setAttribute("class", "comment")
          ele.innerText = "发表了评论 '#{comment_content}'"
          comment_form_ele.parentNode.insertBefore(ele, comment_form_ele)
          comment_form_ele.remove()
    xml_hr.send("url=#{url}&comment=#{comment_content}");

win_load ->
  short_comments_ele = document.querySelector("div.short-comments")
  url = short_comments_ele.attributes["data-url"].value
  vote_logic(url)
  create_comment_logic(url)
      
