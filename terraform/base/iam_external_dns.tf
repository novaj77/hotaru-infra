data "aws_iam_policy_document" "external_dns" {
  statement {
    sid    = "ManageHotaruRecords"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResources",
    ]
    resources = [data.aws_route53_zone.main.arn]
  }

  statement {
    sid       = "ListHostedZones"
    effect    = "Allow"
    actions   = ["route53:ListHostedZones"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "external_dns" {
  name        = "hotaru-external-dns"
  description = "Allows external-dns to manage records in the hotaru hosted zone"
  policy      = data.aws_iam_policy_document.external_dns.json
}
