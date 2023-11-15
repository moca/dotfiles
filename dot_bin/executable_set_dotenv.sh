
TOKEN=$(aws secretsmanager get-secret-value --secret-id /hf/token | jq --raw-output '.SecretString' | jq -r .HF_TOKEN)
echo "HF_TOKEN=${TOKEN}" >> ~/.env
