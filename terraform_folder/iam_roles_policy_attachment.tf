resource "aws_iam_role_policy_attachment" "lambda-upload-cloudwatch-attach" {
  role       = aws_iam_role.lambda-exec-upload.name
  policy_arn = aws_iam_policy.lambda-upload-cloudwatch-policy.arn
}


resource "aws_iam_role_policy_attachment" "lambda-get-cloudwatch-attach" {
  role       = aws_iam_role.lambda-exec-get.name
  policy_arn = aws_iam_policy.lambda-get-cloudwatch-policy.arn
}


resource "aws_iam_role_policy_attachment" "s3_policy_edit_attachment" {
  role       = aws_iam_role.s3_policy_edit_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attachment_get" {
  policy_arn = data.aws_iam_policy.lambda_basic_execution.arn
  role       = aws_iam_role.lambda-exec-get.name
}

resource "aws_iam_role_policy_attachment" "s3_full_access_attachment_get" {
  policy_arn = data.aws_iam_policy.s3_full_access.arn
  role       = aws_iam_role.lambda-exec-get.name
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attachment" {
  policy_arn = data.aws_iam_policy.lambda_basic_execution.arn
  role       = aws_iam_role.lambda-exec-upload.name
}


resource "aws_iam_role_policy_attachment" "s3_full_access_attachment" {
  policy_arn = data.aws_iam_policy.s3_full_access.arn
  role       = aws_iam_role.lambda-exec-upload.name
}

resource "aws_iam_role_policy_attachment" "api_gateway_invoke_full_access_attachment" {
  policy_arn = data.aws_iam_policy.api_gateway_invoke_full_access.arn
  role       = aws_iam_role.lambda-exec-upload.name
}


resource "aws_iam_role_policy_attachment" "cognito-auth-lambdaFullAccess" {
  role       = aws_iam_role.cognito_authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "cognito-unauth-lambdaFullAccess" {
  role       = aws_iam_role.cognito_unauthenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "cognito-auth-pollyFullAccess" {
  role       = aws_iam_role.cognito_authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyFullAccess"
}

resource "aws_iam_role_policy_attachment" "cognito-unauth-pollyFullAccess" {
  role       = aws_iam_role.cognito_unauthenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyFullAccess"
}
resource "aws_iam_role_policy_attachment" "dynamodb-full-access-get-lambda" {
  policy_arn = aws_iam_policy.lambda-dynamodb-policy.arn
  role       = aws_iam_role.lambda-exec-get.name
}


resource "aws_iam_role_policy_attachment" "dynamodb-full-access-upload-lambda" {
  policy_arn = aws_iam_policy.lambda-dynamodb-policy.arn
  role       = aws_iam_role.lambda-exec-upload.name
}

