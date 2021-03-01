from golang:alpine

RUN apk --update add wget grep bash httpie supervisor git coreutils && rm -rf /var/cache/apk/* \
    && mkdir -p /asset/data
COPY bin /asset/bin
COPY http /http
COPY daily /asset/
COPY searchresult /asset/data/searchresult
WORKDIR /http
RUN mkdir -p go-tools && go mod init go-tools && go mod tidy && go build -o server . \
    && cat /asset/daily >> /var/spool/cron/crontabs/root
COPY supervisord.conf /etc/supervisord.conf
CMD supervisord -c /etc/supervisord.conf
