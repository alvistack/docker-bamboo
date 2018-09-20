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
ENV BAMBOO_DOWNLOAD_URL          "https://downloads.atlassian.com/software/bamboo/downloads/atlassian-bamboo-6.6.2.tar.gz"
ENV JAVA_HOME                    "/usr/java/default"
ENV JVM_MINIMUM_MEMORY           "512m"
ENV JVM_MAXIMUM_MEMORY           "1024m"
ENV CATALINA_CONNECTOR_PROXYNAME ""
ENV CATALINA_CONNECTOR_PROXYPORT ""
ENV CATALINA_CONNECTOR_SCHEME    "http"
ENV CATALINA_CONNECTOR_SECURE    "false"
ENV CATALINA_CONTEXT_PATH        ""
ENV JVM_SUPPORT_RECOMMENDED_ARGS "-Datlassian.plugins.enable.wait=300"
ENV TZ                           "Etc/UTC"

VOLUME  $BAMBOO_HOME
WORKDIR $BAMBOO_HOME

EXPOSE 8007
EXPOSE 8085

ENTRYPOINT [ "dumb-init", "--" ]
CMD        [ "/etc/init.d/bamboo", "start", "-fg" ]

# Prepare APT depedencies
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y alien apt-transport-https apt-utils aptitude bzip2 ca-certificates curl debian-archive-keyring debian-keyring git htop patch psmisc python-apt rsync software-properties-common sudo tzdata unzip vim wget zip \
    && rm -rf /var/lib/apt/lists/*

# Install CVS
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y cvs \
    && rm -rf /var/lib/apt/lists/*

# Install SVN
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libsvn-java subversion \
    && rm -rf /var/lib/apt/lists/*

# Install GIT
RUN set -ex \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

# Install Mercurial
RUN set -ex \
    && add-apt-repository -y ppa:mercurial-ppa/releases \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mercurial \
    && rm -rf /var/lib/apt/lists/*

# Install Perforce
RUN set -ex \
    && curl -sL https://package.perforce.com/perforce.pubkey | apt-key add - \
    && add-apt-repository -y "deb http://package.perforce.com/apt/ubuntu $(lsb_release -cs) release" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y helix-cli \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CE
RUN set -ex \
    && curl -sL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce \
    && rm -rf /var/lib/apt/lists/*

# Install Oracle JRE
RUN set -ex \
    && ln -s /usr/bin/update-alternatives /usr/sbin/alternatives \
    && ARCHIVE="`mktemp --suffix=.rpm`" \
    && curl -skL -j -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jre-8u181-linux-x64.rpm > $ARCHIVE \
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

# Install MySQL Connector/J JAR
RUN set -ex \
    && ARCHIVE="`mktemp --suffix=.tar.gz`" \
    && curl -skL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.12.tar.gz > $ARCHIVE \
    && tar zxf $ARCHIVE --strip-components=1 -C $BAMBOO_CATALINA/lib/ mysql-connector-java-8.0.12/mysql-connector-java-8.0.12.jar \
    && rm -rf $ARCHIVE

# Install PostgreSQL JDBC JAR
RUN set -ex \
    && rm -rf $BAMBOO_CATALINA/lib/*postgresql*.jar \
    && curl -skL https://jdbc.postgresql.org/download/postgresql-42.2.4.jar > $BAMBOO_CATALINA/lib/postgresql-42.2.4.jar

# Install dumb-init
RUN set -ex \
    && curl -skL https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 > /usr/local/bin/dumb-init \
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
