variable "s3_suffix" {} # .bash_profileに環境変数定義 : TF_VAR_s3_suffix

variable "name" {
  default = "DefaultTrail"
}

variable "bucket_identifier" {
  default = "cloud-trail"
}

module "cloud_trail" {
  source = "../terraform/module/cloud_trail"

  name = "${var.name}"
  bucket_name = "${var.bucket_identifier}-${var.s3_suffix}"
}

module "bucket" {
  source = "../terraform/module/s3/log"

  identifier = "${var.bucket_identifier}"
  suffix = "${var.s3_suffix}"

  policy = "${template_file.policy_json.rendered}"
}

resource "template_file" "policy_json" {
  template = "${file("policy.json.tpl")}"
  vars {
    identifier = "${var.bucket_identifier}"
    suffix = "${var.s3_suffix}"
  }
}
