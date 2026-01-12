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

ENTRYPOINT ["./generate_with_timeout.sh"]
