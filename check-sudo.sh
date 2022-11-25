#! /bin/bash

prompt=$(sudo -nv 2>&1)

if [ $? -eq 0 ]; then
  # exit code of sudo-command is 0
  # "has_sudo__pass_set"
  echo 1
elif echo $prompt | grep -q '^sudo:'; then
  # "has_sudo__needs_pass"
  echo 0
else
  # "no_sudo"
  echo -1
fi
