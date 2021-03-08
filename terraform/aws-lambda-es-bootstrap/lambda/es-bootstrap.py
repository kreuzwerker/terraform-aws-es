import boto3
import os
import requests
from requests_aws4auth import AWS4Auth

ES_ENDPOINT = os.environ['ES_ENDPOINT']
ES_REGION = os.environ['ES_REGION']
S3_REPO_BUCKET = os.environ['S3_REPO_BUCKET']
REPO_NAME = os.environ['REPO_NAME']
SNAPSHOT_NAME = os.environ['SNAPSHOT_NAME']
ROLE_ARN = os.environ['ROLE_ARN']

REQUEST_HEADERS = {"Content-Type": "application/json"}
base_url = f"{ES_ENDPOINT}/_snapshot/{REPO_NAME}"

# Fetch credentials
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(
    credentials.access_key,
    credentials.secret_key,
    ES_REGION,
    'es',
    session_token=credentials.token)


def _restore_snapshot():
    if _is_repo_missing():
        register_repo = _register_repo()
        if register_repo.status_code >= 400:
            return register_repo

    restore_url = f"{base_url}/{SNAPSHOT_NAME}/_restore"
    restore_resp = requests.post(restore_url, auth=awsauth, headers=REQUEST_HEADERS)
    if restore_resp.status_code == 200:
        print(f"Snapshot %{SNAPSHOT_NAME} restored.")

    return restore_resp


def _is_repo_missing():
    resp = requests.get(base_url, auth=awsauth)
    is404 = resp.status_code == 404
    isRepoMissing = "repository_missing_exception" in resp.text
    return (is404 or isRepoMissing)


def _register_repo():
    payload = {
        "type": "s3",
        "settings": {
            "bucket": S3_REPO_BUCKET,
            "role_arn": ROLE_ARN
        }
    }
    resp = requests.put(base_url, auth=awsauth, json=payload, headers=REQUEST_HEADERS)
    return resp


def lambda_handler(event, context):
    r = _restore_snapshot()
    response = {}
    response['statusCode'] = r.status_code
    response['body'] = r.text

    return response
