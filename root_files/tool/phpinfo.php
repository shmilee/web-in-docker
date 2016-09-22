<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="author" content="shmilee">
<title>Tools phpinfo</title>
<link rel="stylesheet" href="/css/bootstrap-3.3.6.min.css">
<link rel="stylesheet" href="/css/bootstrap-theme.css">
<script type="text/javascript" src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="/js/bootstrap-3.3.6.min.js"></script>
<script>
    $(function(){
        $("#navbarwrap").load("navbarwrap.html");
        $("#footerwrap").load("footerwrap.html");
        $("#toolnav").load("toolnav.html", null, function(){
            $("#phpinfo").addClass("active");
        });
        $("#toolselect").load("toolselect.html", null, function(){
            $("#tool-select").val("phpinfo.php");
        });
    });
</script>
</head>
<body>

<div id="navbarwrap" class="navbar navbar-default" role="navigation"></div>

<div id="tool-page">
    <div class="container">
        <div class="row">
            <div id="toolnav" class="col-sm-2 hidden-xs"></div>
            <div id="toolselect" class="col-sm-10 visible-xs"></div>
            <div class="col-sm-10">

<style type="text/css">
#phpinfo {background-color: #fff; color: #222; font-family: sans-serif;}
#phpinfo pre {margin: 0; font-family: monospace;}
#phpinfo a:link {color: #009; text-decoration: none; background-color: #fff;}
#phpinfo a:hover {text-decoration: underline;}
#phpinfo table {border-collapse: collapse; border: 0; width: 934px; box-shadow: 1px 2px 3px #ccc;}
#phpinfo .center {text-align: center;}
#phpinfo .center table {margin: 1em auto; text-align: left;}
#phpinfo .center th {text-align: center !important;}
#phpinfo td, th {border: 1px solid #666; font-size: 90%; vertical-align: baseline; padding: 4px 5px;}
#phpinfo h1 {font-size: 150%;}
#phpinfo h2 {font-size: 125%;}
#phpinfo .p {text-align: left;}
#phpinfo .e {background-color: #ccf; width: 300px; font-weight: bold;}
#phpinfo .h {background-color: #99c; font-weight: bold;}
#phpinfo .v {background-color: #ddd; max-width: 300px; overflow-x: auto; word-wrap: break-word;}
#phpinfo .v i {color: #999;}
#phpinfo img {float: right; border: 0;}
#phpinfo hr {width: 934px; background-color: #ccc; border: 0; height: 1px;}
</style>

<div id="phpinfo">
<?php
ob_start();
phpinfo();
$pinfo = ob_get_contents();
ob_end_clean();
$pinfo = preg_replace( '%^.*<body>(.*)</body>.*$%ms','$1',$pinfo);
echo $pinfo;                
?>
</div>
            </div>
        </div>
    </div>
</div>

<div id="footerwrap"></div>

</body>
</html>

