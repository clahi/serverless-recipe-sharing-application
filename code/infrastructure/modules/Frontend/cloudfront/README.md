# AWS CloudFront
Amazon CloudFront is a content delivery network (CDN) service provided by Amazon Web Services (AWS). It speeds up the delivery of static and dynamic web content to users worldwide by caching content at edge locations, which are geographically dispersed data centers. This reduces latency and improves the performance of websites, APIs, and other web assets. 

In this project we are using CloudFront to distribute our web page hosted on S3

The root module using this module should provide the S3 bucket name to act as the origin.