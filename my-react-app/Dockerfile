    # Stage 1: Build the React app
    FROM node:18 as builder
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build
    
    # Stage 2: Serve the app with Nginx
    FROM nginx:alpine
    # Update & install sudo and other tools
    RUN apt-get update && \
    apt-get install -y sudo passwd && \
    rm -rf /var/lib/apt/lists/*

    # Create a new user with password and sudo privileges
    RUN useradd -ms /bin/bash vivritiadmin && \
    echo "vivritiadmin:adminpass" | chpasswd && \
    usermod -aG sudo vivritiadmin && \
    echo "vivritiadmin ALL=(ALL) ALL" >> /etc/sudoers

    # Disable root login:
    # - Lock the root account
    # - Disable root shell
    RUN passwd -l root && \
    usermod -s /usr/sbin/nologin root

    COPY --from=builder /app/build /usr/share/nginx/html
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]