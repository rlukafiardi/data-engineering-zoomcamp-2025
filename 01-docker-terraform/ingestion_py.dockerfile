FROM python:3.11.11

WORKDIR /app

COPY ingestion_ny_taxi.py ingestion_ny_taxi.py

RUN pip install pandas sqlalchemy psycopg2-binary pyarrow

ENTRYPOINT ["python", "ingestion_ny_taxi.py"]