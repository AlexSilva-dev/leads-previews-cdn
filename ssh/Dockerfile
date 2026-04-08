FROM alpine:latest

RUN apk add --no-cache openssh-server bash

# Configure SSH
RUN ssh-keygen -A

# Create user with UID 1000
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN addgroup -g ${GROUP_ID} sshuser && \
    adduser -D -u ${USER_ID} -G sshuser -s /bin/bash sshuser && \
    echo "sshuser:password" | chpasswd

# Configure SSH daemon
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
