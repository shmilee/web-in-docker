#!/usr/bin/bash
depends=(grep sed findutils coreutils
         jupyter-nbconvert # for notebook
         pandoc # for sitelist
        )

casetype=${1:-'video'} #'notebook' 'site'
if [[ $casetype == 'video' ]]; then
    source_dir=${2:-/home/VideoData}
    deploy_dir=${3:-/home/WebData/root_files/videos} # mount volume
    url_path=${4:-/videos}     # root_files/videos/
    index=${5:-videolist} # root_files/tool/videolist.html
    head_name='Videos list'
elif [[ $casetype == 'notebook' ]]; then
    source_dir=${2:-/home/WebData/jupyterhub/shmilee}
    deploy_dir=${3:-/home/WebData/root_files/notebooks}
    url_path=${4:-/notebooks}  # root_files/notebooks/
    index=${5:-nblist}    # root_files/tool/nblist.html
    head_name='Jupyter Notebook list'
elif [[ $casetype == 'site' ]]; then
    source_file=${2:-./sitelist.md}
    index=${3:-sitelist} #root_files/tool/sitelist.html
    head_name='Some Sites'
fi

# 1 head
cat > ./${index}.html <<EOF
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="author" content="shmilee">
<title>Tools ${head_name}</title>
<link rel="stylesheet" href="/css/bootstrap-3.3.6.min.css">
<link rel="stylesheet" href="/css/bootstrap-theme.css">
<script type="text/javascript" src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="/js/bootstrap-3.3.6.min.js"></script>
<script>
    \$(function(){
        \$("#navbarwrap").load("navbarwrap.html");
        \$("#footerwrap").load("footerwrap.html");
        \$("#toolnav").load("toolnav.html", null, function(){
            \$("#${index}").addClass("active");
        });
        \$("#toolselect").load("toolselect.html", null, function(){
            \$("#tool-select").val("${index}.html");
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

# 2 - begin
echo -e "<h2>$head_name</h2>\n<br />\n" >> ./${index}.html

# 2 - source root
cat >> ./${index}.html <<EOF
<div id='content'>
<ul class="list-group">
EOF
echo $source_dir $source_file
if [[ $casetype == 'video' ]]; then
    source_dir2=$(echo $source_dir | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g')
    find "$source_dir" -maxdepth 1 -type f \
        \( -name '*.mp4' -o -name '*.mkv' -o -name '*.srt' -o -name '*.ass' \) \
        -exec echo "    <a class=\"list-group-item\" href=\""{}"\">"{}"</a>" \; \
        | sed -e "s|\">$source_dir2/|\"><span class = \"glyphicon glyphicon-file\"></span> |g" \
              -e "s|href=\"$source_dir2|href=\"$url_path|g" \
        | sort -n -t'>' -k4 >> ./${index}.html
    for dir in $source_dir/*; do
        [ ! -d "$dir" ] && continue
        testdir=$(find "$dir" -type f \( -name '*.mp4' -o -name '*.mkv' \))
        [ -z "$testdir" ] && continue
        dir2=$(basename "$dir")
        echo "    <a class=list-group-item href=\"#$dir2\"><span class = \"glyphicon glyphicon-folder-open\"></span> $dir2/</a>" >> ./${index}.html
    done
elif [[ $casetype == 'notebook' ]]; then
    find "$source_dir" -maxdepth 1 -type f -not -path "*.ipynb_checkpoints*" -name '*.ipynb'  \
        -exec echo "    <a class=\"list-group-item\" href=\""{}"\" target=\"_blank\">"{}"</a>" \; \
        | sed -e "s|\">$source_dir/|\"><span class = \"glyphicon glyphicon-file\"></span> |g" \
              -e "s|href=\"${source_dir}\(.*\.\)ipynb\(\" target=\)|href=\"${url_path}\1html\2|g" \
        | sort -n -t'>' -k4 >> ./${index}.html
    find "$source_dir" -maxdepth 1 -type f -name '*.ipynb' \
        -exec jupyter-nbconvert "{}" --output-dir "$deploy_dir" \;
    for dir in $source_dir/*; do
        [ ! -d "$dir" ] && continue
        testdir=$(find "$dir" -type f -name '*.ipynb')
        [ -z "$testdir" ] && continue
        dir2=$(basename "$dir")
        echo "    <a class=list-group-item href=\"#$dir2\"><span class = \"glyphicon glyphicon-folder-open\"></span> $dir2/</a>" >> ./${index}.html
    done
elif [[ $casetype == 'site' ]]; then
    cat >> ./${index}.html <<EOF
<style type="text/css">
    ul {padding-left: 3em;}
    h3 {margin-top: 40px;}
    h4 {margin-top: 30px;}
</style>
EOF
    sed 's/\([1-9]\. .*\[.*\](.*)\)/\1{.list-group-item target="_blank"}/' $source_file \
        | pandoc -N --base-header-level=1 --number-offset=0 \
        | sed -e 's/h1/h3/g' -e 's/h2/h4/g' >> ./${index}.html
fi
echo -e "</ul>\n</div>\n" >> ./${index}.html

# 2 - dir panel
if [[ $casetype == 'video' ]]; then
    for dir in $source_dir/*; do
        [ ! -d "$dir" ] && continue
        testdir=$(find "$dir" -type f \( -name '*.mp4' -o -name '*.mkv' \))
        [ -z "$testdir" ] && continue
        dir2=$(basename "$dir")
        echo $dir
        cat >> ./${index}.html <<EOF
<div class="panel panel-primary">
    <div class="panel-heading" id="$dir2">$dir2</div>
    <div class="panel-body list-group">
EOF
        dir3=$(echo "$dir" | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g')
        find "$dir" -type f \
            \( -name '*.mp4' -o -name '*.mkv' -o -name '*.srt' -o -name '*.ass' \) \
            -exec echo "    <a class="list-group-item" href=\""{}"\">"{}"</a>" \; \
            | sed -e "s|\">$dir3/|\"><span class = \"glyphicon glyphicon-file\"></span> |g" \
                  -e "s|href=\"$dir3|href=\"$url_path/$dir2|g" \
            | sort -n -t'>' -k4 >> ./${index}.html
        echo -e "    </div>\n</div>\n" >> ./${index}.html
    done
elif [[ $casetype == 'notebook' ]]; then
    for dir in $source_dir/*; do
        [ ! -d "$dir" ] && continue
        testdir=$(find "$dir" -type f -name '*.ipynb')
        [ -z "$testdir" ] && continue
        dir2=$(basename "$dir")
        echo $dir
        cat >> ./${index}.html <<EOF
<div class="panel panel-primary">
    <div class="panel-heading" id="$dir2">$dir2</div>
    <div class="panel-body list-group">
EOF
        dir3=$(echo "$dir" | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g')
        find "$dir" -not -path "*.ipynb_checkpoints*" -type f -name '*.ipynb' \
            -exec echo "    <a class="list-group-item" href=\""{}"\" target=\"_blank\">"{}"</a>" \; \
            | sed -e "s|\">$dir3/|\"><span class = \"glyphicon glyphicon-file\"></span> |g" \
                  -e "s|href=\"${dir3}\(.*\.\)ipynb\(\" target=\)|href=\"$url_path/$dir2\1html\2|g" \
            | sort -n -t'>' -k4 >> ./${index}.html
        find "$dir" -not -path "*.ipynb_checkpoints*" -type f -name '*.ipynb' -print0 \
            | while read -d $'\0' file
              do
                  dir4=$(dirname "$file" | sed "s|^$dir3||")
                  #echo "-v $file"
                  #echo "-vv $deploy_dir/$dir2$dir4"
                  jupyter-nbconvert "$file" --output-dir "$deploy_dir/$dir2$dir4"
              done
        echo -e "    </div>\n</div>\n" >> ./${index}.html
    done
fi

# 2 - end
if [[ $casetype == 'video' ]]; then
    sed -e 's/\(^.*\.mkv.*glyphicon\)-file\(.*\.mkv.*$\)/\1-film\2/g' \
        -e 's/\(^.*\.mp4.*glyphicon\)-file\(.*\.mp4.*$\)/\1-film\2/g' \
        -i ./${index}.html
    sed -e 's/\(^.*\.srt.*glyphicon\)-file\(.*\.srt.*$\)/\1-subtitles\2/g' \
        -e 's/\(^.*\.ass.*glyphicon\)-file\(.*\.ass.*$\)/\1-subtitles\2/g' \
        -i ./${index}.html
elif [[ $casetype == 'notebook' ]]; then
    sed -e 's/\(^.*\.html.*target.*glyphicon\)-file\(.*\.ipynb.*$\)/\1-book\2/g' \
        -i ./${index}.html
    find $deploy_dir -type f -name '*.html' -exec sed \
        -e 's|\(<script src="\)http.*require.min.js\("></script>\)|\1/js/require-2.3.2.min.js\2|g' \
        -e 's|\(<script src="\)http..*jquery.min.js\("></script>\)|\1/js/jquery-1.12.4.min.js\2|g' \
        -e 's|\(<script src="\)https.*/latest/\(MathJax.js.*".*$\)|\1/js/mathjax/\2|g' \
        -e 's|../components/bootstrap\(/fonts/glyphicons-halflings\)|\1|g' \
        -i "{}" \;
    # ignore FontAwesome
    # -e 's|../components/font-awesome\(/fonts/fontawesome-webfont\)|\1|g' \
fi

# 3 end
cat >> ./${index}.html <<EOF
            </div>
        </div>
    </div>
</div>

<div id="footerwrap"></div>
<script type="text/javascript" src="footerfix.js"></script>

</body>
</html>
EOF
