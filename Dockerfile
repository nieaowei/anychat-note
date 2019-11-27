FROM centos:latest

ADD leanote-linux-amd64-v2.6.1.bin.tar.gz /usr/local

WORKDIR /usr/local/leanote/bin

RUN chmod +x *.sh

EXPOSE 9000

ENTRYPOINT [ "./run.sh" ]
