#!/bin/bash

# このスクリプトはリポジトリ内のすべてのシェルスクリプトに実行権限を付与します

# リポジトリのルートディレクトリ
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Adding execute permissions to all shell scripts in $REPO_DIR"

# ルートディレクトリの.shファイルに権限を付与
find "$REPO_DIR" -maxdepth 1 -name "*.sh" -type f -exec chmod +x {} \;
chmod +x "$REPO_DIR/utils.sh"

# packagesディレクトリのスクリプトに権限を付与
if [ -d "$REPO_DIR/packages" ]; then
  find "$REPO_DIR/packages" -name "*.sh" -type f -exec chmod +x {} \;
  echo "Added execute permissions to scripts in $REPO_DIR/packages"
fi

echo "All shell scripts now have execute permissions."
