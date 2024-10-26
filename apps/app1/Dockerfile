# Dockerfile for app1
FROM python:3.9-slim
# install curl in container as we need to run curl from script.sh
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/* 
#adding non root user to run app.py
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
WORKDIR /app
COPY app.py .
RUN pip install --no-cache-dir Flask
USER appuser
CMD ["python", "app.py"]
