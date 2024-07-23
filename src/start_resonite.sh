#!/bin/sh

if [ -f ${STEAMAPPDIR}/Headless/Resonite.dll ]; then
	echo 'Resonite.dll is in the new (permanent) location, running...'
	exec dotnet ${STEAMAPPDIR}/Headless/Resonite.dll -HeadlessConfig /Config/Config.json -Logs /Logs
elif [ -f ${STEAMAPPDIR}/Headless/net8.0/Resonite.dll ]; then
	echo 'Resonite.dll is in the old (temporary) location, running...'
	exec dotnet ${STEAMAPPDIR}/Headless/net8.0/Resonite.dll -HeadlessConfig /Config/Config.json -Logs /Logs
else
	echo 'Resonite.dll not found, weird!'
	sleep 10
fi

