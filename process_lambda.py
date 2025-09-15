import boto3, json
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('orders-table')

def handler(event, context):
    for record in event['Records']:
        body = json.loads(record['body'])
        table.put_item(Item={"id": body["id"], "data": body["data"]})
    return {"status": "stored"}
