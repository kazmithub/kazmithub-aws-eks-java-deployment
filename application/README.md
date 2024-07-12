# Containerized "Hello World" Java Deployment with Docker

This guide provides instructions for deploying a simple "Hello World" REST API Java application using Spring Boot and Maven. The application is containerized using Docker, making it easy to build and deploy.

## How to Build

To package the application and build the Docker image, run the following commands:

```sh
mvn package
docker build -t hello-world-java-docker .
```

## How to Run
```sh
docker run -it hello-world-java-docker
```
## Blog Post

For more details, check out the blog post [here](https://edwin.baculsoft.com/2020/07/building-containerized-images-on-openshift-4-and-push-the-result-to-third-party-image-registry/).
