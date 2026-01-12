# Analyzing AWS VPC Flow Logs with Athena and QuickSight


# Overview
  This project demonstrates an end-to-end VPC Flow Logs analysis pipeline on AWS using serverless services for data processing, querying, and visualization. The developer used Terraform (with OIDC authentication and CLI Driven) to provision and manage all resources, ensuring reproducibility and security The system automatically collects VPC Flow Logs, processes them with AWS Glue, queries them using Athena, and visualizes insights in QuickSight.


# 📐 Architecture
 1. Data Source
    - **VPC Flow Logs** are delivered to Amazon S3 every 10 minutes.
    - Logs are stored in partitioned folders by year/month/day.

 2. Data Processing
    - **AWS Glue Crawler** detects new logs and update the data catalog one a day.

 3. Querying
    - **Amazon Athena** queries the logs directly from S3 using the Data Catalog schema.
    - Views are created in Athena for custom filtering and analysis.

 4. Visualization
    - **Amazon Quicksight** dashboard display metrics like:
      - Top rejected connections.
      - Accepted vs. rejected traffic trends.
      - Source and destination IP analysis.


# Key Features
✅ Fully Infrastructure as Code — Provisioned entirely using Terraform. <br>
✅ OIDC Authentication — GitHub Actions to Terraform Cloud without storing long-lived AWS keys. <br>
✅ Serverless & Scalable — Uses AWS Glue, Athena, and QuickSight. <br>
✅ Partitioned Data — Optimized Athena queries via partition pruning. <br>
✅ Daily Automated Crawling — Glue CRON ensures yesterday’s data is always in the catalog. <br>
✅ Custom Athena Views — Easy filtering for dashboards.


# 🚀 Tech Stack
   - Terraform (CLI-driven via GitHub) 
   - AWS OIDC Authentication (No static credentials) 
   - Amazon S3 
   - Amazon Athena 
   - AWS Glue (Crawler & Data Catalog) 
   - Amazon QuickSight
   - AWS CloudWatch Logs (VPC Flow Logs source)
   - Github
   - Terraform Cloud


# Flow Diagram
   VPC Flow Logs 
      → Amazon S3 
         → AWS Glue Crawler 
            → AWS Data Catalog 
               → Athena (Views) 
                  → QuickSight Dashboard



# Implementation Steps
   1. Enable VPC Flow Logs to S3.
   2. Set Up Glue Crawler to detect new logs and create partitions.
   3. Query logs with Athena using the Data Catalog Table
   4. Create Athena Views for custom querires
   5. Connect Quicksight to Athena results.
   6. Build interactive dashboard.



# Key Queries
   - Reject Traffic Analysis

      CREATE VIEW vpc_reject_traffic AS <br>
      SELECT srcaddr, dstaddr, COUNT(*) AS reject_count, SUM(bytes) AS total_reject_bytes <br>
      FROM "vpc_flowlogs_db"."flowlogs_ap_southeast_1" <br>
      WHERE action = 'REJECT' <br>
      GROUP BY srcaddr, dstaddr <br>
      ORDER BY reject_count DESC; 

   - Accept Traffic Volume

      CREATE VIEW vpc_accept_traffic AS <br>
      SELECT srcaddr, SUM(bytes) AS total_bytes, COUNT(*) AS connection_attempts <br>
      FROM "vpc_flowlogs_db"."flowlogs_ap_southeast_1" <br>
      WHERE action = 'ACCEPT' <br>
      GROUP BY srcaddr <br>
      ORDER BY total_bytes DESC;


### Recommended Enhancements
- Add date-based partitions to organize VPC Flow Logs, improve query performance, and reduce Athena query costs.
- Add partitions to the Glue table to improve query performance and reduce Athena query costs.


# Query results in Quicksight
[ Accepted traffics ](./images/Quicksight_accepted_traffics.png) <br>
[ Rejected traffic ](./images/Quicksight_rejected_traffics.png) <br>
[ Compiled traffic base on athena query ](./images/Quicksight_custom_query.png)


# 👤 Author
 **Mark Andrian Hizon** — DevOps/Cloud Enthusiast <br>
[ 🔗 LinkedIn Profile ](https://www.linkedin.com/in/mark-andrian-hizon-9a215722a/) <br>
[ 🏅 Credly Profile   ](https://www.credly.com/users/mark-andrian-hizon.9ae74f49)