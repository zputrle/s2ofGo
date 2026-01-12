FROM golang:1.25

RUN useradd -ms /bin/bash guser
USER guser

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

USER root
RUN chown -R guser:guser /app
USER guser

ENV GIT_AUTHOR_EMAIL='contact@zputrle.com'
ENV GIT_AUTHOR_NAME='zputrle auto-commit'
ENV GIT_COMMITTER_EMAIL='contact@zputrle.com'
ENV GIT_COMMITTER_NAME='zputrle auto-commit'

ENTRYPOINT ["./generate_with_timeout.sh"]
