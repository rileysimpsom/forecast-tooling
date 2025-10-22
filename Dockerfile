# Use the official Apache Airflow image for Airflow 2.9.2 and Python 3.10
FROM apache/airflow:2.9.2-python3.10

# Set the AIRFLOW_USER_HOME (good practice)
ENV AIRFLOW_HOME=/opt/airflow

# Switch to root user (USER 0) to install system dependencies
USER 0

# Install the system dependencies from your original Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements before anything else for better layer caching
COPY requirements.txt /requirements.txt

# Install all Python packages from requirements.txt
# Add "apache-airflow-providers-*" because the base image
# doesn't include all providers like astro-runtime does.
RUN pip install --no-cache-dir \
    "apache-airflow-providers-common-sql" \
    "apache-airflow-providers-postgres" \
    "apache-airflow-providers-sqlite" \
    "apache-airflow-providers-aws" \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.9.2/constraints-3.10.txt" \
    && pip install --no-cache-dir -r /requirements.txt

# Copy your packages.txt if you have one (optional)
# COPY packages.txt /packages.txt
# RUN apt-get update && xargs -a /packages.txt apt-get install -y && apt-get clean

# Copy the rest of your project files
COPY . /opt/airflow

# Switch back to the non-privileged airflow user
USER airflow

# Set the working directory
WORKDIR /opt/airflow