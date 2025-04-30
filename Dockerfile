    # Stage 1: Build the React app
    FROM node:18 as builder
    WORKDIR /app
    COPY my-react-app/package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build
    
    # Stage 2: Serve the app with Nginx
    FROM nginx:alpine
    COPY --from=builder /app/build /usr/share/nginx/html
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]