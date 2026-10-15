# hotaru-infra

hotaruのAWSをTerraformで作るリポジトリ

## 構成

- bootstrap：stateを置くS3
- base：常設のリソース（ドメイン・証明書・ECR・VPC・CIのロールなど）
- cluster：一時的なリソース（EKS・ノード）。消しても、baseには影響しない

## 使用技術

- Terraform：stateはS3に置き、ロックもS3でかける。stack同士はremote stateを使わず、名前で参照する
- VPC：publicサブネットだけ（NAT Gatewayを置かない）
- EKS：ノードはsystem用（オンデマンド1台）と、spot（0〜2台、cluster-autoscalerが増減）
- EKSアドオン：vpc-cni・kube-proxy・coredns・Pod Identity Agent
- Pod Identity：アドオンのPodにAWSのロールを渡す
- access entry：クラスタを触れる人を決める（管理者、デプロイのCI、クラスタを起動・停止するCI）
- GitHub ActionsのOIDC：CIが、長期キーなしでAWSに入る
- Route 53・ACM・ECR：独自ドメイン、HTTPSの証明書、イメージ置き場
