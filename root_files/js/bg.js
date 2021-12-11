$(document).ready(function() {
  var random_bg=Math.floor(Math.random()*10); // 随机壁纸 0-9
  var bg='url(images/bg'+random_bg+'.jpg)';
  $("body").css("background-image",bg);

  $(window).resize(function() {
    var h = $(window).height(); //浏览器时下窗口可视区域高度
    var w = $(window).width(); //可视区域宽度
    if(w/h<1280/800){
      $("body").css("background-size",'auto 100%');
    }else{
      $("body").css("background-size",'100% auto');
    }
  });

//  var a_idx = 0;
//  $("body").click(function(e) {
//    var a = new Array("富强", "民主", "文明", "和谐", "自由", "平等", "公正" ,"法治", "爱国", "敬业", "诚信", "友善");
//    var $i = $("<span/>").text(a[a_idx]);
//    a_idx = (a_idx + 1) % a.length;
//    var x = e.pageX,
//    y = e.pageY;
//    $i.css({
//      "z-index": 99,
//      "top": y - 25,
//      "left": x,
//      "position": "absolute",
//      "font-weight": "bold",
//      "color": "#ff6651"
//    });
//    $("body").append($i);
//    $i.animate({
//        "top": y - 200,
//        "opacity": 0.5
//      },
//      1500,
//      function() {
//        $i.remove();
//      });
//  });
});
