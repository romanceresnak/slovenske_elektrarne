resource "aws_opensearch_domain" "qa_opensearch" {
  domain_name           = "qa-documents"
  engine_version = "OpenSearch_1.0"

  cluster_config {
    instance_type = "t3.small.search"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }

  node_to_node_encryption {
    enabled = true
  }
}

output "opensearch_endpoint" {
  value = aws_opensearch_domain.qa_opensearch.endpoint
}
