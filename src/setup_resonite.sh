#!/bin/sh

bash "${STEAMCMDDIR}/steamcmd.sh" \
	+@sSteamCmdForcePlatformType windows \
	+force_install_dir ${STEAMAPPDIR} \
	+login ${STEAMLOGIN} \
	+app_license_request ${STEAMAPPID} \
	+app_update ${STEAMAPPID} -beta ${STEAMBETA} -betapassword ${STEAMBETAPASSWORD} validate \
	+quit

chmod +x ${STEAMAPPDIR}/dotnet-install.sh
${STEAMAPPDIR}/dotnet-install.sh --channel ${DOTNETVERSION} --runtime dotnet --install-dir ${STEAMAPPDIR}/dotnet-runtime

find ${STEAMAPPDIR}/Data/Assets -type f -atime +7 -delete
find ${STEAMAPPDIR}/Data/Cache -type f -atime +7 -delete
find /Logs -type f -name *.log -atime +30 -delete
mkdir -p Headless/Migrations
exec $*
