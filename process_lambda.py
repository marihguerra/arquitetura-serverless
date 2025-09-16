import boto3
import json
from datetime import datetime
dynamodb = boto3.resource('dynamodb')
table_name = 'orders_table'
table = dynamodb.Table(table_name)

def handler(event, context):
    for record in event['Records']:
        message_body = json.loads(record['body'])
        item = {'orderId': record['messageId'], 'productName': message_body['productName'],
                'quantity': message_body['quantity'], 'orderDate': datetime.now().isoformat()}
        table.put_item(Item=item)
    return {'statusCode': 200, 'body': json.dumps({'message': 'Orders processed successfully'})}
