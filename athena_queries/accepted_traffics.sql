CREATE VIEW vpc_reject_traffic AS
SELECT srcaddr, dstaddr, COUNT(*) AS reject_count, SUM(bytes) AS total_reject_bytes
FROM "vpc_flowlogs_db"."glue_catalog_table"
WHERE action = 'REJECT'
GROUP BY srcaddr, dstaddr
ORDER BY reject_count DESC;