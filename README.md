# A Serverless Web Application

## Project overview
In this project, we will work on an application for sharing recipes, where a user can create, delete, or
read their recipes. We will implement this by utilising serverless serivces provides by AWS to handle out bakend instead of managing servers to deploy our web app.

## Functional Requirements
Our application should serve two different profiles: admins and end users.
 - Platform admin: The platform owner, who may want to create a new recipe, maintain it, or even delete it.
 - End users/consumers: The end user, who uses the platform for accessing a specific recipe, and should not be able to create, change, or delete any record.

 We will start with two different pages, **/users** for the end users and **/admin** for admins, to support the two differnt personas.
 
  ![Initial Page](images/initial.png)