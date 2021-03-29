FROM nginx:1.17.8-alpine
WORKDIR /rainloop
RUN wget -c https://github.com/RainLoop/rainloop-webmail/releases/download/v1.15.0/rainloop-community-1.15.0.zip -P ./
RUN mkdir -pv rainloop
RUN unzip -d rainloop ./rainloop-community-1.15.0.zip
COPY run.sh .
COPY .env.default .
COPY conf/nginx.conf.template .

EXPOSE 80

CMD ["sh", "/rainloop/run.sh", "launch"]
