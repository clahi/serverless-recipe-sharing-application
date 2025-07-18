# S3
S3 is a fully managed AWS storage service which can also be used to host single page web pages.

## Access
By default, public access is denied. We have created an s3 access policy which allows acces only from CloudFront.

### Module
This module expects that the calling root module to provide the bucket name and the environment it will deploy to.