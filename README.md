Fargate CI/CD サンプル
====

## Description
CodePipelineを利用して CodeCommit → CodeBuild → CodeDeploy の流れでFargateのタスク定義を更新するサンプル

## Install
### Preparation
#### MicroScannerのトークン取得
```
docker run --rm -it aquasec/microscanner --register <email address>
```
コマンド実行後登録したメールアドレスにトークンが飛んでくる
#### 設定変更
cfn/_variable.shを自分のインストールしたい環境の設定に合わせて編集する

### Create Resource (CFn)
```
$ cd /PATH/TO/THIS
$ sh ./cfn/_deploy.sh
```
専用のVPCとリソース、コンフィグファイルを作るため、少し時間がかかるがんびり待つ  

### Create Resource (手作業）
2019/02/01 時点では[CFnのCodeDeploy](https://docs.aws.amazon.com/codedeploy/latest/APIReference/API_CreateApplication.html#CodeDeploy-CreateApplication-request-computePlatform)がECSをサポートしていないのでUIを使って作成
```
The destination platform type for the deployment (Lambda or Server).
```
以下のURLを自分の環境に置き換えてアクセスし、クラスターのサービス画面を表示する
```
https://ap-northeast-1.console.aws.amazon.com/ecs/home?region={$AWS_DEFAULT_REGION}#/clusters/{$NAME}-{$STAGE}/services
---
{$AWS_DEFAULT_REGION} : cfn/_variable.shのAWS_DEFAULT_REGIONに設定した値
{$NAME} : cfn/_variable.shのNAMEに設定した値
{$STAGE} : cfn/_variable.shのSTAGEに設定した値
```
#### 手順
1. Createボタンを押下
1. Configure serviceで以下の項目を設定（記載していない項目は初期値でOK）
	- Launch type : Fargate
	- Task Definition Family : {$NAME}-{$STAGE}-task
	- Task Definition Revision : xx (latest)
	- Cluster : {$NAME}-{$STAGE}
	- Service name : service
	- Number of tasks : 1
1. Deploymentsで以下の項目を設定（記載していない項目は初期値でOK）
	- Deployment type : Blue/green deployment (powered by AWS CodeDeploy)
	- Service role for CodeDeploy : {$NAME}-{$STAGE}-deploy
1. Next stepボタンを押下
1. Configure networkで以下の項目を設定（記載していない項目は初期値でOK）
	- Cluster VPC : {$NAME}-{$STAGE}-vpc
	- Subnets : {$NAME}-{$STAGE}-public-1、{$NAME}-{$STAGE}-public-2
	- Security groups : {$NAME}-{$STAGE}-service-sg
1. Load balancingで以下の項目を設定（記載していない項目は初期値でOK）
	- Load balancer type : Application Load Balancer
	- Load balancer name : {$NAME}-{$STAGE}
1. Container to load balance
	- Container name:port : web:80:80
	- Add to load balancerを押下
1. web : 80で以下の項目を設定（記載していない項目は初期値でOK）
	- Production listener port : 80:HTTP
	- Test listener port : create new、8080
1. Additional configurationで以下の項目を設定（記載していない項目は初期値でOK）
	- Target group 1 name : {$NAME}-{$STAGE}-service-1
	- Target group 2 name : create new、{$NAME}-{$STAGE}-service-2 
1. Service discovery (optional)で以下の項目を設定（記載していない項目は初期値でOK）
	- Enable service discovery integration : check off
1. Next stepボタンを押下
1. Next stepボタンを押下
1. Create Serviceボタンを押下

以上の手順を踏み、Launch Status で ECS Service status - 4 of 4 completed と表示されれば作成終了

## Usage
### サンプルコードをCodeCommitにプッシュ
```
$ cd /PATH/TO/THIS
$ git remote add origin ssh://git-codecommit.{$AWS_DEFAULT_REGION}.amazonaws.com/v1/repos/{$NAME}-{$STAGE}
$ git add .
$ git commit -m "first commit"
$ git push origin master
```
これでmasterへのコードの変更を起点としてCodePipeline({$NAME}-{$STAGE}-pipeline)が動き出す  
CodeDeployで処理中で止まったままになるがこれはBlue/Greenのトラフィックを切り替えてから旧タスクを削除するまでがCodeDeployの職責なので作った状態であれば、旧タスクの削除まで1時間時間がかかる  
この辺りはアプリケーションの設定で変更が可能

## Uninstall
```
$ cd /PATH/TO/THIS
$ sh ./cfn/_remove.sh
```  

## Limitations
- FargateへのAutoScaling設定や、R53の設定は行なっていない
- taskdef.jsonはCodeBuildで動的に生成し、BuildArtifactに含めるとCodeDeployでInternalErrorになるのでcfn/_deploy.shで作成している
- Blue/Green時のトラフィックのトラフィックの再ルーティングまでの時間の設定を変更したい場合はアプリケーションのデプロイ設定を変更して行う

## Versioning
バージョンはv1.2.3という形でtagを付けることにより管理する  
v: 接頭辞として固定  
1: メジャバージョン  
2: マイナバージョン  
3: ビルドバージョン  
masterに 修正が加えられる毎にビルドバージョンを増加  
後方互換性がない修正が入る場合にはマイナバージョンを増加させて、ビルドバージョンは0にリセットする  

## Contribution
- Fork it
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create new Pull Request
