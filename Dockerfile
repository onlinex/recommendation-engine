# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.7-slim

EXPOSE 8000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Set the current working directory (Create if does not eixst)
WORKDIR /code
# Mount to current working directory
ENV PYTHONPATH=${PYTHONPATH}:${PWD}

# Copy requirements
COPY poetry.lock pyproject.toml /code/

# Install poetry requirements
RUN pip3 install poetry
# DO NOT create a virtual environment, we are already in a docker container
RUN poetry config virtualenvs.create false
# Install required packages minus the development packages
RUN poetry install --no-dev

# Copy the rest of the project
COPY ./app /code/app
# Copy testing code
COPY ./tests /code/tests

# TODO add --proxy-headers
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]



# Install pip requirements
#COPY requirements.txt .
#RUN python -m pip install -r requirements.txt

#WORKDIR /app
#COPY . /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
#RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
#USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "-k", "uvicorn.workers.UvicornWorker", "app\main:app"]
