from __future__ import print_function
import boto3
import json
from datetime import datetime
from datetime import timedelta
from dateutil import parser
import os


def lambda_handler(event, context):

    # email configuration
    data = 'body'
    sender = os.environ['email_sender']
    alarm_subject = 'Alarm: Cat is hungry'
    recovery_subject = "Recovery: Cat isn't hungry anymore"
    recipient = os.environ['email_recipient']
    _message = ':)'

    # dynamodb configuration
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.environ['table_name'])

    # initial monitor table
    monitor_item = table.get_item(
        Key={
            'PK': 'Monitor'
        }
    )
    try:
        monitor_item_status = monitor_item['Item']['PK']
    except:
        table.put_item(Item={'PK': 'Monitor', 'Healthy': '1'})

    # alarm
    response = table.get_item(
        Key={
            'PK': 'Food'
        }
    )

    last_update = response['Item']['Timestamp']
    food_health_status = response['Item']['Healthy']
    item_label = response['Item']['Labels']
    monitor_health_status = monitor_item['Item']['Healthy']
    diff_time = datetime.now() - timedelta(minutes=15)
    update_time = parser.parse(last_update)
    if diff_time > update_time and monitor_health_status == '1' and food_health_status == '0':
        print('INFO: sending alarm, cat is hungry')
        table.put_item(Item={'PK': 'Monitor', 'Healthy': '1-Email'})
        table.put_item(Item={'PK': 'Food', 'Healthy': '1', 'Labels': item_label, 'Timestamp': last_update})
        client = boto3.client('ses')
        response = client.send_email(
            Destination={
                'ToAddresses': [recipient]
            },
            Message={
                'Body': {
                    'Text': {
                        'Charset': 'UTF-8',
                        'Data': _message,
                    },
                },
                'Subject': {
                    'Charset': 'UTF-8',
                    'Data': alarm_subject,
                },
            },
            Source=sender,
        )
    elif diff_time > update_time and monitor_health_status == '1-Email' and food_health_status == '1':
        print('INFO: alarm already sent, nothing to do')
    elif diff_time < update_time and monitor_health_status == '1-Email' and food_health_status == '0':
        print("INFO: recovery, cat isn't hungry anymore")
        client = boto3.client('ses')
        response = client.send_email(
            Destination={
                'ToAddresses': [recipient]
            },
            Message={
                'Body': {
                    'Text': {
                        'Charset': 'UTF-8',
                        'Data': _message,
                    },
                },
                'Subject': {
                    'Charset': 'UTF-8',
                    'Data': recovery_subject,
                },
            },
            Source=sender,
        )
        table.put_item(Item={'PK': 'Monitor', 'Healthy': '1'})
    else:
        print("INFO: Cat isn't hungry, nothing to do")
