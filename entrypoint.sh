#!/bin/sh

if [ -n "${INSTALL_APPS}" ]; then
  OLD_IFS=$IFS
  IFS=','
  for app in ${INSTALL_APPS}; do
    steamcmd_binary="steamcmd"
    password_bypass=""
    if [ -n "${PASSWORD}" ]; then
      password_bypass="echo '${PASSWORD}' | "
    fi
    if [ "${FORCE_INSTALL}" = "true" ]; then
      echo "Force re-install $app"
      /bin/sh -c "${password_bypass}${steamcmd_binary} +login '${LOGIN}' +force_install_dir /steam/${app} +app_update ${app} validate +quit"
    else
      echo "Check if app ${app} was installed"
      if [ -d "/steam/${app}" ]; then
        echo "App ${app} already installed"
      else
        echo "App ${app} need to be downloaded"
        /bin/sh -c "${password_bypass}${steamcmd_binary} +login '${LOGIN}' +force_install_dir /steam/${app} +app_update ${app} validate +quit"
      fi
    fi
  done
  IFS=$OLD_IFS
fi

arguments=$@
case "$arguments" in
  "/"*)
    echo "Run commands : ${arguments}"
    /bin/sh -c "$arguments";;
  *)
    echo "Run commands : steamcmd ${arguments}"
    steamcmd $arguments
esac
