#!/usr/bin/bash

index=${1:-./index.html}

# 1 head
cat > $index <<'EOF'
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Videos List</title>
<style type="text/css">
.strike {
    display: block;
    text-align: left;
    overflow: hidden;
    white-space: nowrap;
}
.strike > span {
    position: relative;
    display: inline-block;
}
.strike > span:before,
.strike > span:after {
    content: "";
    position: absolute;
    top: 50%;
    width: 9999px;
    height: 1px;
    background: black;
}
.strike > span:before {
    right: 100%;
    margin-right: 15px;
}
.strike > span:after {
    left: 100%;
    margin-left: 15px;
}
</style>
</head>
<body>
EOF

# 2 - begin video,subtitle
echo -e "\n<div>\n<h2>Videos list</h2>\n" >> $index

# 2 - single
echo -e "<div>\n    <ul>" >> $index
find . -maxdepth 1 -type f \
    \( -name '*.mp4' -o -name '*.mkv' -o -name '*.srt' -o -name '*.ass' \) \
    -exec echo "    <li><a href=\""{}"\">"{}"</a></li>" \; \
    | sort >> $index
echo -e "    </ul>\n</div>\n" >> $index

# 2 - dir
for dir in *; do
    [ ! -d "$dir" ] && continue
    testdir=$(find "$dir" -type f \( -name '*.mp4' -o -name '*.mkv' \))
    [ -z "$testdir" ] && continue
    cat >> $index <<EOF
<div class="strike">
    <span>$dir</span>
</div>
EOF
    echo -e "<div>\n    <ul>" >> $index
    dir2=$(echo $dir|sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g')
    find "$dir" -type f \
        \( -name '*.mp4' -o -name '*.mkv' -o -name '*.srt' -o -name '*.ass' \) \
        -exec echo "    <li><a href=\""{}"\">"{}"</a></li>" \; \
        | sed "s/\">$dir2\//\">/g" | sort -n -t'>' -k3 >> $index
    echo -e "    </ul>\n</div>\n" >> $index
done

# 2 - end
echo "</div>" >> $index

# 3 end
cat >> $index <<EOF
</body>
</html>
EOF
