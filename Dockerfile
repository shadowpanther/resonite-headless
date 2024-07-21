FROM	ubuntu

LABEL	name=resonite-headless org.opencontainers.image.authors="panther.ru@gmail.com"

ENV	STEAMAPPID=2519830 \
	STEAMAPP=resonite \
	STEAMCMDURL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
	STEAMCMDDIR=/opt/steamcmd \
	STEAMBETA=__CHANGEME__ \
	STEAMBETAPASSWORD=__CHANGEME__ \
	STEAMLOGIN=__CHANGEME__ \
	USER=2000 \
	HOMEDIR=/home/steam
ENV	STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-headless"

# Prepare the basic environment
RUN	set -x && \
	apt -y update && \
	apt -y upgrade && \
	apt -y install curl lib32gcc-s1 libopus-dev libopus0 opus-tools libc6-dev dotnet-runtime-8.0 && \
	rm -rf /var/lib/{apt,dpkg,cache}

# Add locales
RUN	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8 && \
	update-locale LANG=en_GB.UTF-8 && \
	rm -rf /var/lib/{apt,dpkg,cache}
ENV	LANG en_GB.UTF-8

# Fix the LetsEncrypt CA cert (is this still needed?)
#RUN	sed -i 's#mozilla/DST_Root_CA_X3.crt#!mozilla/DST_Root_CA_X3.crt#' /etc/ca-certificates.conf && update-ca-certificates

# Create user, install SteamCMD
RUN	groupadd --gid ${USER} steam && \
	useradd --home-dir ${HOMEDIR} \
		--create-home \
		--shell /bin/bash \
		--comment "" \
		--gid ${USER} \
		--uid ${USER} \
		steam && \
	mkdir -p ${STEAMCMDDIR} ${STEAMAPPDIR} /Config /Logs /Scripts && \
	cd ${STEAMCMDDIR} && \
	curl -sqL ${STEAMCMDURL} | tar zxfv - && \
	chown -R ${USER}:${USER} ${STEAMCMDDIR} ${STEAMAPPDIR} /Config /Logs

COPY	--chown=${USER}:${USER} --chmod=755./src/setup_resonite.sh ./src/start_resonite.sh /Scripts/

#RUN	chown -R ${USER}:${USER} /Scripts/setup_resonite.sh /Scripts/start_resonite.sh && \
#	chmod +x /Scripts/setup_resonite.sh /Scripts/start_resonite.sh

# Switch to user
USER	${USER}

WORKDIR	${STEAMAPPDIR}

VOLUME ["${STEAMAPPDIR}", "/Config", "/Logs"]

STOPSIGNAL SIGINT

ENTRYPOINT ["/Scripts/setup_resonite.sh"]
CMD ["/Scripts/start_resonite.sh"]
