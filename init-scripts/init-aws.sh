#!/bin/sh

API_NAME=api
REGION=us-east-1
STAGE=test

awslocal lambda create-function \
    --function-name ${API_NAME} \
    --runtime nodejs16.x \
    --handler index.handler \
    --zip-file fileb://lambdas.zip \
    --role arn:aws:iam::000000000000:role/lambda-role

LAMBDA_ARN=$(awslocal lambda list-functions --query "Functions[?FunctionName==\`${API_NAME}\`].FunctionArn" --output text --region ${REGION})

awslocal apigateway create-rest-api \
    --region ${REGION} \
    --name ${API_NAME}


API_ID=$(awslocal apigateway get-rest-apis --query "items[?name==\`${API_NAME}\`].id" --output text --region ${REGION})
PARENT_RESOURCE_ID=$(awslocal apigateway get-resources --rest-api-id ${API_ID} --query 'items[?path==`/`].id' --output text --region ${REGION})

awslocal apigateway create-resource \
    --region ${REGION} \
    --rest-api-id ${API_ID} \
    --parent-id ${PARENT_RESOURCE_ID} \
    --path-part "{somethingId}"


RESOURCE_ID=$(awslocal apigateway get-resources --rest-api-id ${API_ID} --query 'items[?path==`/{somethingId}`].id' --output text --region ${REGION})

awslocal apigateway put-method \
    --region ${REGION} \
    --rest-api-id ${API_ID} \
    --resource-id ${RESOURCE_ID} \
    --http-method POST \
    --request-parameters "method.request.path.somethingId=true" \
    --authorization-type "NONE" \


awslocal apigateway put-integration \
    --region ${REGION} \
    --rest-api-id ${API_ID} \
    --resource-id ${RESOURCE_ID} \
    --http-method POST \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:${REGION}:lambda:path/2015-03-31/functions/${LAMBDA_ARN}/invocations \
    --passthrough-behavior WHEN_NO_MATCH \


awslocal apigateway create-deployment \
    --region ${REGION} \
    --rest-api-id ${API_ID} \
    --stage-name ${STAGE}