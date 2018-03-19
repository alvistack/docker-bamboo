# (c) Wong Hoi Sing Edison <hswong3i@pantarei-design.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04

ENV BAMBOO_OWNER                 "daemon"
ENV BAMBOO_GROUP                 "daemon"
ENV BAMBOO_HOME                  "/var/atlassian/application-data/bamboo"
ENV BAMBOO_CATALINA              "/opt/atlassian/bamboo"
ENV BAMBOO_DOWNLOAD_URL          "https://downloads.atlassian.com/software/bamboo/downloads/atlassian-bamboo-6.4.0.tar.gz"
ENV JAVA_HOME                    "/usr/java/default"
ENV JVM_MINIMUM_MEMORY           "512m"
ENV JVM_MAXIMUM_MEMORY           "1024m"
ENV CATALINA_CONNECTOR_PROXYNAME ""
ENV CATALINA_CONNECTOR_PROXYPORT ""
ENV CATALINA_CONNECTOR_SCHEME    "http"
ENV CATALINA_CONNECTOR_SECURE    "false"
ENV CATALINA_CONTEXT_PATH        ""
ENV JVM_SUPPORT_RECOMMENDED_ARGS "-Datlassian.plugins.enable.wait=300"

VOLUME  $BAMBOO_HOME
WORKDIR $BAMBOO_HOME

EXPOSE 8007
EXPOSE 8085

ENTRYPOINT [ "/usr/local/bin/dumb-init", "--" ]
CMD        [ "/etc/init.d/bamboo", "start", "-fg" ]

# Prepare APT depedencies
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y alien apt-transport-https apt-utils aptitude bzip2 ca-certificates curl debian-archive-keyring debian-keyring git htop patch psmisc python-apt rsync sudo unzip vim wget zip \
    && rm -rf /var/lib/apt/lists/*

# Install Oracle JRE
RUN set -ex \
    && ln -s /usr/bin/update-alternatives /usr/sbin/alternatives \
    && ARCHIVE="`mktemp --suffix=.rpm`" \
    && curl -skL -j -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jre-8u162-linux-x64.rpm > $ARCHIVE \
    && DEBIAN_FRONTEND=noninteractive alien -i -k --scripts $ARCHIVE \
    && rm -rf $ARCHIVE

# Install Atlassian Bamboo
RUN set -ex \
    && ARCHIVE="`mktemp --suffix=.tar.gz`" \
    && curl -skL $BAMBOO_DOWNLOAD_URL > $ARCHIVE \
    && mkdir -p $BAMBOO_CATALINA \
    && tar zxf $ARCHIVE --strip-components=1 -C $BAMBOO_CATALINA \
    && chown -Rf $BAMBOO_OWNER:$BAMBOO_GROUP $BAMBOO_CATALINA \
    && rm -rf $ARCHIVE

# Install MariaDB Connector/J JAR
RUN set -ex \
    && curl -skL https://downloads.mariadb.com/Connectors/java/connector-java-2.2.1/mariadb-java-client-2.2.1.jar > $BAMBOO_CATALINA/lib/mariadb-java-client-2.2.1.jar

# Install dumb-init
RUN set -ex \
    && curl -skL https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 > /usr/local/bin/dumb-init \
    && chmod 0755 /usr/local/bin/dumb-init

# Copy files
COPY files /

# Apply patches
RUN set -ex \
    && patch -d/ -p1 < /.patch

# Ensure required folders exist with correct owner:group
RUN set -ex \
    && mkdir -p $BAMBOO_HOME \
    && chown -Rf $BAMBOO_OWNER:$BAMBOO_GROUP $BAMBOO_HOME \
    && chmod 0755 $BAMBOO_HOME \
    && mkdir -p $BAMBOO_CATALINA \
    && chown -Rf $BAMBOO_OWNER:$BAMBOO_GROUP $BAMBOO_CATALINA \
    && chmod 0755 $BAMBOO_CATALINA
