FROM nginx:alpine

RUN mkdir -p /etc/nginx/ssl
RUN apk add openssl
RUN openssl ecparam -genkey -name prime256v1 -out /etc/nginx/ssl/key.pem
RUN openssl req -new -x509 -subj "/" -key /etc/nginx/ssl/key.pem -out /etc/nginx/ssl/crt.pem

FROM nginx:alpine

COPY --from=0 /etc/nginx/ssl /etc/nginx/ssl
