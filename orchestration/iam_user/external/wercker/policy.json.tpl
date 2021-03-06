{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${identifier}-${suffix}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": [
        "arn:aws:codedeploy:${region}:${aws_account_id}:application:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": [
        "arn:aws:codedeploy:${region}:${aws_account_id}:deploymentgroup:*/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": [
        "arn:aws:codedeploy:${region}:${aws_account_id}:deploymentconfig:CodeDeployDefault.OneAtATime",
        "arn:aws:codedeploy:${region}:${aws_account_id}:deploymentconfig:CodeDeployDefault.HalfAtATime",
        "arn:aws:codedeploy:${region}:${aws_account_id}:deploymentconfig:CodeDeployDefault.AllAtOnce"
      ]
    }
  ]
}
