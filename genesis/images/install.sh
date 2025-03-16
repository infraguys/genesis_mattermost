#!/usr/bin/env bash

# Copyright 2025 Genesis Corporation
#
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -eu
set -x
set -o pipefail

[[ "$EUID" == 0 ]] || exec sudo -s "$0" "$@"

# Update the system
apt update
apt upgrade -y

# Install postgres
apt install -y postgresql postgresql-contrib uuid nginx

# Install mattermost
curl -sL -o- https://deb.packages.mattermost.com/pubkey.gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/mattermost-archive-keyring.gpg > /dev/null
curl -o- https://deb.packages.mattermost.com/repo-setup.sh | bash -s mattermost
apt update
apt install mattermost -y

sudo install -C -m 600 -o mattermost -g mattermost \
    /opt/mattermost/config/config.defaults.json \
    /opt/mattermost/config/config.json
