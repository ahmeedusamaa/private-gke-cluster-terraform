FROM python:3.9

RUN pip install --upgrade pip

COPY . .

RUN pip install -r requirements.txt

ENV ENVIRONMENT=DEV
ENV HOST=localhost
ENV PORT=8000
ENV REDIS_PORT=6379
ENV REDIS_DB=0

CMD [ "python", "hello.py" ]