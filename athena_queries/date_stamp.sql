SELECT
  date(from_unixtime(start)) AS log_date,
  COUNT(*) AS rejected_requests
FROM "vpc_flowlogs_db"."glue_catalog_table"
WHERE action = 'REJECT'
GROUP BY date(from_unixtime(start))
ORDER BY log_date;
