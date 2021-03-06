# AWSアカウント取得後にやること

## 事前準備

1. 最低限のAWSアカウントの初期設定
 * http://qiita.com/tmknom/items/303db2d1d928db720888
2. AWS CLIを使用できるようにする
 * 管理コンソールでユーザ作成＆アクセスキー払い出し
 * AWS CLIのインストール＆セットアップ
3. 環境変数を定義
 * [direnvの導入](/document/design/direnv/README.md)


## terraformの準備

### ログ格納用のS3バケット定義

```bash
$ cd orchestration/s3/s3_log
$ terraform get; terraform apply
```

### terraform用のS3バケット定義

```bash
$ cd orchestration/s3/terraform
$ terraform get; terraform apply
```

### tfstateファイルをS3に保存

```bash
$ cd orchestration/
$ fab terraform_plan:s3/s3_log
$ fab terraform_plan:s3/terraform
```


## S3 のバケット作成

### CloudTrail用のS3バケット定義

```bash
$ fab build_s3_cloud_trail
```

### デプロイ用のS3バケット定義

```bash
$ fab build_s3_deployment
```

### 一時保存用のS3バケット定義

```bash
$ fab build_s3_temporary
```


## CloudTrailの有効化

```bash
$ fab build_cloud_trail
```


## IAMユーザ作成

### CLI用ユーザ

ユーザ作成後、管理コンソールからアクセスキーを払い出す。

```bash
$ fab build_user_cli
```

払い出したアクセスキーを設定する。

```bash
$ cp -p ~/.aws/credentials ~/.aws/credentials.bak
$ vi ~/.aws/credentials
```

AWS CLIが使えることを確認し、問題なければ、バックアップファイルを削除。

```bash
$ aws ec2 describe-vpcs
$ rm ~/.aws/credentials.bak
```

動作確認後、最初に手動で作成したユーザは削除する。
すぐに削除しない場合も、アクセスキーは無効にしておくこと。


### AWS外部用システムユーザ

ユーザ作成後、管理コンソールからアクセスキーを払い出す。

CircleCIの管理画面から、払い出したアクセスキーを設定する。

```bash
$ fab build_user_external
```


## InstanceProfileの作成

```bash
$ fab build_instance_profile
```


## VPCの作成

```bash
$ fab build_vpc
```


## セキュリティグループの作成

```bash
$ fab build_security_group
```


## RDSの作成

### インスタンス構築

```bash
$ fab build_rds
```

### パスワード変更

```bash
$ fab rds_production_password_change -f ../operation/fabfile.py
$ fab rds_administration_password_change -f ../operation/fabfile.py
```


## EC2の作成

```bash
$ fab build_ec2_production
```


## CodeDeployの作成

コマンド実行後、デプロイを手動で実行し、GitHubの認証を通しておく。

```bash
$ fab build_code_deploy
```


## KMSの作成

### マスターキーの作成

```
$ aws kms create-key
```

### マスターキーの設定

環境変数「ENCRYPTION_DATA_MASTER_KEY_ID」にキーIDをセットしてから実行。

```bash
$ fab build_kms_encryption_data
```
