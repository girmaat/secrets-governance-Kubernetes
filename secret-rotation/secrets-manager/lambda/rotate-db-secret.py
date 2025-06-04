import boto3, json, string, random, logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

secretsmanager = boto3.client('secretsmanager')

def handler(event, context):
    token = event['ClientRequestToken']
    secret_arn = event['SecretId']
    step = event['Step']

    logger.info(f"Rotating {secret_arn} at step {step}")

    if step == "createSecret":
        create_secret(secret_arn, token)
    elif step == "setSecret":
        logger.info("Set step placeholder")
    elif step == "testSecret":
        logger.info("Test step placeholder")
    elif step == "finishSecret":
        finish_secret(secret_arn, token)

def create_secret(secret_arn, token):
    new_pw = ''.join(random.choices(string.ascii_letters + string.digits, k=16))
    current = json.loads(secretsmanager.get_secret_value(SecretId=secret_arn)['SecretString'])

    new_secret = json.dumps({
        "username": current["username"],
        "password": new_pw
    })

    secretsmanager.put_secret_value(
        SecretId=secret_arn,
        ClientRequestToken=token,
        SecretString=new_secret,
        VersionStages=["AWSPENDING"]
    )

def finish_secret(secret_arn, token):
    metadata = secretsmanager.describe_secret(SecretId=secret_arn)
    if token not in metadata["VersionIdsToStages"]:
        raise ValueError("Token not found")

    secretsmanager.update_secret_version_stage(
        SecretId=secret_arn,
        VersionStage="AWSCURRENT",
        MoveToVersionId=token
    )
