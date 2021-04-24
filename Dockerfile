FROM mono

LABEL name=neosvr-headless maintainer="panther.ru@gmail.com"

ENV	STEAMAPPID=740250 \
	STEAMAPP=neosvr \
	STEAMCMDURL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
	STEAMCMDDIR=/opt/steamcmd \
	STEAMBETA=__CHANGEME__ \
	STEAMBETAPASSWORD=__CHANGEME__ \
	STEAMLOGIN=__CHANGEME__ \
	USER=1000 \
	HOMEDIR=/home/steam
ENV	STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-headless"

# Prepare the basic environment
RUN	set -x && \
	apt-get -y update && \
	apt-get -y upgrade && \
	apt-get -y install curl lib32gcc1 && \
	rm -rf /var/lib/{apt,dpkg,cache}

# Add locales
RUN	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8 && \
	update-locale LANG=en_GB.UTF-8 && \
	rm -rf /var/lib/{apt,dpkg,cache}

ENV	LANG en_GB.UTF-8 

# Create user, install SteamCMD
RUN	addgroup -gid ${USER} steam && \
	adduser --disabled-login \
		--shell /bin/bash \
		--gecos "" \
		--gid ${USER} \
		--uid ${USER} \
		steam && \
	mkdir -p ${STEAMCMDDIR} ${HOMEDIR} ${STEAMAPPDIR} /Config /Logs && \
	cd ${STEAMCMDDIR} && \
	curl -sqL ${STEAMCMDURL} | tar zxfv - && \
	chown -R ${USER}:${USER} ${STEAMCMDDIR} ${HOMEDIR} ${STEAMAPPDIR} /Config /Logs

COPY	./start_neosvr.sh ${STEAMAPPDIR}/

RUN	chown -R ${USER}:${USER} ${STEAMAPPDIR}/start_neosvr.sh && \
	chmod +x ${STEAMAPPDIR}/start_neosvr.sh

# Switch to user
USER ${USER}

WORKDIR ${STEAMAPPDIR}

VOLUME ["${STEAMAPPDIR}", "/Config", "/Logs"]

CMD ["bash", "start_neosvr.sh"]
