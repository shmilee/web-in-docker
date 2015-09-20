var weekday=new Array(7)
weekday[0]="星期日"
weekday[1]="星期一"
weekday[2]="星期二"
weekday[3]="星期三"
weekday[4]="星期四"
weekday[5]="星期五"
weekday[6]="星期六"

today=new Date(); 
document.write( 
  "<p>你好,今天是</p>", 
  "<p>",today.getFullYear(),"年",today.getMonth()+1,"月",today.getDate(),"日, ",weekday[today.getDay()],".</p>",
  "<p>欢迎你的到来!</p>"
);
