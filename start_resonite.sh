#!/bin/sh

exec mono ${STEAMAPPDIR}/Neos.exe -c /Config/Config.json -l /Logs
