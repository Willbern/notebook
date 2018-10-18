FROM centos:latest

RUN yum install -y net-tools telnet iproute bind-utils

EXPOSE 8000

CMD python -m SimpleHTTPServer 8000
