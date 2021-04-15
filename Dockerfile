FROM cm2network/steamcmd:root

LABEL maintainer="panther.ru@gmail.com"

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		software-properties-common \
		apt-transport-https dirmngr gnupg ca-certificates \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
	&& apt-add-repository "deb https://download.mono-project.com/repo/debian stable-buster main" \
	&& apt-get update \
	&& apt-get install  -y --no-install-recommends --no-install-suggests \
		mono-complete \
	&& rm -rf /var/lib/{apt,dpkg,cache}

ENV	STEAMAPPID=740250 \
	STEAMAPP=neosvr \
	STEAMBETA=CHANGEME \
	STEAMBETAPASSWORD=CHANGEME \
	STEAMLOGIN=CHANGEME
ENV	STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-headless"

RUN	mkdir -p "${STEAMAPPDIR}" \
	mkdir -p /Config \
	mkdir -p /Logs

COPY	./start_neosvr.sh ${STEAMAPPDIR}/

RUN	chown -R "${USER}:${USER}" "${STEAMAPPDIR}/start_neosvr.sh" "${STEAMAPPDIR}" "/Config" "/Logs" \
	&& chmod +x "${STEAMAPPDIR}/start_neosvr.sh"

# Switch to user
USER ${USER}

WORKDIR ${STEAMAPPDIR}

VOLUME ["${STEAMAPPDIR}", "/Config", "/Logs"]

CMD ["bash", "start_neosvr.sh"]
