#!/bin/bash
set -e

get_rodep_apt() {
  for ROSDEP_KEY in "$@"; do
    ROSDEP_RESOLVED=$(rosdep resolve "$ROSDEP_KEY")
    for ROSDEP_RESOLVED_LINE in $ROSDEP_RESOLVED; do
      if [[ "$ROSDEP_RESOLVED_LINE" == \#* ]];
      then
        ROSDEP_RESOLVED_PACKAGE_MANAGER="$ROSDEP_RESOLVED_LINE"
        continue
      fi

      if [[ "$ROSDEP_RESOLVED_PACKAGE_MANAGER" == "#apt" ]];
      then
        ROSDEP_APT_PACKAGES+=("$ROSDEP_RESOLVED_LINE")
        continue
      fi
      if [[ "$ROSDEP_RESOLVED_PACKAGE_MANAGER" == "#pip" ]];
      then
        ROSDEP_APT_PACKAGES+=("python3-$ROSDEP_RESOLVED_LINE")
        continue
      fi

      echo "Unknown rosdep resolved package manager: $ROSDEP_RESOLVED_PACKAGE_MANAGER"
      exit 1
    done
  done
  echo "${ROSDEP_APT_PACKAGES[@]}"
  unset ROSDEP_APT_PACKAGES
}

export BUILD_APT_DEPENDS="$(get_rodep_apt $(rosdep keys --from-paths /home/miyajima-d/traps_ws/.src -t build -t build_export -t buildtool -t buildtool_export -i))"
if [ -z "$BUILD_APT_DEPENDS" ]; then
  echo "build-install-script=" >> $GITHUB_OUTPUT
else
  echo "build-install-script=\
  apt-get update &&\
  apt-get install --no-install-recommends $BUILD_APT_DEPENDS &&\
  apt-get cloean && rm -rf /var/lib/apt/lists/*" >> $GITHUB_OUTPUT
fi

export EXEC_APT_DEPENDS="$(get_rodep_apt $(rosdep keys --from-paths /home/miyajima-d/traps_ws/.src -t exec -i))"
if [ -z "$EXEC_APT_DEPENDS" ]; then
  echo "exec-install-script=" >> $GITHUB_OUTPUT
else
  echo "exec-install-script=\
  apt-get update &&\
  apt-get install --no-install-recommends $BUILD_APT_DEPENDS &&\
  apt-get cloean && rm -rf /var/lib/apt/lists/*" >> $GITHUB_OUTPUT
fi