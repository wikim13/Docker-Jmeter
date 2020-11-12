# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
#1. setup the jmeter environment.
#2. parameterize the input files.
#3. parameteized the output files.

FROM alpine:3.12

MAINTAINER Vikas_Mishra

ARG JMETER_VERSION="5.3"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL https://repo1.maven.org/maven2/kg/apc
ARG JMETER_PLUGINS_MANAGER_VERSION="1.3"
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext/
ARG CMDRUNNER_VERSION="2.2"

# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Europe/Amsterdam"
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/cmdrunner/${CMDRUNNER_VERSION}/cmdrunner-${CMDRUNNER_VERSION}.jar -o ${JMETER_HOME}/lib/cmdrunner-${CMDRUNNER_VERSION}.jar && \
    java -cp ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar org.jmeterplugins.repository.PluginManagerCMDInstaller && ls -lrt ${JMETER_BIN} && cd ${JMETER_BIN} && chmod a+x PluginsManagerCMD.sh && pwd 
RUN  /opt/apache-jmeter-5.3/bin/PluginsManagerCMD.sh install jpgc-json 2.7,jpgc-graphs-basic=2.0


# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
