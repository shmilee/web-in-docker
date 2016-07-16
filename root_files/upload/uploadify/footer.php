
<!--uploadify -->
<link rel="stylesheet" type="text/css" href="/upload/uploadify/uploadify.css">
<script src="/js/jquery-1.12.4.min.js" type="text/javascript"></script>
<script src="/upload/uploadify/jquery.uploadify.min.js" type="text/javascript"></script>
<hr />
<div id="uploadify">
    <div id="queue"></div>
    <input id="file_upload" name="file_upload" type="file" multiple="true">
    <p><a class="uploadify-button" style="font-size:15px;" href="javascript:$('#file_upload').uploadify('upload','*')">&nbsp;传送&nbsp;</a>
    <span style="font-size:16px;font-weight:bold;">文件到<a href="/upload/">/upload/</a>。传送完毕, 请刷新网页。</span></p>
</div>
<hr />
<script type="text/javascript">
    <?php $timestamp = time();?>
    $(function() {
        $('#file_upload').uploadify({
            auto       : false,
            buttonText : '集结',
            formData   : {
                'timestamp' : '<?php echo $timestamp;?>',
                'token'     : '<?php echo md5('unique_salt' . $timestamp);?>'
            },
			swf           : '/upload/uploadify/uploadify.swf',
            uploader      : '/upload/uploadify/uploadify.php',
            height        : 24,
            width         : 50,
            checkExisting : '/upload/uploadify/check-exists.php',
            fileSizeLimit : '25MB',
            fileTypeExts  : '*.jpg; *.gif; *.png; *.rar; *.zip; *.gzip; *.gz; *.7z; *.mp3; *.txt; *.pdf; *.doc; *.docx; *.ppt; *.pptx',
            onUploadError : function(file, errorCode, errorMsg, errorString) {
                alert(file.name + '无法上传:' + errorString);
            },
            onQueueComplete : function(queueData) {
                alert(queueData.uploadsSuccessful + '个文件上传成功.');
            }
        });
    });
</script>
<!-- end -->
</body>
</html>
