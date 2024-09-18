FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    bsdutils wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/H74N/netcat-binaries/raw/master/nc -O /usr/local/bin/nc

RUN chmod +x /usr/local/bin/nc

RUN useradd -m user

# Remove unwanted commands
RUN rm -f /bin/grep /bin/find /usr/bin/find /bin/sudo /usr/bin/sudo

# Create a directory for allowed commands
RUN mkdir /allowed_commands && \
    cp /bin/bash /allowed_commands/ && \
    cp /usr/bin/groups /allowed_commands/ && \
    cp /usr/bin/dircolors /allowed_commands/ && \
    cp /usr/bin/script /allowed_commands/ && \
    cp /bin/ls /allowed_commands/ && \
    cp /bin/cat /allowed_commands/ && \
    cp /usr/local/bin/nc /allowed_commands/

RUN mkdir -p /home/user/list_command_can_find_a_lot_of_inform && \
    chown user:user /home/user/list_command_can_find_a_lot_of_inform && \
    chmod 755 /home/user/list_command_can_find_a_lot_of_inform

COPY setup.sh /setup.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /setup.sh

# Switch to non-root user
USER user
WORKDIR /home/user

# Set PATH to only include allowed commands
ENV PATH="/allowed_commands"

EXPOSE 9001

CMD ["/entrypoint.sh"]
