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

make build 

## TODO

説明を追加する
