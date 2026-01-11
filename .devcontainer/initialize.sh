#!/bin/sh

cd $(dirname $0)

# .envを作成(ホストのUIDとGIDを引き渡す為このタイミングで作成)
cat <<EOF > .env
CONTAINER_USER=vscode
CONTAINER_USER_HOME=/home/vscode
CONTAINER_ROOT=/workspace/root
HOST_UID=$(id -u)
HOST_GID=$(id -g)
EOF
