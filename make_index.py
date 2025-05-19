import glob
import re

html_a = '''
<!DOCTYPE html>
<html lang="ja">
<head>
    <script>
        const matches = location.hash.match(/^#(\\d{4}\\/\\d{4}-\\d{2})$/);
        if (matches) {
            location.href = matches[1] + '.html';
        }
    </script>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>Memo</title>
    <style>
        body {
            margin: 0;
            padding: 0;
        }
        #main {
            margin: 8px;
        }
        h1, h2, h3, p {
            margin: 12px 16px; /* 上下、左右 */
        }
        ul {
            padding-left: 2em;
            line-height: 150%;
        }
    </style>
</head>
<body>
    <div id="main">
        <ul>
'''

html_b = '''
        </ul>
    </div>
</body>
</html>
'''

def get_title(path):
    with open(path, 'r', encoding='utf-8') as f:
        html = f.read()
    pattern = r'<title>(.*)</title>'
    match = re.search(pattern, html, re.IGNORECASE)
    if match:
        return match.group(1).strip()
    else:
        return "no title"

if __name__ == '__main__':
    out_file = 'index.html'
    pattern = '[0-9][0-9][0-9][0-9]/[0-9][0-9][0-3][0-9]-[0-9][0-9].html'

    names = []
    for path in glob.glob(pattern):
        names.append(path.replace('\\', '/').replace('.html', ''))

    titles = {}
    for name in names:
        titles[name] = get_title(f"{name}.html")

    with open(out_file, 'w', encoding='utf8') as f:
        f.write(html_a)
        for name in names:
            f.write(f'\t\t\t<li><a href="{name}.html">[{name}] {titles[name]}</a></li>\n')
        f.write(html_b)
    print(f"Created: {out_file}")
    