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


DB_PASSWORD=$(uuid)

# setup postgres
sudo -u postgres psql -c "CREATE DATABASE mattermostdb;"
sudo -u postgres psql -c "CREATE USER mmuser WITH PASSWORD '${DB_PASSWORD}';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mattermostdb TO mmuser;"
sudo -u postgres psql -c "GRANT ALL ON SCHEMA public TO mmuser;"
sudo -u postgres psql -c "ALTER DATABASE mattermostdb OWNER TO mmuser;"
sudo -u postgres psql -c "GRANT CREATE ON SCHEMA public TO mmuser;"

python3 /opt/mattermost/bin/initconfig.py

systemctl enable mattermost
systemctl start mattermost