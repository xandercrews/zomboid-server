#!/bin/bash -x

## script path SO-ware
## stackoverflow.com/questions/630372/determine-the-path-of-the-executing-bash-script
MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

## remove ../ ./ 
dir_resolve() {
  readlink -f "$@" || return $?
}

REPO_SETTINGS_RELATIVE="${MY_PATH}/../Zomboid/Server/"

if REPO_SETTINGS_PATH="$(dir_resolve ${REPO_SETTINGS_RELATIVE})"; then
  SETTINGS="${REPO_SETTINGS_PATH}/serversettings.ini"
  VARS_LUA="${REPO_SETTINGS_PATH}/serversettings_SandboxVars.lua"
  
  cp -a ~/Zomboid/Server/serversettings* "${REPO_SETTINGS_PATH}"
  
  ## strip server noncey things
  sed -i 's/^\s*\(ResetID=\).*/\1/' "${SETTINGS}"
  sed -i 's/^\s*\(ServerPlayerID=\).*/\1/' "${SETTINGS}"
  
  ## dont plan on checking in rcon passwords but ¯\_(ツ)_/¯
  sed -i 's/^\s*\(Password=\).*/\1/' "${SETTINGS}"
  sed -i 's/^\s*\(RCONPassword=\).*/\1/' "${SETTINGS}"
else
  >&2 echo problem resolving paths
  exit 1
fi
