docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="123456" \
    -e POSTGRES_DB="ny_taxi" \
    -v dtc_postgres_volume_local:/var/lib/postgresql/data \
    -p 5434:5432 \
    --network=pg-network \
    --name pg-database \
    postgres:latest


docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8084:80 \
    --network=pg-network \
    --name pgadmin \
    dpage/pgadmin4

# homework
docker build -t taxi_ingest:v001 -f ingestion_py.dockerfile .

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"

docker run -it \
    --network=homework_pg-network \
    --name green_trip_ingest \
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pgdatabase \
        --port=5432 \
        --db=ny_taxi \
        --tb=green_tripdata_2019 \
        --url=${URL}

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"

docker run -it \
    --network=homework_pg-network \
    --name taxi_zone_lookup \
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pgdatabase \
        --port=5432 \
        --db=ny_taxi \
        --tb=taxi_zone_lookup \
        --url=${URL}

