#!/bin/bash
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

# Source - https://stackoverflow.com/a/48957722
# Posted by mkb, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-07, License - CC BY-SA 4.0
sudo usermod -aG docker $USER
