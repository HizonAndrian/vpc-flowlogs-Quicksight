SELECT
  date(from_unixtime(start)) AS log_date,
  srcaddr,
  COUNT(*) AS rejected_requests
FROM "vpc_flowlogs_db"."glue_catalog_table"
WHERE action = 'REJECT'
GROUP BY date(from_unixtime(start)), srcaddr
ORDER BY log_date;

SELECT
  date(from_unixtime(start)) AS log_date,
  srcaddr,
  COUNT(*) AS accepted_request
FROM "vpc_flowlogs_db"."glue_catalog_table"
WHERE action = 'ACCEPT'
GROUP BY date(from_unixtime(start)), srcaddr
ORDER BY log_date;
