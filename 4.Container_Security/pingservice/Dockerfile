FROM golang:latest

WORKDIR /root

RUN apt update && apt install curl wget iputils-ping -y

COPY views /root/views
COPY go.mod /root/go.mod
COPY go.sum /root/go.sum
COPY main.go /root/main.go

RUN go build -o /root/

EXPOSE 80

CMD ["/root/health-check"]
