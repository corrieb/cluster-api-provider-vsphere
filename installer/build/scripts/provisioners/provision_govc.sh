#!/usr/bin/bash
# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -euf -o pipefail

DIR="$(mktemp -d)"
cd $DIR
GOVC_SHA256="3c484b6373ead75385c7e34569767e12b38e22d1a71a7e400be7a0f76fed5fd2  govc_linux_amd64.gz"
cat > "SHA256SUMS" << EOF
${GOVC_SHA256}
EOF

# TODO(frapposelli): parametrize govc version
curl -L"#" -o govc_linux_amd64.gz https://github.com/vmware/govmomi/releases/download/v0.19.0/govc_linux_amd64.gz
shasum -a 256 --check SHA256SUMS || (echo "Failed to verify govc checksum" && exit 1)

gunzip --stdout govc_linux_amd64.gz > govc
sudo install -t /usr/local/bin/ govc
