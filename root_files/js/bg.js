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
});
