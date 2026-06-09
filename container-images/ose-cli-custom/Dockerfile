# Use the official OpenShift CLI image as the base
FROM registry.redhat.io/openshift4/ose-cli:latest

# Switch to root to perform installations
USER root

# Install jq
RUN yum install -y jq 

# Install AWS CLI dependencies and the AWS CLI itself
RUN yum install -y unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Clean Yum cache
RUN yum clean all && \
    rm -rf /var/cache/yum

# Switch back to a non-privileged user (though the CronJob will run as root via SCC)
USER 1001

ENTRYPOINT ["/usr/bin/oc"]
