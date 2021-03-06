package builder

import (
	"time"

	svc "github.com/aws/aws-sdk-go/service/ec2"

	"../ami"
	. "../constant"
	"../ec2"
	. "../role"
	"../tag"
)

type AmiBuilder struct {
	Ec2Service *svc.EC2
}

func (ab AmiBuilder) SearchParent(role Role) string {
	if role == BASE {
		return BASE_IMAGE_ID
	}

	ami := ami.Ami{Ec2Api: *ab.Ec2Service}
	return *ami.GetImageId(role.Parent().ToTag())
}

func (ab AmiBuilder) Build(instanceId ec2.InstanceId, role Role, parentAmiId string) {
	// EC2インスタンスを停止
	ec2.Ec2Instance{Ec2Api: *ab.Ec2Service}.Stop(instanceId)

	// 現時刻の取得
	currentTime := time.Now()

	// AMIの作成
	amiParam := ami.AmiParam{
		InstanceId:  instanceId.String(),
		Name:        role.ToTag(),
		CurrentTime: currentTime,
	}
	ami := ami.Ami{Ec2Api: *ab.Ec2Service}
	imageId := ami.Create(amiParam)

	// タグの設定の準備
	snapshotId := ami.GetSnapshotId(*imageId)
	tagClient := tag.Tag{Ec2Api: *ab.Ec2Service}

	// AMIのタグの設定
	amiTagParam := tag.AmiTagParam{
		AmiId:       *imageId,
		Role:        role.ToTag(),
		CurrentTime: currentTime,
		ParentAmiId: parentAmiId,
	}
	tagClient.CreateAmiTag(amiTagParam)

	// スナップショットのタグの設定
	snapshotTagParam := tag.SnapshotTagParam{
		SnapshotId:  *snapshotId,
		AmiTagParam: amiTagParam,
	}
	tagClient.CreateSnapshotTag(snapshotTagParam)
}
