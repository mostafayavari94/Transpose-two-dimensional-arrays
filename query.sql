 CREATE TABLE public.matrices (
	matrix _text NOT NULL
);

INSERT INTO public.matrices (matrix) VALUES
	 ('{"[1, 2, 3]","[4, 5, 6]"}'),
	 ('{"[a, b, c]","[d, e, f]"}');
   
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
