#!/bin/sh

if [ -f ${STEAMAPPDIR}/Headless/Resonite.dll ]; then
	echo 'Resonite.dll is in the new (permanent) location, running...'
	exec ${STEAMAPPDIR}/dotnet-runtime/dotnet ${STEAMAPPDIR}/Headless/Resonite.dll -HeadlessConfig /Config/Config.json -Logs /Logs
else
	echo 'Resonite.dll not found, weird!'
	sleep 10
fi

