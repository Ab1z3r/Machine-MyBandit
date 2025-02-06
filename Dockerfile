# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install necessary packages
RUN apt update && apt install -y openssh-server zip coreutils john

# Configure SSH
RUN mkdir /var/run/sshd
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Copy and run setup script during build
COPY setup_ctf.sh /setup_ctf.sh
RUN chmod +x /setup_ctf.sh && \
    /setup_ctf.sh && \
    rm /setup_ctf.sh

# Expose SSH port
EXPOSE 22

# Create startup script
RUN echo '#!/bin/bash\ncat /root/initial_password.txt\n/usr/sbin/sshd -D' > /start.sh && \
    chmod +x /start.sh

# Start SSH service and show initial password
CMD ["/start.sh"]