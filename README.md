# devcontainer-starter

## はじめに

VSCode で Dev Container による開発環境を構築する時のテンプレートを作成しました（nodeJS を使用する想定）<br>
特に 環境を構築する時にトラブルになりやすいユーザー情報(UID/GID)について、ホスト OS から引き継いだ値で Dev Container 用ユーザー情報を作成するようにしています<br>

## 使用方法

### 1. 前提条件

下記環境で作成/動作確認しています

- Mac
- Colima
- Visual Studio Code
- VSCode Dev Containers 拡張機能 or Remote Development
- Zsh
  (Windows/WSL2 での動作確認はしていませんが Windows 環境でも Docker 実行及び WSL2 ユーザーのシェルが zsh となっていれば動作すると思います)

### 2.セットアップ手順

リポジトリのクローン

```mac
git clone https://github.com/satoppe343/devcontainer-starter.git
```

下記操作を行いクローンしたリポジトリを Dev Container で開く

```mac GUI
1. VS Codeでプロジェクトフォルダを開く
2. F1キー（またはCtrl+Shift+P / Cmd+Shift+P）を押してコマンドパレットを開く
3. クローンしたディレクトリを選択
```

以上で VSCode で Dev Container で作成されたコンテナ内で作業が可能となります

### 3. 動作確認

- ユーザー情報(UID/GID)がホスト OS から引き継がれている事の確認

```zsh
id
```

- コンテナ一覧の確認

```zsh
docker ps -a
```

- Dev Container で作成されたコンテナの削除

```zsh
docker rm -f $(docker ps -a | grep devcontainer-starter | cut -d ' ' -f 1)
```

※何か不明な不具合が発生した場合はコンテナを削除してみると解決する場合が多いです

### 4. その他

Devcontainer 実行ユーザーのユーザー情報(UID/GID)をホスト OS から引き継がないで新規 ID を振るように変更したい場合は下記設定を変更してください
ただしその場合、ファイル権限の設定変更など更に追加で設定が必要になるはずですが、現時点では未検討で動作確認もしていない為、必要な修正を別途検討して対応する必要があります（そういった検討を避ける為に現在の仕様で環境作成するようにしています）

- `initialize.sh` の下記について固定値(2000 など)を設定するように変更（`.env`をファイルとして作成し、スクリプトで都度作成する処理を削除する方がベター）

```initialize.sh
(変更前)
HOST_UID=$(id -u)
HOST_GID=$(id -g)
```

```initialize.sh
(変更後)
HOST_UID=2000
HOST_GID=2000
```

- `Dockerfile.dev` の下記処理を削除

```Dockerfile.dev
RUN set -eux; \
  # ホストのUID/GIDを引き渡す場合、OS上に既にUID/GIDが存在してもエラーが発生しないようにする為の削除処理
  if getent passwd "${USER_UID}" >/dev/null; then \
...
  groupdel "${oldgroup}" || true; \
  fi
```
