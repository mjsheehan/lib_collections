UPDATE q1
SET monthly_value = q2_unpivoted.monthly_value
FROM (
    SELECT 
        database, fy, metric_type, 
        UNNEST(ARRAY['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar']) AS month,
        UNNEST(ARRAY[july, aug, sep, oct, nov, dec, jan, feb, mar]) AS monthly_value
    FROM q2
) AS q2_unpivoted
WHERE q1.database = q2_unpivoted.database
AND q1.fy = q2_unpivoted.fy
AND q1.metric_type = q2_unpivoted.metric_type
AND q1.month = q2_unpivoted.month
AND q1.monthly_value IS NULL;
