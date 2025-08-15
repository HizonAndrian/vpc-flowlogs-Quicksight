# Analyzing AWS VPC Flow Logs with Athena and QuickSight


# Overview
  This project demonstrates an end-to-end VPC Flow Logs analysis pipeline on AWS using serverless services for data processing, querying, and visualization. The developer used Terraform (with OIDC authentication and CLI Driven) to provision and manage all resources, ensuring reproducibility and security The system automatically collects VPC Flow Logs, processes them with AWS Glue, queries them using Athena, and visualizes insights in QuickSight.


# Architecture
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
✅ Fully Infrastructure as Code — Provisioned entirely using Terraform.
✅ OIDC Authentication — GitHub Actions to Terraform Cloud without storing long-lived AWS keys.
✅ Serverless & Scalable — Uses AWS Glue, Athena, and QuickSight.
✅ Partitioned Data — Optimized Athena queries via partition pruning.
✅ Daily Automated Crawling — Glue CRON ensures yesterday’s data is always in the catalog.
✅ Custom Athena Views — Easy filtering for dashboards.


# Tech Stack
   Terraform (VCS-driven via GitHub)
   AWS OIDC Authentication (No static credentials)
   Amazon S3
   Amazon Athena
   AWS Glue (Crawler & Data Catalog)
   Amazon QuickSight
   AWS CloudWatch Logs (VPC Flow Logs source)


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
 SHOW A FEW ATHENA SQL EXAMPLES YOU USED FOR ANALYSIS



# RESULTS
 SHOW FINAL QUICKSIGHT DASHBOARD SCREENSHOTS


# Lesson Learned


