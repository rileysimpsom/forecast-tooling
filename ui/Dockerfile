# Use the *same* Python version as Airflow (3.10) for consistency
FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements from the ROOT folder (one level up)
# This ensures both Airflow and Streamlit use the *exact same* package versions
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set non-sensitive environment variables
ENV PYTHONUNBUFFERED=1
ENV STREAMLIT_SERVER_PORT=8501
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0

# (All MLflow/AWS ENV vars are now injected by docker-compose)

# Expose Streamlit port
EXPOSE 8501

# Health check
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health || exit 1

# Run Streamlit
# Note: The 'inference_app.py' is the correct entrypoint
CMD ["streamlit", "run", "inference_app.py", "--server.address", "0.0.0.0", "--server.port", "8501", "--server.headless", "true"]