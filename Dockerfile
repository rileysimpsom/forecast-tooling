# 1. BASE IMAGE
# We use an official Airflow image based on Python 3.10
# This matches the Python version from the original Astro Runtime (3.0-5)
FROM apache/airflow:2.9.2-python3.10

# Set the AIRFLOW_USER_HOME (good practice)
ENV AIRFLOW_HOME=/opt/airflow

# 2. SYSTEM PACKAGES
# Switch to root user to install packages
USER 0
# Install system packages needed for ML libraries (from your original Dockerfile)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 3. PYTHON PACKAGES
# Copy your main requirements.txt file
COPY requirements.txt /requirements.txt

# Install providers Airflow needs, then install all your project's packages
RUN pip install --no-cache-dir \
    "apache-airflow-providers-common-sql" \
    "apache-airflow-providers-postgres" \
    "apache-airflow-providers-sqlite" \
    "apache-airflow-providers-aws" \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.9.2/constraints-3.10.txt" \
    && pip install --no-cache-dir -r /requirements.txt

# 4. COPY PROJECT
# Copy the rest of your project files into the container
COPY . /opt/airflow

# 5. FINAL SETUP
# Switch back to the non-privileged airflow user
USER airflow
WORKDIR /opt/airflow
