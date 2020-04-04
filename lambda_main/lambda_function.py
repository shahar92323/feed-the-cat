from __future__ import print_function

import boto3
import urllib
from datetime import datetime
import os

rekognition = boto3.client('rekognition')

# --------------- Helper Functions to call Rekognition APIs ------------------

def detect_labels(bucket, key):
    response = rekognition.detect_labels(Image={"S3Object": {"Bucket": bucket, "Name": key}},MinConfidence=90)
    table = boto3.resource('dynamodb').Table(os.environ['table_name'])
    now = datetime.now()
    food_timestamp = now.strftime("%d/%m/%Y-%H:%M:%S.%f")[:-3]
    proper_food = ['Milk', 'Fish', 'Bread']
    labels = [{'Confidence': ['Confidence'], 'Name': label_prediction['Name']} for label_prediction in response['Labels']]
    for food in labels:
        for value in food.values():
            if str(value) in proper_food:
                print('SUCCESS: {} is a proper food!'.format(value))
                table.put_item(Item={'PK': 'Food', 'Healthy': '0', 'Labels': value, 'Timestamp': food_timestamp})
                return response

# --------------- Main handler ------------------

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.unquote_plus(event['Records'][0]['s3']['object']['key'].encode('utf8'))
    try:
        response = detect_labels(bucket, key)
        return response
    except Exception as e:
        print(e)
        print("Error processing object {} from bucket {}. ".format(key, bucket))
        raise e

