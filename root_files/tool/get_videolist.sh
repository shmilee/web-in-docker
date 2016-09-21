#!/usr/bin/bash

video_dir=${1:-/home/VideoData}
url_dir=${2:-/videos}        # http/videos/, root_files/videos/
index=${3:-./videolist.html} # root_files/tool/videolist.html

# 1 head
cat > $index <<'EOF'
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="author" content="shmilee">
<title>Tools</title>
<link rel="stylesheet" href="/css/bootstrap-3.3.6.min.css">
<link rel="stylesheet" href="/css/bootstrap-theme.css">
<script type="text/javascript" src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="/js/bootstrap-3.3.6.min.js"></script>
<script>
    $(function(){
        $("#navbarwrap").load("navbarwrap.html");
        $("#footerwrap").load("footerwrap.html");
        $("#toolnav").load("toolnav.html", null, function(){
            $("#videolist").addClass("active");
        });
        $("#toolselect").load("toolselect.html", null, function(){
            $("#tool-select").val("videolist.html");
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

EOF

# 2 - begin video,subtitle
echo -e "<h2>Videos list</h2>\n<br />\n" >> $index

# 2 - single
cat >> $index <<EOF
<div class="panel panel-primary">
    <div class="panel-body list-group">
EOF
video_dir2=$(echo $video_dir | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g')
echo $video_dir
find "$video_dir" -maxdepth 1 -type f \
    \( -name '*.mp4' -o -name '*.mkv' -o -name '*.srt' -o -name '*.ass' \) \
    -exec echo "    <a class=\"list-group-item\" href=\""{}"\">"{}"</a>" \; \
    | sed -e "s|\">$video_dir2/|\">|g" \
          -e "s|href=\"$video_dir2|href=\"$url_dir|g" \
    | sort -n -t'>' -k3 >> $index
echo -e "    </div>\n</div>\n" >> $index

# 2 - dir
for dir in $video_dir/*; do
    [ ! -d "$dir" ] && continue
    testdir=$(find "$dir" -type f \( -name '*.mp4' -o -name '*.mkv' \))
    [ -z "$testdir" ] && continue
    dir2=$(echo $dir | sed -e "s|^$video_dir2/||g")

    cat >> $index <<EOF
<div class="panel panel-primary">
    <div class="panel-heading">$dir2</div>
    <div class="panel-body list-group">
EOF
    dir3=$(echo $dir | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g')
    echo $dir
    find "$dir" -type f \
        \( -name '*.mp4' -o -name '*.mkv' -o -name '*.srt' -o -name '*.ass' \) \
        -exec echo "    <a class="list-group-item" href=\""{}"\">"{}"</a>" \; \
        | sed -e "s|\">$dir3/|\">|g" \
              -e "s|href=\"$dir3|href=\"$url_dir/$dir2|g" \
        | sort -n -t'>' -k3 >> $index
    echo -e "    </div>\n</div>\n" >> $index
done

# 2 - end

# 3 end
cat >> $index <<EOF
            </div>
        </div>
    </div>
</div>

<div id="footerwrap"></div>

</body>
</html>
EOF
