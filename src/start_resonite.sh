#!/bin/sh

#exec mono ${STEAMAPPDIR}/Headless/Resonite.exe -HeadlessConfig /Config/Config.json -Logs /Logs
exec dotnet ${STEAMAPPDIR}/Headless/net8.0/Resonite.dll -HeadlessConfig /Config/Config.json -Logs /Logs

