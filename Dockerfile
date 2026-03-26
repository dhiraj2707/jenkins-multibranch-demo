FROM ubuntu:latest

WORKDIR /app
COPY app.sh .

RUN apt update && apt install -y bash
RUN chmod +x app.sh

CMD ["bash", "app.sh"]
