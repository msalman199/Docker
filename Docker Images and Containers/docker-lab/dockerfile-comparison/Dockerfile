FROM ubuntu:20.04

# Update and install packages
RUN apt update && apt install -y curl wget vim htop

# Create custom files
RUN echo "This is a custom file" > /custom-file.txt
RUN mkdir /custom-directory
RUN echo "Configuration data" > /custom-directory/config.txt

# Create custom script
RUN cat > /usr/local/bin/hello.sh << 'SCRIPT'
#!/bin/bash
echo "Hello from modified container!"
echo "Current time: $(date)"
echo "Hostname: $(hostname)"
SCRIPT

RUN chmod +x /usr/local/bin/hello.sh

# Set default command
CMD ["/bin/bash"]
