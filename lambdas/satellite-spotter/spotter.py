# https://www.n2yo.com/api/#above
# Request: /above/{observer_lat}/{observer_lng}/{observer_alt}/{search_radius}/{category_id}

import requests
import json
import boto3


def get_api_key():
    ssm = boto3.client("ssm")
    response = ssm.get_parameter(Name="/satellite-spotter/api-key", WithDecryption=True)
    return response["Parameter"]["Value"]


def above(lat, long, elevation):
    key = get_api_key()
    url = f"https://api.n2yo.com/rest/v1/satellite/above/{lat}/{long}/{elevation}/5/0&apiKey={key}"
    response = requests.get(url)
    data = response.json()
    return data


def lambda_handler(event, context):

    # TODO: These values should come from the event
    lat = 53.21667
    long = -1.01667
    elevation = 47

    try:
        data = above(lat, long, elevation)
        return {"statusCode": 200, "body": json.dumps(data)}
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
