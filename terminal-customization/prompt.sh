#!/usr/bin/env bash

# Nerd font icons

#                                   
## coffee
#    
## drink
#  
## lunch
#   󰚅 
## studies
# 󰑴 
## storage/database
#  󰆼  
# 󰅺   󰆇  󰆀  
## Simleys
#                
## github
#               
## gitlab
#  󰮠 
## git
#     
## branch
#     
#  =
#        
# 󰟒  󰬪 󰟃 
## home
#       
#    
#   
## user
#    󱂽     
## group
#   
## config
#   
#   󰅟       󰕥         
#     
#            
# 󰟒           
## dir
#   
## usb
#    
#  󰥖   󰭹  
## cpu
#  
## temperature 
# 󰔄 󰔅
# 
#    󰇙
# hello
#   󰑆  󰑄  󰑂 󰑅 󰑀  󰑃  


git_prompt() {
   echo $PS1 | grep -q 033 && color_prompt=yes || color_prompt=no
   # `man terminfo`  to see tput option..
   COLOR_GREY="$(tput setaf 8)"
   COLOR_RESET="$(tput sgr0)"
   GITHUB_ICON=
   GITLAB_ICON=
   GIT_IGNORE_ICON=
   NEW_LINE="$(tput nel)"
   ICON=""
   current_branch=$(git branch --show-current 2>/dev/null)
   origin=$(git remote get-url origin 2>/dev/null | sed "s/git@\(.*\)\.git/\1/")
   echo $origin | grep -q github.com && ICON=$GITHUB_ICON
   [ -z "${current_branch}" ] && origin="git:local"
   [ -n "${current_branch}" ] && echo "${COLOR_GREY} ${ICON} ${current_branch}${COLOR_RESET}${NEW_LINE}"
}

git_prompt
