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

FROM ubuntu:18.04

ENV LANG   "C.UTF-8"
ENV LC_ALL "C.UTF-8"
ENV SHELL  "/bin/bash"
ENV TZ     "UTC"

ENV BAMBOO_VERSION               "6.10.2"
ENV BAMBOO_OWNER                 "bamboo"
ENV BAMBOO_GROUP                 "bamboo"
ENV BAMBOO_HOME                  "/var/atlassian/application-data/bamboo"
ENV BAMBOO_CATALINA              "/opt/atlassian/bamboo"
ENV JVM_MINIMUM_MEMORY           "1024m"
ENV JVM_MAXIMUM_MEMORY           "1024m"
ENV CATALINA_CONNECTOR_PROXYNAME ""
ENV CATALINA_CONNECTOR_PROXYPORT ""
ENV CATALINA_CONNECTOR_SCHEME    "http"
ENV CATALINA_CONNECTOR_SECURE    "false"
ENV CATALINA_CONTEXT_PATH        "/"
ENV JVM_SUPPORT_RECOMMENDED_ARGS "-Datlassian.plugins.enable.wait=300 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1"
ENV TZ                           "UTC"
ENV SESSION_TIMEOUT              "30"

VOLUME  $BAMBOO_HOME
WORKDIR $BAMBOO_HOME

EXPOSE 8007
EXPOSE 8085

ENTRYPOINT [ "dumb-init", "--", "docker-entrypoint.sh" ]
CMD        [ "/opt/atlassian/bamboo/bin/start-bamboo.sh", "-fg" ]

# Explicitly set system user UID/GID
RUN set -ex \
    && groupadd -r $BAMBOO_OWNER \
    && useradd -r -g $BAMBOO_GROUP -d $BAMBOO_HOME -M -s /usr/sbin/nologin $BAMBOO_OWNER

# Prepare APT dependencies
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install ca-certificates curl gcc git libffi-dev libssl-dev make python3 python3-dev sudo \
    && rm -rf /var/lib/apt/lists/*

# Install PIP
RUN set -ex \
    && curl -skL https://bootstrap.pypa.io/get-pip.py | python3

# Copy files
COPY files /

# Bootstrap with Ansible
RUN set -ex \
    && cd /etc/ansible/roles/localhost \
    && pip3 install --upgrade --requirement requirements.txt \
    && molecule dependency \
    && molecule lint \
    && molecule syntax \
    && molecule converge \
    && molecule verify \
    && rm -rf /var/cache/ansible/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cache/* \
    && rm -rf /tmp/*
