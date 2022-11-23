FROM nginx:alpine
# Copy source code to working directory
COPY index.html /usr/share/nginx/html

RUN rm /usr/share/nginx/html/index.html
