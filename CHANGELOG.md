# Docker Image Packaging for Atlassian Bamboo

## 6.10.4-XalvistackY - TBC

### Major Changes

## 6.10.4-3alvistack1 - TBC

### Major Changes

  - Replace `dumb-init` with `tini`, as like as `docker --init`
  - Replace `java` with `openjdk`
  - Include release specific vars and tasks

## 6.10.3-2alvistack3 - 2019-11-05

### Major Changes

  - Upgrade minimal Ansible support to 2.9.0
  - Upgrade Travis CI test as Ubuntu Bionic based
  - Default with Python 3
  - Hotfix for en\_US.utf8 locale
  - Allow the container to be stated with `--user`
  - Simplify parameters combination with `BAMBOO_VERSION`
  - Prepend executable if command starts with an option
  - Improve `ENTRYPOINT` and `CMD`

## 6.8.1-0alvistack6 - 2019-05-30

### Major Changes

  - Bugfix "Build times out because no output was received"
  - Upgrade minimal Ansible support to 2.8.0

## 6.8.1-0alvistack3 - 2019-04-16

### Major Changes

  - Run systemd service with specific system user
  - Explicitly set system user UID/GID
  - Porting to Molecule based

## 6.7.1-1alvistack1 - 2018-12-10

### Major Changes

  - Update base image to Ubuntu 18.04
  - Revamp deployment with Ansible roles
  - Replace Oracle Java with OpenJDK

## 6.7.1-0alvistack2 - 2018-10-29

### Major Changes

  - Handle changes with patch
  - Update dumb-init to v.1.2.2
  - Upgrade MySQL Connector/J and PostgreSQL JDBC support
  - Add TZ support
  - Add SESSION\_TIMEOUT support
  - Add CVS, SVN, GIT, Mercurial, Perforce support
  - Add Docker CE support

## 6.4.0-0alvistack3 - 2018-03-10

### Major Changes

  - Simplify Docker image naming

## 6.4.0-0alvistack1 - 2018-02-28

  - Migrate from <https://github.com/alvistack/ansible-container-bamboo>
  - Pure Dockerfile implementation
  - Ready for both Docker and Kubernetes use cases
