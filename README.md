#  Real World App

Implementation of real world application: https://github.com/gothinkster/realworld/ using Django and Unpoly.

## Installation:

To install and run locally:

- Clone the project:

  ```bash
  git clone https://github.com/alnuaimi94/realworld
  ```

- Change directory & Create virtualenv called **env**:
  ```bash
  cd realworld
  ```
  ```bash
  python3 -m venv env
  ```

- Activate virtualenv:
  - for Windows System:
    ```bash
      env/Scripts/activate
    ```
  - for Linux System:
    ```bash
      source ./env/bin/activate
    ```

- Install dependencies:
  ```bash
  pip install -r requirements/local.txt
  ```

- Change DJANGO_SETTINGS_MODULE from *production* to *local* in [manage.py](./manage.py), [asgi.py](./realworld/config/asgi.py) and [wsgi.py](./realworld/config/wsgi.py) files.
  ```python
  os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'realworld.config.settings.local')
  ```

- Migrate & Runserver:
  ```bash
  python manage.py migrate
  ```
  ```bash
  python manage.py runserver
  ```

- Finally open the localhost in the browser:
  ```bash
    http://127.0.0.1:8000/
  ```


build your image:
----------------
gcloud builds submit --pack image=gcr.io/${PROJECT_ID}/realworld

gcloud builds submit --pack image=gcr.io/summer-monument-359312/realworld

run the django mirgration
------------------------
gcloud builds submit --config migrate.yaml


Note: if you chose a region other than "us-central1", specify that value in your command:


gcloud builds submit --config migrate.yaml \
  --substitutions _REGION=us-central1


deploy to cloud run
------------------

gcloud run deploy django-cloudrun \
  --platform managed \
  --region $REGION \
  --image gcr.io/${PROJECT_ID}/myimage \
  --set-cloudsql-instances ${PROJECT_ID}:${REGION}:myinstance \
  --set-secrets APPLICATION_SETTINGS=application_settings:latest \
  --service-account $SERVICE_ACCOUNT \
  --allow-unauthenticated


  gcloud run deploy django-cloudrun \
  --platform managed \
  --region us-central1 \
  --image gcr.io/summer-monument-359312/realworld \
  --set-cloudsql-instances summer-monument-359312:us-central1:realw-app \
  --set-secrets APPLICATION_SETTINGS=application_settings:latest \
  --service-account tf-gcp-compute-svcaccount@summer-monument-359312.iam.gserviceaccount.com \
  --allow-unauthenticated



  pushing code to gcloud repo

  git remote add google ssh://nitishinvestor0863@gmail.com@source.developers.google.com:2022/p/summer-monument-359312/r/vullinitish


  git push --all google