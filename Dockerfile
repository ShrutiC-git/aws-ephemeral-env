FROM node:15 as lambda

ARG PORT=8000
ENV PORT=$PORT
WORKDIR /usr/src
COPY . .
# Install zip in container
RUN apt-get update
RUN apt-get install zip
# Enter the src directory, install dependencies, and zip the src directory in the container
RUN cd src && npm install && zip -r lambdas.zip .


FROM localstack/localstack:1.4
# Copy lambdas.zip into the localstack directory
RUN chmod +x /usr/src/init-scripts
COPY --from=lambda /usr/src/init-scripts/init-aws.sh /etc/localstack/init/ready.d/init-aws.sh
COPY --from=lambda /usr/src/src/lambdas.zip ./lambdas.zip
