#!/usr/bin/env bash

ipynb_url=upload/IFTS_shmilee/notebook
ipynb_dir=/home/IFTS_shmilee/notebook
network_interface=eth0

# 1
cat > ./nblist.html <<'EOF'
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Jupyter NoteBook List</title>
<style type="text/css">
    body{
    font-family:"Bitstream Vera Sans", Verdana, Lucida, sans-serif;
    font-size: 1.2em;
    margin: 0px 20px;
    }
    a {
    color: rgb(0, 0, 205);
    text-decoration: none;
    }
    a:hover {
    text-decoration: underline;
    }
    #data, {
    margin-top: 20px;
    padding-bottom: 10px;
    }
    h3 {
    color: rgb(0, 0, 205);
    }
    li {
    padding-bottom: 3px;
    }
</style>
<script type="text/javascript" src="../js/jquery-1.8.3.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $.each($("#data ul li a"),function(i,n){
            var $href = $(this).attr("href");
            $(this).attr("href","http://"+window.location.hostname+":808"+$href);
        });
    });
</script>
</head>
<body>
<div id="data">
    <h3>Jupyter NoteBook List</h3>
    <ul>
EOF

# 2
myip=$(ip addr show $network_interface | grep 'inet '|sed 's/.*inet //;s/\/.*//')
find $ipynb_dir -type f -name '*.ipynb' -exec echo {} \; | grep -v .ipynb_checkpoints | sort | \
    sed "s|$ipynb_dir/\(.*\)\.ipynb|        <li> <a href=\"/url/$myip/$ipynb_url/\1\.ipynb\" target="_blank">\1</a></li>|" >> ./nblist.html

# 3
cat >> ./nblist.html <<EOF
    </ul>
</div>
</body>
</html>
EOF
