FROM python:3.9 AS BUILDER
# Because cryptg builds some native library
# use multi-stage build reduce image size

RUN apk update && apk add --no-cache tzdata alpine-sdk ca-certificates
ADD requirements.txt /tmp/
RUN pip3 install --user -r /tmp/requirements.txt && rm /tmp/requirements.txt


FROM python:3.9
WORKDIR /app
ENV TZ=Asia/Shanghai

COPY --from=builder /root/.local /usr/local
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY . /app

ENTRYPOINT ["python", "-m", "tg_searcher"]
CMD ["-f", "./config/searcher.yaml"]
