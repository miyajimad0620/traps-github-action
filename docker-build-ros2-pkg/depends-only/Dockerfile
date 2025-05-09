# Copyright 2024 TRAPS

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# イメージ引数設定
ARG ROS_DISTRO=humble

# プラットフォームとベースのイメージを設定
FROM ros:${ROS_DISTRO}

# ワークスペスのディレクトリ名と必須aptパッケージの名前
ARG APT_DEPENDS_STR="ros-humble-rmw-cyclonedds-cpp"

# ユーザー設定
USER root

# install cyclone-dds
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

RUN <<EOF
  set -e
  apt-get update
  apt-get install -y --no-install-recommends $APT_DEPENDS_STR
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

# 実行前に行われる操作
ENTRYPOINT ["/ros_entrypoint.sh"]

# 実行時のデフォルトのコマンド
CMD ["bash"]
