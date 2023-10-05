#!/bin/bash
#set -x
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ $# -ne 1 ]; then
    echo $0: usage: Requires argument of Organizational id e.g.   12345678910
    exit 1
fi

export organization=$1 
export pool_name=$(gcloud iam workforce-pools list --organization=${organization} --location=global --format=json |jq -r .[].name | awk -F '/' '{print $4}')
for x in pool_name 
do 
    export location=$(gcloud iam workforce-pools list --organization=${organization} --location=global --format=json |jq -r .[].name | awk -F '/' '{print $2}')

    gcloud iam workforce-pools describe ${pool_name} --location=${location}
    gcloud iam workforce-pools providers list --workforce-pool=${pool_name} --location=${location}
done