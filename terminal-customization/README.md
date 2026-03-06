# Terminal Customization

## Prompt features
- context icon of the current dir
- warning if low filesystem space (thresold 80%)
- date / time
- python venv
- git context (icon git, github, gitlab) , current branch and number of pending change

## Requirements - Nerd Font
You must install a **Nerd font** in your **Terminal Desktop** to be able to redend font icons.
https://www.nerdfonts.com/font-downloads

I like `UbuntuSansMono NF` - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuSans.zip
File: UbuntuSansMonoNerdFont-Regular.ttf

**Tips for MacOS**
1. Download the zip file and unzip it.
2. Open the app `Font Book`
3. **File > Validate a File >**  Select the `.ttf` files, validate and install them.
notes:
- After installing the first 'User fonts' you need to restart your computer to be able to use them.
- Fonts are installed in ~/Library/Fonts/

## Install
```bash
bash install.sh
```

## Prompt control
Those functions change the behaviour of the current prompt.

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


toggle_prompt_clock_format

prompt_venv_decorator_bubble
prompt_venv_decorator_pointer_in
prompt_venv_decorator_pointer_out
prompt_venv_decorator_arrow_right
prompt_venv_decorator_arrow_left
prompt_venv_decorator_parallelogram_right
prompt_venv_decorator_parallelogram_left
prompt_venv_decorator_circle_right
prompt_venv_decorator_circle_left
```

## Tools
those functions help you choosing colors

```bash
tput_rainbow_font_for_background_color
tput_rainbow_background_for_font_color
tput_rainbow
```

## Persist behaviour and color
You can customize behaviour and color in `$HOME/bash_prompt`

Look at those configuration sections
```conf
## Behaviours customization

## Colors customization
```


