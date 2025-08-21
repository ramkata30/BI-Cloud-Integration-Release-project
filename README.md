#                                                 BI Cloud Integration & Release Management

# Agenda:
For the deployment of SQL scripts to AWS Redshift, you need to build a GitHub Actions workflow that enables engineers to trigger SQL execution by specifying: 
- A Git branch 
- A SQL file name (or folder of SQL files) 
- Optional execution order if multiple files exist.
