import json
import boto3    

def lambda_handler(event, context):
    counterMap = {
        "Aatrox":["Elise", "Akali"],
        "Akali":["Morgana", "Blitz"]
    }

    s3 = boto3.resource('s3')
    s3object = s3.Object('lambdabucketforfuckssake', 'counters.json')

    s3object.put(
        Body=(bytes(json.dumps(counterMap).encode('UTF-8')))
    )

    return counterMap