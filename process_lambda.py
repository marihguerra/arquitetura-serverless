import boto3
import json
from datetime import datetime
dynamodb = boto3.resource('dynamodb')
table_name = 'orders_table'
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    for record in event.get('Records', []):
        try:
            message_body = json.loads(record['body'])
            product_name = message_body.get('productName')
            quantity = message_body.get('quantity')

            if not product_name or not quantity:
                print(f"Dados incompletos: {message_body}")
                continue

            item = {
                'orderId': record['messageId'],
                'productName': product_name,
                'quantity': quantity,
                'orderDate': datetime.now().isoformat()
            }

            table.put_item(Item=item)

        except Exception as e:
            print(f"Erro ao processar registro: {e}")
            continue

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Orders processed successfully'
        })
    }

