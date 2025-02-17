## Question 1. Understanding docker first run 
Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint `bash`.

What's the version of `pip` in the image?

- 24.3.1
- 24.2.1
- 23.3.1
- 23.2.1

**Answer: The version of `pip` is 24.3.1**

## Question 2. Understanding Docker networking and docker-compose
Given the following `docker-compose.yaml`, what is the `hostname` and `port` that **pgadmin** should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

If there are more than one answers, select only one of them

**Answer: postgres:5432 or db:5432**

## Question 3. Trip Segmentation Count
During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles

```sql
SELECT
	CASE
		WHEN trip_distance <= 1 THEN '1: Up to 1 mile'
		WHEN trip_distance <= 3 THEN '2: 1-3 miles'
		WHEN trip_distance <= 7 THEN '3: 3-7 miles'
		WHEN trip_distance <= 10 THEN '4: 7-10 miles'
		ELSE '5: Over 10 miles'
	END AS segment,
	COUNT(*) AS n_trips
FROM public.green_tripdata_2019
WHERE
	lpep_pickup_datetime >= '2019-10-01'
	AND lpep_pickup_datetime < '2019-11-01'
	AND lpep_dropoff_datetime >= '2019-10-01'
	AND lpep_dropoff_datetime < '2019-11-01'
GROUP BY
	1
ORDER BY
	segment ASC;
```
**Answer: 104802, 198924, 109603, 27678, 35189**

## Question 4. Longest trip for each day
Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.

```sql
SELECT
	lpep_pickup_datetime::date AS day,
	MAX(trip_distance) AS longest_trip
FROM public.green_tripdata_2019
GROUP BY
	1
ORDER BY
	longest_trip DESC
LIMIT 1;
```
**Answer: 2019-10-31**

## Question 5. Three biggest pickup zones
Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

```sql
SELECT
	tz."Zone",
	SUM(total_amount) AS total_amount
FROM public.green_tripdata_2019 AS gt
LEFT JOIN taxi_zone_lookup AS tz
	ON gt."PULocationID" = tz."LocationID"
WHERE
	lpep_pickup_datetime::date = '2019-10-18'
GROUP BY
	1
HAVING SUM(total_amount) > 13000
ORDER BY
	total_amount DESC
LIMIT 3;
```
**Answer: East Harlem North, East Harlem South, Morningside Heights**

## Question 6. Largest tip
For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

```sql
SELECT
	pu_tz."Zone",
	do_tz."Zone",
	tip_amount
FROM public.green_tripdata_2019 AS gt
LEFT JOIN taxi_zone_lookup AS do_tz
	ON gt."DOLocationID" = do_tz."LocationID"
LEFT JOIN taxi_zone_lookup AS pu_tz
	ON gt."PULocationID" = pu_tz."LocationID"
WHERE
	1=1
	AND gt.lpep_pickup_datetime >= '2019-10-01'
	AND gt.lpep_pickup_datetime <= '2019-10-31'
	AND pu_tz."Zone" = 'East Harlem North'
ORDER BY
	tip_amount DESC
LIMIT 1;
```
**Answer: JFK Airport**

## Question 7. Terraform Workflow
Which of the following sequences, respectively, describes the workflow for:

1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

**Answer: terraform init, terraform apply -auto-approve, terraform destroy**