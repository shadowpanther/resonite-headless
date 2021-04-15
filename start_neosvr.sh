#!/bin/sh

bash "${STEAMCMDDIR}/steamcmd.sh" +login ${STEAMLOGIN} +force_install_dir ${STEAMAPPDIR} +app_license_request ${STEAMAPPID} \
	"+app_update ${STEAMAPPID} -beta ${STEAMBETA} -betapassword ${STEAMBETAPASSWORD}" validate +quit
find ./Data/Assets -atime +7 -delete
find ./Data/Cache -atime +7 -delete
find /Logs -atime +30 -delete
mono Neos.exe -c /Config/Config.json -l /Logs
