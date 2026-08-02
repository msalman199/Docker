# Use Python slim image as base
FROM python:3.9-slim

# Set metadata
LABEL maintainer="student@example.com"
LABEL description="Custom web application for Docker lab"
LABEL version="1.0"

# Set working directory
WORKDIR /app

# Copy application files
COPY index.html .
COPY app.py .

# Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8080

# Set environment variables
ENV PORT=8080
ENV PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"

# Run the application
CMD ["python3", "app.py"]
