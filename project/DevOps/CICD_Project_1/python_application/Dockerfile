FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY flask_app_sample.py app.py

EXPOSE 5000

CMD ["python", "app.py"]
