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

import os
import json

password = os.environ["DB_PASSWORD"]


with open("/opt/mattermost/config/config.json", "r") as fp:
    config = json.load(fp)

config["SqlSettings"]["DriverName"] = "postgres"
config["SqlSettings"]["DataSource"] = (
    f"postgres://mmuser:{password}@localhost/mattermostdb?"
    "sslmode=disable\u0026connect_timeout=10\u0026"
    "binary_parameters=yes"
)

with open("/opt/mattermost/config/config.json", "w") as fp:
    json.dump(config, fp, indent=4)
