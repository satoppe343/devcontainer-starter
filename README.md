# devcontainer-starter

## はじめに

VSCode で Dev Container による開発環境を構築する際にすぐに使用できるテンプレートを作成しました<br>
毎回Docker関連のファイル修正などで時間が取られる為、主に自分用にシンプルな雛形を用意しました<br>

- 環境を構築する時にトラブルになりやすいユーザー情報(UID/GID)について、ホスト OS から引き継いだ値で Dev Container 用ユーザー情報を作成するようにしてファイル権限を変更しなくて良いようにした
- zshとOh My Zsh!をインストールしてコマンド補完・各種コマンドのサジェストなどが効くようにした
- 実際に使用する時に必要となる各種ライブラリインストール・初期設定用シェルの雛形や、ワークスペースにフォルダを追加する事を考慮
- 日本語の等幅フォント（[HackGen v2.10.0](https://github.com/yuru7/HackGen/releases/tag/v2.10.0)）をインストール（font設定のサンプルとして不要なら削除

## 使用方法

### 1. 前提条件

下記環境で作成/動作確認しています

- Mac
- Colima
- Visual Studio Code
- VSCode Dev Containers 拡張機能 or Remote Development
- Zsh
  (Windows/WSL2 での動作確認はしていませんが Windows 環境でも Docker 実行及び WSL2 が設定されていれば動作すると思います)

### 2.セットアップ手順

リポジトリのクローン

```mac
mkdir ${proj}
cd ${proj}
git clone https://github.com/satoppe343/devcontainer-starter.git .
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

### 4. カスタマイズに関して

- Dev Container ワークスペースにフォルダを追加したい場合、`/docker-compose.dev.yml
` に追加したいディレクトリをVolumeマウントする記述をして `devcontainer-starter.code-workspace`にVolumeマウントされたパスを追加してください

```docker-compose.dev.yml
    volumes:
    ...
      - ${ホストOSディレクトリ}:{Devcontainerディレクトリ}

```

```devcontainer-starter.code-workspace
    {
      "path": {Devcontainerディレクトリ}
    }
```

- 日本語の等幅フォント設定について
  下記バージョンを使用しています

  [HackGen v2.10.0](https://github.com/yuru7/HackGen/releases/tag/v2.10.0)

日本語フォントが不要な場合は下記の部分をコメントアウトしてください

.devcontainer/Dockerfile.de

```:.devcontainer/Dockerfile.dev
# フォントファイルをコピーして展開
RUN sudo mkdir -p /usr/local/share/fonts
RUN sudo wget -O /usr/local/share/fonts/HackGen_v2.10.0.zip https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_v2.10.0.zip \
  && sudo unzip /usr/local/share/fonts/HackGen_v2.10.0.zip -d /usr/local/share/fonts/ \
  && sudo rm /usr/local/share/fonts/HackGen_v2.10.0.zip

# フォントキャッシュを更新
RUN fc-cache -f -v
```

.devcontainer/devcontainer.json

```:.devcontainer/devcontainer.json
        // フォント指定
        "editor.fontFamily": "HackGen, Consolas, 'Courier New', monospace",
```

- Dockerイメージの肥大化や頻繁な更新を避けるため、プログラムやライブラリのインストールや初期設定処理はなるべく `
Dockerfile.dev` に記述せず、`postCreate.sh` に記述する事をおススメします

### 5. ユーザー情報(UID/GID)設定について

Devcontainer 実行ユーザーのユーザー情報(UID/GID)をホスト OS から引き継がないで新規 ID を振るように変更したい場合は下記設定を変更してください
ただしその場合、ファイル権限の設定変更など別途検討して対応する必要があります（そういった検討を避ける為に現在の仕様で環境作成するようにしています）

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
