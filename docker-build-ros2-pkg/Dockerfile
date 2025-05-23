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
ARG BASE_IMAGE

# プラットフォームとベースのイメージを設定
FROM ${BASE_IMAGE}

# ワークスペスのディレクトリ名と必須aptパッケージの名前
ARG ROS_DISTRO="humble"
ARG PRE_IMPORT_SCRIPT=""
ARG GIT_REMOTE_URL
ARG GIT_SHA
ARG POST_IMPORT_SCRIPT=""
ARG GIT_CLONE_OPTIONS="--depth 1 --recurse-submodules"
ARG REPOS_FILES="*.repos"
ARG WORKSPACE_DIR="/root/ros2_ws"
ARG INSTALL_DIR="${WORKSPACE_DIR}/install"
ARG ENTRYPOINT_FILE="ros_ws_entrypoint.sh"
ARG PRE_BUILD_SCRIPT=""
ARG BUILD_OPTIONS="--cmake-args -DCMAKE_BUILD_TYPE=Release --install-base ${INSTALL_DIR}"
ARG POST_BUILD_SCRIPT="rm -rf ./log ./build ./src"

# 設定されたワークスペースに移動
WORKDIR ${WORKSPACE_DIR}

# ユーザー設定
USER root

# bashrcの設定
RUN echo "source ${INSTALL_DIR}/setup.bash" >> ~/.bashrc

# ws_entry_point.shのコピー
COPY ${ENTRYPOINT_FILE} /ros_ws_entrypoint.sh

# ビルドとgitの設定の実行
RUN <<EOF
  set -e

  # git clone 
  mkdir -p src/$(basename -s .git ${GIT_REMOTE_URL})
  cd src/$(basename -s .git ${GIT_REMOTE_URL})
  git init
  git remote add origin ${GIT_REMOTE_URL}
  git fetch --depth 1 origin ${GIT_SHA}
  git checkout FETCH_HEAD
  cd ${WORKSPACE_DIR}

  # vcs import
  for REPOS_FILE in src/*/${REPOS_FILES}; do
    if [ ! -f ${REPOS_FILE} ]; then continue; fi
    vcs import src < "${REPOS_FILE}"
  done

  # post import script
  ${POST_IMPORT_SCRIPT}

  # ビルド前のスクリプト
  ${PRE_BUILD_SCRIPT}

  # ビルド
  . /opt/ros/${ROS_DISTRO}/setup.sh
  colcon build ${BUILD_OPTIONS}

  # ビルド後のスクリプト
  ${POST_BUILD_SCRIPT}
EOF

# 実行前に行われる操作
ENTRYPOINT ["/ros_ws_entrypoint.sh"]

# 実行時のデフォルトのコマンド
CMD ["bash"]
