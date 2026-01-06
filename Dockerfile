FROM python:3.11-slim

RUN pip install --no-cache-dir emhass==0.15.2 uvicorn

COPY run.sh /run.sh

EXPOSE 5000

CMD ["bash", "/run.sh"]
