<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Tools</title>
<script src="../js/jquery-1.8.3.min.js" type="text/javascript"></script>
<!--uploadify /*{{{*/ -->
<link rel="stylesheet" type="text/css" href="uploadify/uploadify.css">
<script src="uploadify/jquery.uploadify.min.js" type="text/javascript"></script>
<script type="text/javascript">
    <?php $timestamp = time();?>
    $(function() {
        $('#file_upload').uploadify({
            auto       : false,
            buttonText : '添加文件 ...',
            formData   : {
                'timestamp' : '<?php echo $timestamp;?>',
                'token'     : '<?php echo md5('unique_salt' . $timestamp);?>'
            },
			swf           : 'uploadify/uploadify.swf',
            uploader      : 'uploadify/uploadify.php',
            height        : 30,
            width         : 100,
            checkExisting : 'uploadify/check-exists.php',
            fileSizeLimit : '25MB',
            fileTypeExts  : '*.jpg; *.jpeg; *.gif; *.png; *.rar; *.zip; *.gzip; *.7z; *.mp3; *.txt; *.pdf; *.doc; *.docx; *.ppt; *.pptx; *.xls; *.xlsx',
            onUploadError : function(file, errorCode, errorMsg, errorString) {
                alert(file.name + '无法上传:' + errorString);
            },
            onQueueComplete : function(queueData) {
                alert(queueData.uploadsSuccessful + '个文件上传成功.');
            }
        });
    });
</script>
<!-- end /*}}}*/ -->
<script src="calc.js" type="text/javascript"></script>
<style type="text/css">
body {
    font: 13px Arial, Helvetica, Sans-serif;
    background-color: #d4d4d4;
    color: #0001fC;
    background-attachment: #000000;
}
td {
    font-size: 12px;
    font-color:#000000;
}
</style>
</head>
<body>
<div id="uploadify">
    <h2>上传到<a href="/upload">upload  </a><a class="uploadify-button" href="javascript:$('#file_upload').uploadify('upload','*')">开始</a></h2>
    <div id="queue"></div>
    <input id="file_upload" name="file_upload" type="file" multiple="true">
</div>
<!--科学计算器 /*{{{*/ -->
<div align="center">
<form name=calc>
<table border="1" width="500" height="250">
<tr>
<td height=50>
<table width=500>
<td width="133">
</td>
<td width="353">
<div align=center>
<input type=text name="display" value="0" readonly size="40">
</div>
</td>
</table>
</td>
</tr>
<tr>
<td>
<table width=500>
<tr>
<td width=290>
<input type=radio name="carry" onClick="inputChangCarry(16)">
十六进制
<input type=radio name="carry" checked onClick="inputChangCarry(10)">
十进制
<input type=radio name="carry" onClick="inputChangCarry(8)">
八进制
<input type=radio name="carry" onClick="inputChangCarry(2)">
二进制
</td>
<td>
</td>
<td width=135>
<input type=radio name="angle" value="d" onClick="inputChangAngle('d')" checked>
角度制
<input type=radio name="angle" value="r" onClick="inputChangAngle('r')">
弧度制
</td>
</tr>
</table>
<table width=500>
<tr>
<td width=170>
<input name="shiftf" type="checkbox" onclick="inputshift()">上档功能
<input name="hypf" type="checkbox" onclick="inputshift()">双曲函数
</td>
<td>
<input name="bracket" value="" type=text size=3 readonly style="background-color=lightgrey">
<input name="memory" value="" type=text size=3 readonly style="background-color=lightgrey">
<input name="operator" value="" type=text size=3 readonly style="background-color=lightgrey">
</td>
<td width=183>
<input type="button" value=" 退格 "
onclick="backspace()" style="color=red">
<input type="button" value=" 清屏 "
onClick="document.calc.display.value = 0 " style="color=red">
<input type="button" value=" 全清"
onClick="clearall()" style="color=red">
</td>
</tr>
</table>
<table width=500>
<tr>
<td>
<table>
<tr  align=center>
<td>
<input name=pi type="button" value=" PI "
onClick="inputfunction('pi','pi')" style="color=blue">
</td>
<td>
<input name=e type="button" value=" E  "
onClick="inputfunction('e','e')" style="color=blue">
</td>
<td>
<input name=bt type="button" value="d.ms"
onClick="inputfunction('dms','deg')" style="color=#ff00ff">
</td>
</tr>
<tr  align=center>
<td>
<input  type="button" value=" (  "
onClick="addbracket()" style="color=#ff00ff">
</td>
<td>
<input  type="button" value=" )  "
onClick="disbracket()" style="color=#ff00ff">
</td>
<td>
<input name=ln type="button" value=" ln "
onClick="inputfunction('ln','exp')" style="color=#ff00ff">
</td>
</tr>
<tr align=center>
<td>
<input name=sin type="button" value="sin "
onClick="inputtrig('sin','arcsin','hypsin','ahypsin')" style="color=#ff00ff">
</td>
<td>
<input  type="button" value="x^y "
onClick="operation('^',7)" style="color=#ff00ff">
</td>
<td>
<input name=log type="button" value="log "
onClick="inputfunction('log','expdec')" style="color=#ff00ff">
</td>
</tr>
<tr align=center>
<td>
<input name=cos type="button" value="cos "
onClick="inputtrig('cos','arccos','hypcos','ahypcos')" style="color=#ff00ff">
</td>
<td>
<input name=cube type="button" value="x^3 "
onClick="inputfunction('cube','cubt')" style="color=#ff00ff">
</td>
<td>
<input  type="button" value=" n! "
onClick="inputfunction('!','!')" style="color=#ff00ff">
</td>
</tr>
<tr align=center>
<td>
<input name=tan type="button" value="tan "
onClick="inputtrig('tan','arctan','hyptan','ahyptan')" style="color=#ff00ff">
</td>
<td>
<input name=sqr type="button" value="x^2 "
onClick="inputfunction('sqr','sqrt')" style="color=#ff00ff">
</td>
<td>
<input type="button" value="1/x "
onClick="inputfunction('recip','recip')" style="color=#ff00ff">
</td>
</tr>
</table>
</td>
<td width=30>
</td>
<td>
<table>
<tr>
<td>
<input type="button" value=" 储存 "
onClick="putmemory()" style="color=red">
</td>
</tr>
<td>
<input type="button" value=" 取存 "
onClick="getmemory()" style="color=red">
</td>
</tr>
<tr>
<td>
<input type="button" value=" 累存 "
onClick="addmemory()" style="color=red">
</td>
</tr>
<tr>
<td>
<input type="button" value=" 积存 "
onClick="multimemory()" style="color=red">
</td>
</tr>
<tr>
<td height="33">
<input type="button" value=" 清存 "
onClick="clearmemory()" style="color=red">
</td>
</tr>
</table>
</td>
<td width=30>
</td>
<td>
<table>
<tr align=center>
<td>
<input name=k7 type="button" value=" 7 "
onClick="inputkey('7')" style="color=blue">
</td>
<td>
<input name=k8 type="button" value=" 8 "
onClick="inputkey('8')" style="color=blue">
</td>
<td>
<input name=k9 type="button" value=" 9 "
onClick="inputkey('9')" style="color=blue">
</td>
<td>
<input type="button" value=" / "
onClick="operation('/',6)" style="color=red">
</td>
<td>
<input type="button" value="取余"
onClick="operation('%',6)" style="color=red">
</td>
<td>
<input type="button" value=" 与 "
onClick="operation('&',3)" style="color=red">
</td>
</tr>
<tr align=center>
<td>
<input name=k4 type="button" value=" 4 "
onClick="inputkey('4')" style="color=blue">
</td>
<td>
<input name=k5 type="button" value=" 5 "
onClick="inputkey('5')" style="color=blue">
</td>
<td>
<input name=k6 type="button" value=" 6 "
onClick="inputkey('6')" style="color=blue">
</td>
<td>
<input type="button" value=" * "
onClick="operation('*',6)" style="color=red">
</td>
<td>
<input name=floor type="button" value="取整"
onClick="inputfunction('floor','deci')" style="color=red">
</td>
<td>
<input type="button" value=" 或 "
onClick="operation('|',1)" style="color=red">
</td>
</tr>
<tr align=center>
<td>
<input type="button" value=" 1 "
onClick="inputkey('1')" style="color=blue">
</td>
<td>
<input name=k2 type="button" value=" 2 "
onClick="inputkey('2')" style="color=blue">
</td>
<td>
<input name=k3 type="button" value=" 3 "
onClick="inputkey('3')" style="color=blue">
</td>
<td>
<input type="button" value=" - "
onClick="operation('-',5)" style="color=red">
</td>
<td>
<input type="button" value="左移"
onClick="operation('<',4)" style="color=red">
</td>
<td>
<input type="button" value=" 非 "
onClick="inputfunction('~','~')" style="color=red">
</td>
</tr>
<tr align=center>
<td>
<input type="button" value=" 0 "
onClick="inputkey('0')" style="color=blue">
</td>
<td>
<input type="button" value="+/-"
onClick="changeSign()" style="color=blue">
</td>
<td>
<input name=kp type="button" value=" . "
onClick="inputkey('.')" style="color=blue">
</td>
<td>
<input type="button" value=" + "
onClick="operation('+',5)" style="color=red">
</td>
<td>
<input type="button" value=" ＝ "
onClick="result()" style="color=red">
</td>
<td>
<input type="button" value="异或"
onClick="operation('x',2)" style="color=red">
</td>
</tr>
<tr align=center>
<td>
<input name=ka type="button" value=" A "
onClick="inputkey('a')" style="color=blue" disabled=true>
</td>
<td>
<input name=kb type="button" value=" B "
onClick="inputkey('b')" style="color=blue" disabled=true>
</td>
<td>
<input name=kc type="button" value=" C "
onClick="inputkey('c')" style="color=blue" disabled=true>
</td>
<td>
<input name=kd type="button" value=" D "
onClick="inputkey('d')" style="color=blue" disabled=true>
</td>
<td>
<input name=ke type="button" value=" E　"
onClick="inputkey('e')" style="color=blue" disabled=true>
</td>
<td>
<input name=kf type="button" value=" F　"
onClick="inputkey('f')" style="color=blue" disabled=true>
</td>
</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
</div>
<!-- end /*}}}*/ -->
</body>
</html>
