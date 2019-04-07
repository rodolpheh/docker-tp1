FROM alpine:latest

LABEL maintainers="Rodolphe HOUDAS <rodolphe.houdas@isen.yncrea.fr>"

COPY Dockerfile /etc/docker-image-metadata

EXPOSE 80

ENTRYPOINT [ "tail", "-f", "/var/log/nginx/access.log" ]

