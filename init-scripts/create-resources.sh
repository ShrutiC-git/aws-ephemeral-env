
echo "All resources initialized! 🚀"


# echo "Create SQS queue testQueue"
# aws \
#   sqs create-queue \
#   --queue-name testQueue \
#   --endpoint-url http://localhost:4566 
# echo "Create SNS Topic testTopic"
# aws \
#   sns create-topic \
#   --name testTopic \
#   --endpoint-url http://localhost:4566 
# echo "Subscribe testQueue to testTopic"
# aws \
#   sns subscribe \
#   --endpoint-url http://localhost:4566 \
#   --topic-arn arn:aws:sns:us-east-1:000000000000:testTopic \
#   --protocol sqs \
#   --notification-endpoint arn:aws:sqs:us-east-1:000000000000:testQueue
# echo "Create admin"
# aws \
#  --endpoint-url=http://localhost:4566 \
#  iam create-role \
#  --role-name admin-role \
#  --path / \
#  --assume-role-policy-document file:./admin-policy.json
# echo "Make S3 bucket"
# awslocal s3api create-bucket --bucket business-time-nonprod --region eu-west-1 


# echo "Copy the lambda function to the S3 bucket"
# aws \
#   s3 cp lambdas.zip s3://lambda-functions \
#   --endpoint-url http://localhost:4566 

# echo "Create the lambda exampleLambda"
# aws \
#   lambda create-function \
#   --endpoint-url=http://localhost:4566 \
#   --function-name exampleLambda \
#   --role arn:aws:iam::000000000000:role/admin-role \
#   --code S3Bucket=lambda-functions,S3Key=lambdas.zip
#   --handler index.handler \
#   --runtime nodejs10.x \
#   --description "SQS Lambda handler for test sqs." \
#   --timeout 60 \
#   --memory-size 128 
# echo "Map the testQueue to the lambda function"
# aws \
#   lambda create-event-source-mapping \
#   --function-name exampleLambda \
#   --batch-size 1 \
#   --event-source-arn "arn:aws:sqs:us-east-1:000000000000:testQueue" \
#   --endpoint-url=http://localhost:4566

# echo "Invike Lambda"
# aws \
#   lambda invoke -function-name exampleLambda --cli-binary-format raw-in-base64-out --payload '{ "key": "value" }' response.json