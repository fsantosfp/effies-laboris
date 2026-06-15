# Estágio 1: Build do React
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Recebe as chaves via build args (injetadas pelo CI/CD via GitHub Secrets)
ARG VITE_API_URL
ARG VITE_GOOGLE_MAPS_API_KEY
ENV VITE_API_URL=$VITE_API_URL
ENV VITE_GOOGLE_MAPS_API_KEY=$VITE_GOOGLE_MAPS_API_KEY
RUN npm run build

# Estágio 2: Servir os arquivos estáticos com Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]