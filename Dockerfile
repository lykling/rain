FROM bash:5.1.4 AS builder

WORKDIR /build/rainloop/
RUN wget -c https://github.com/RainLoop/rainloop-webmail/releases/download/v1.15.0/rainloop-community-1.15.0.zip -P /tmp/
RUN unzip -d . /tmp/rainloop-community-1.15.0.zip

FROM nginx:1.17.8-alpine
COPY --from=builder /build/rainloop /var/www/html
RUN find /var/www/html -type d -exec chmod 755 {} \;
RUN find /var/www/html -type f -exec chmod 644 {} \;
WORKDIR /rainloop
COPY run.sh .
COPY .env.default .
COPY conf/nginx.conf.template .

EXPOSE 80

CMD ["sh", "/rainloop/run.sh", "launch"]
