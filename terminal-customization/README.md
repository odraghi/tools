# Terminal Customization

## Prompt features
- context icon of the current dir
- warning if low filesystem space (thresold 80%)
- git context (icon git, github, gitlab) and current branch

## Install
```bash
bash install.sh
```

## Prompt control
You can call those functions to change the behaviour of the prompt

```bash
# Those are enabled by default
disable_prompt_plugins
disable_prompt_plugins_color
disable_prompt_icons
disable_prompt_warning_size

enable_prompt_plugins
enable_prompt_plugins_color
enable_prompt_icons
enable_prompt_warning_size
```

## Requirements - Nerd Font
You must install a **Nerd font** in your **Terminal Desktop** to be able to redend font icons.
https://www.nerdfonts.com/font-downloads

I like `UbuntuSansMono NF` - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuSans.zip

**Tips for MacOS**
1. Download the zip file and unzip it.
2. Open the app `Font Book`
3. **File > Validate a File >**  Select the `.ttf` files, validate and install them.
notes:
- After installing the first 'User fonts' you need to restart your computer to be able to use them.
- Fonts are installed in ~/Library/Fonts/


