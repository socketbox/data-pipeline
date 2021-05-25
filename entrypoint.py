import os
import base64
import requests
import shutil
import subprocess

METADATA_URL = 'http://metadata.google.internal/computeMetadata/v1/'
METADATA_HEADERS = {'Metadata-Flavor': 'Google'}
SERVICE_ACCOUNT = 'ledp-admin@le-data-pipeline.iam.gserviceaccount.com'


# see
# https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances#applications
# for more information on this approach
def get_access_token():
    url = '{}instance/service-accounts/{}/token'.format(
        METADATA_URL, SERVICE_ACCOUNT)

    # Request an access token from the metadata server.
    r = requests.get(url, headers=METADATA_HEADERS)
    r.raise_for_status()

    # Extract the access token from the response.
    access_token = r.json()['access_token']
    return access_token


def get_secrets_list(project_id, access_token):
    url = 'https://secretmanager.googleapis.com/v1/projects/{}/secrets'.format(project_id)

    headers = {
        'Authorization': 'Bearer {}'.format(access_token)
    }

    r = requests.get(url, headers=headers)
    r.raise_for_status()
    return r.json()


def set_env_secrets(secret_json, access_token, label=None):
    """
    Sets secrets retrieved from Google Secret Manager in the runtime environment
    of the Python process
    :param secret_ids: a generator of Secrets
    :param label: NOT IMPLEMENTED #Secrets with this label will be set in the environment
    """
    headers = {
        'Authorization': 'Bearer {}'.format(access_token)
    }
    sl = secret_json['secrets']
    for s in sl:
        name = s['name']
        # we only want secrets with matching labels (or all of them if label wasn't specified)
        url = "https://secretmanager.googleapis.com/v1/{}/versions/latest:access".format(name)
        # not implemented: needs proper REST call
        if not label or label in s.labels:
            r = requests.get(url, headers=headers)
            r.raise_for_status()
            payload_base64 = r.json()['payload']['data']
            payload_bytes = base64.b64decode(payload_base64)
            os.environ[name.split('/')[-1]] = str(payload_bytes, 'UTF-8')


if __name__ == "__main__":
    project_id = os.getenv("GCP_PROJECT_ID")
    access_token = get_access_token()
    secrets = get_secrets_list(project_id, access_token)
    set_env_secrets(secrets, access_token)
    print("Running meltano...")
    subprocess.run(['meltano', 'ui'])
    #gunicorn_path = shutil.which('gunicorn')
    #gunicorn = subprocess.run([gunicorn_path, '-c', '/app/etc/gunicorn.py', 'nutritionfacts.wsgi:application'])
    #print("gunicorn terminated with code: {}".format(gunicorn.returncode))
