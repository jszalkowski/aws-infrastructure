package ami

import (
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type Ami struct {
	Ec2Api ec2.EC2
}

type AmiParam struct {
	InstanceId  string
	Name        string
	CurrentTime time.Time
}

func (ami Ami) GetImageId(role string) *string {
	input := ami.createDescribeImagesInputByRoleTag(role)
	resp, _ := ami.describeImages(input)
	return resp.Images[0].ImageId
}

func (ami Ami) Create(amiParam AmiParam) *string {
	fmt.Println("Creating the AMI: " + amiParam.InstanceId)

	input := ami.createImageInput(amiParam)
	resp, err := ami.createImage(input)
	if err != nil {
		fmt.Println(err.Error())
	}
	imageId := resp.ImageId

	fmt.Println("Waiting for AMI to become available...")
	waitInput := ami.createDescribeImagesInputByImageId(*imageId)
	ami.waitUntilImageAvailable(waitInput)

	return imageId
}

func (ami Ami) createImage(input *ec2.CreateImageInput) (*ec2.CreateImageOutput, error) {
	return ami.Ec2Api.CreateImage(input)
}

func (ami Ami) createImageInput(param AmiParam) *ec2.CreateImageInput {
	return &ec2.CreateImageInput{
		InstanceId: aws.String(param.InstanceId),
		Name:       aws.String(param.Name + "-" + param.CurrentTime.Format("20060102-150405")),
	}
}

func (ami Ami) GetSnapshotId(imageId string) *string {
	input := ami.createDescribeImagesInputByImageId(imageId)
	resp, _ := ami.describeImages(input)
	return resp.Images[0].BlockDeviceMappings[0].Ebs.SnapshotId
}

func (ami Ami) describeImages(input *ec2.DescribeImagesInput) (*ec2.DescribeImagesOutput, error) {
	return ami.Ec2Api.DescribeImages(input)
}

func (ami Ami) createDescribeImagesInputByImageId(imageId string) *ec2.DescribeImagesInput {
	return &ec2.DescribeImagesInput{
		ImageIds: []*string{
			aws.String(imageId),
		},
	}
}

func (ami Ami) createDescribeImagesInputByRoleTag(role string) *ec2.DescribeImagesInput {
	return &ec2.DescribeImagesInput{
		Filters: []*ec2.Filter{
			{
				Name: aws.String("tag:Role"),
				Values: []*string{
					aws.String(role),
				},
			},
		},
	}
}

func (ami Ami) waitUntilImageAvailable(input *ec2.DescribeImagesInput) {
	ami.Ec2Api.WaitUntilImageAvailable(input)
}
