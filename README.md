---
title: golang gin Azure Container Apps sample project
---

## 概要

1. golang + gin
2. docker
3. test
4. coverage
5. GitHub container registry
6. vscode devcontainer
7. deploy to azure container apps

## 5. GitHub container registry

GitHubの自分のアカウントのPackagesを使うには下記の設定をする

1. PATを作成する。[Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
2. .envrc.local.template を .envrc.local にコピーし、GitHubユーザー名と作成したPATを入れる

VSCodeのdevcontainerで開いて、Makefileがあるディレクトリでターミナルを開く。設定ができていれば、下記コマンドで、イメージがビルドされてpushされる。

```sh
make gh-login build push
```

## 7. deploy to azure container apps

自分の環境に合わせて、下記の２つを設定する。

```sh
export RESOURCE_GROUP=<your resource group name>
export CR_USER=<your github account name>
```

`make setup` では、下記の内容を行っている。ここでは、container appsは作らず、別途デプロイする。

- az cliへの containerapp extensionのインストール
- github container repo(ghcr.io)へのログイン
- container apps で使うAzure リソースの作成

```sh
make setup
```

`container apps` の作成。初回は、`containerapps` リソースを作る。リソースには、docker imageが必要なので、ビルド、プッシュして、リソース作成の順で実行する。

```sh
make build app-create
```

更新、コードを修正したら、新しいイメージをプッシュして、`containerapps` リソースを更新する。

```sh
make build app-update
```

## TODO

説明を追加する
