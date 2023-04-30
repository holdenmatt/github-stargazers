# github-stargazers

Aggregate github star counts from GH Archive (via BigQuery) and publish as Parquet.

## Download data

You can download the latest Parquet file from:

```
https://raw.githubusercontent.com/holdenmatt/github-stargazers/main/data/github-repos.parquet
```

## Run locally

First, install dependencies:

```
$ python -m venv venv
$ source venv/bin/activate
$ python -m pip install --upgrade pip
$ pip install -r src/requirements.txt
```

Then create a BigQuery service account:

1.  Sign in with a [Google Account](https://support.google.com/accounts/answer/27441?hl=en).
2.  Go to the [BigQuery Console](https://console.cloud.google.com/bigquery). If you have multiple Google accounts, make sure you’re using the correct one.
3.  Create a new [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project).
4.  Create a new Service Account, and download the key as JSON (e.g. follow
    [these instructions](https://docs.getdbt.com/docs/quickstarts/dbt-cloud/bigquery#generate-bigquery-credentials)). For roles, add:

        - BigQuery Job User
        - BigQuery Read Session User

Create a `.env` file in the root of this repo, and add these variables,
copying values from your JSON file:

```
GOOGLE_PROJECT_ID=<project_id>
GOOGLE_CLIENT_EMAIL=<user>@<host>.iam.gserviceaccount.com
GOOGLE_PRIVATE_KEY=<private key>
```

Run the script to generate a new Parquet file:

```
python src/main.py
```
