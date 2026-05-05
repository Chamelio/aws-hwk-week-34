output "python_sample_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/python?name=Python_Chewbacca"
}

output "node_sample_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/node?name=Node_Chewbacca"
}

output "api_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}