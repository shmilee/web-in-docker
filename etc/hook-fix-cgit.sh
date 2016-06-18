#!/bin/bash

# https://git.zx2c4.com/cgit/commit/?id=7d51120440346108aad74f007431ad65b307f6d7
# https://www.mail-archive.com/cgit@lists.zx2c4.com/msg01589.html

#if [ $(pacman -Qi cgit|grep Version|awk '{print $3}') == '1.0-1' ]; then fixbalabala; fi

cp /usr/lib/cgit/filters/html-converters/md2html{,.bk}

cat > /usr/lib/cgit/filters/html-converters/md2html <<'EOF'
#!/usr/bin/env python
import markdown
import sys
import io
from pygments.formatters import HtmlFormatter
sys.stdin = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stdout.write('''
EOF

sed -n '5,281p' /usr/lib/cgit/filters/html-converters/md2html.bk \
    >> /usr/lib/cgit/filters/html-converters/md2html

cat >> /usr/lib/cgit/filters/html-converters/md2html <<'EOF'
sys.stdout.write(HtmlFormatter(style='pastie').get_style_defs('.highlight'))
sys.stdout.write('''
</style>
''')
sys.stdout.write("<div class='markdown-body'>")
sys.stdout.flush()
# Note: you may want to run this through bleach for sanitization
markdown.markdownFromFile(output_format="html5", extensions=["markdown.extensions.fenced_code", "markdown.extensions.codehilite", "markdown.extensions.tables"], extension_configs={"markdown.extensions.codehilite":{"css_class":"highlight"}})
sys.stdout.write("</div>")
EOF
