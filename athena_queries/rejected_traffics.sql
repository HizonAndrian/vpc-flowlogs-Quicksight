CREATE VIEW vpc_accepted_traffic AS
SELECT srcaddr, SUM(bytes) AS total_bytes, COUNT(*) AS connection_attempts
FROM "vpc_flowlogs_db"."glue_catalog_table"
WHERE action = 'ACCEPT'
GROUP BY srcaddr
ORDER BY total_bytes DESC;