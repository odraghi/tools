# Terminal Customization

## Nerd Font
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

## Prompt customization - PS0, PS1 ..
Good documentation here https://wiki.archlinux.org/title/Bash/Prompt_customization
In short:
- PS0 is displayed after each command, before any output.
- PS1 is the primary prompt which is displayed before each command, thus it is the one most people customize.
- PS2 is the secondary prompt displayed when a command needs more input (e.g. a multi-line command).
- PS3 is not very commonly used. It is the prompt displayed for Bash's select built-in which displays interactive menus. Unlike the other prompts, it does not expand Bash escape sequences. Usually you would customize it in the script where the select is used rather than in your .bashrc.
- PS4 is also not commonly used. It is displayed when debugging bash scripts to indicate levels of indirection. The first character is repeated to indicate deeper levels.
