## Prepare requirements

1- Install docker
<br>
<br>
2- Pull PostgreSQL
```docker
docker pull postgres
```
<br>
<br>
3- Run PostgreSQL by docker
```docker
docker run -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```
<br>
<br>
4- Connect to Postgres by using below information

- Host: localhost
- Port: 5432
- Database: postgres
- Username: postgres
- Password: mysecretpassword 
<br>
<br>
5- Run below query to create table and insert data

```sql
CREATE TABLE public.matrices (
	matrix _text NOT NULL
);

INSERT INTO public.matrices (matrix) VALUES
	 ('{"[1, 2, 3]","[4, 5, 6]"}'),
	 ('{"[a, b, c]","[d, e, f]"}');
```
<br>
<br>

## Solution

```sql
 SELECT array_agg(v ORDER BY j) matrix  FROM (
    SELECT rn, j, array_agg(v ORDER BY i) AS v FROM (
        SELECT rn, i, j, matrix[i][j] AS v FROM (
            SELECT generate_subscripts(matrix, 2) j, converted_table_with_first_index.* FROM (
                SELECT ROW_NUMBER() OVER () AS rn, generate_subscripts(matrix, 1) AS i, matrix FROM (
                    SELECT array[STRING_TO_ARRAY(substr(matrix[1], 2, length(matrix[1]) - 2), ','), STRING_TO_ARRAY(substr(matrix[2], 2, length(matrix[1]) - 2), ',')] as matrix  FROM matrices
                    ) converted_table
            ) converted_table_with_first_index
        ) converted_table_with_second_index
    ) table_with_pairs
     GROUP BY rn, j
) final_table
 GROUP BY rn
 ORDER BY rn;
```
