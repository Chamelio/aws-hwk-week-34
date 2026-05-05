locals {
  pythonQuery = "/python?name=Chewbacca"
  nodeQuery   = "/node?name=Malgus"
}

resource "aws_api_gateway_rest_api" "falcon" {
  name = "falcon"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#Node Resources
resource "aws_api_gateway_resource" "node_resource" {
  rest_api_id = aws_api_gateway_rest_api.falcon.id
  parent_id   = aws_api_gateway_rest_api.falcon.root_resource_id
  path_part   = "node"
}

resource "aws_api_gateway_method" "node_method" {
  rest_api_id   = aws_api_gateway_rest_api.falcon.id
  resource_id   = aws_api_gateway_resource.node_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "node_integration" {
  rest_api_id             = aws_api_gateway_rest_api.falcon.id
  resource_id             = aws_api_gateway_resource.node_resource.id
  http_method             = aws_api_gateway_method.node_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.chewbacca_node_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "force" {
  rest_api_id = aws_api_gateway_rest_api.falcon.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.node_resource.id,
      aws_api_gateway_method.node_method.id,
      aws_api_gateway_integration.node_integration.id,
      aws_api_gateway_resource.python_resource.id,
      aws_api_gateway_method.python_method.id,
      aws_api_gateway_integration.python_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.force.id
  rest_api_id   = aws_api_gateway_rest_api.falcon.id
  stage_name    = "prod"
}



//Python Resources
resource "aws_api_gateway_resource" "python_resource" {
  rest_api_id = aws_api_gateway_rest_api.falcon.id
  parent_id   = aws_api_gateway_rest_api.falcon.root_resource_id
  path_part   = "python"
}

resource "aws_api_gateway_method" "python_method" {
  rest_api_id   = aws_api_gateway_rest_api.falcon.id
  resource_id   = aws_api_gateway_resource.python_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "python_integration" {
  rest_api_id             = aws_api_gateway_rest_api.falcon.id
  resource_id             = aws_api_gateway_resource.python_resource.id
  http_method             = aws_api_gateway_method.python_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.chewbacca_python_lambda.invoke_arn
}