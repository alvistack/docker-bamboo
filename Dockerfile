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

ENV BAMBOO_OWNER                 "bamboo"
ENV BAMBOO_GROUP                 "bamboo"
ENV BAMBOO_HOME                  "/var/atlassian/application-data/bamboo"
ENV BAMBOO_CATALINA              "/opt/atlassian/bamboo"
ENV BAMBOO_DOWNLOAD_URL          "https://product-downloads.atlassian.com/software/bamboo/downloads/atlassian-bamboo-6.8.0.tar.gz"
ENV JAVA_HOME                    "/usr/lib/jvm/java-8-openjdk-amd64"
ENV JVM_MINIMUM_MEMORY           "512m"
ENV JVM_MAXIMUM_MEMORY           "1024m"
ENV CATALINA_CONNECTOR_PROXYNAME ""
ENV CATALINA_CONNECTOR_PROXYPORT ""
ENV CATALINA_CONNECTOR_SCHEME    "http"
ENV CATALINA_CONNECTOR_SECURE    "false"
ENV CATALINA_CONTEXT_PATH        ""
ENV JVM_SUPPORT_RECOMMENDED_ARGS "-Datlassian.plugins.enable.wait=300"
ENV TZ                           "UTC"
ENV SESSION_TIMEOUT              "30"

VOLUME  $BAMBOO_HOME
WORKDIR $BAMBOO_HOME

EXPOSE 8007
EXPOSE 8085

ENTRYPOINT [ "dumb-init", "--" ]
CMD        [ "docker-entrypoint.sh" ]

# Prepare APT depedencies
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential curl git libffi-dev libssl-dev python-dev python-minimal \
    && rm -rf /var/lib/apt/lists/*

# Install PIP
RUN set -ex \
    && curl -skL https://bootstrap.pypa.io/get-pip.py | python

# Install PIP dependencies
RUN set -ex \
    && pip install ansible ansible-lint yamllint \
    && rm -rf /root/.cache/pip

# Copy files
COPY files /

# Bootstrap with Ansible
RUN set -ex \
    && ansible-galaxy install --force --roles-path /etc/ansible/roles --role-file /etc/ansible/ansible-role-requirements.yml \
    && yamllint --config-file /etc/ansible/.yamllint /etc/ansible \
    && ansible-lint /etc/ansible/playbooks/bootstrap.yml \
    && ansible-playbook /etc/ansible/playbooks/bootstrap.yml --syntax-check \
    && ansible-playbook /etc/ansible/playbooks/bootstrap.yml --diff \
    && ansible-playbook /etc/ansible/playbooks/bootstrap.yml --diff
