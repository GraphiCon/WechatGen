# WechatGen
One-line command for generating wechat post from markdown.

**Note:** Special markup for author and proofreader.

At the beginning of your markdown post, add:
```
作者：XXX { .author}
审校：XXX { .proofread}
```

## Requirements
- pandoc

For installing pandoc, please see the instructions here: [pandoc installing](http://pandoc.org/installing.html)

On MacOS, just
```bash
brew install pandoc
```
On Arch linux, just
```bash
pacman -S pandoc
```
## Usage
First, make the script executable:
Type in terminal:
```bash
chmod 755 ${PATH_TO_WECHATGEN}/wechatgen.sh
```
Then run the script:
```bash
${PATH_TO_WECHATGEN}/wechatgen.sh yourmarkdown.md
```
Please see the simple example in /examples folder.
