# Docker Image Packaging for Atlassian Bamboo

## 7.2.0-XalvistackY - TBC

### Major Changes

  - Migrate from Travis CI to GitLab CI
  - Revamp with Packer

## 7.1.2-4alvistack6 - 2020-10-14

### Major Changes

  - Refine Molecule matrix

## 7.1.1-4alvistack4 - 2020-08-26

### Major Changes

  - Upgrade minimal Ansible Lint support to 4.3.2
  - Upgrade Travis CI test as Ubuntu Focal based
  - Upgrade minimal Ansible support to 2.10.0

## 7.0.4-4alvistack5 - 2020-06-10

### Major Changes

  - Revamp `create`, `side_effect`, `verify` and `destroy` logic
  - Replace `tini` with `catatonit`
  - Add podman support
  - Rename `post_tasks.yml` as `side_effect.yml`
  - Upgrade base image to Ubuntu 20.04

## 6.10.4-4alvistack4 - 2020-03-05

### Major Changes

  - Revamp with Molecule and `docker commit`
  - Consolidate molecule tests into `default` (noop)
  - Hotfix for systemd

## 6.10.4-3alvistack1 - 2020-01-15

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
