# ------------------- Stage 1: Build Stage ------------------------------
FROM python:3.9 AS builder

# Set working directory for build stage
WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ------------------- Stage 2: Final Stage ------------------------------
FROM python:3.9-slim

# Set working directory for the final stage
WORKDIR /app

# Install runtime dependencies only
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libmariadb3 && \
    rm -rf /var/lib/apt/lists/*

# Copy Python dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the application code
COPY . .

# Expose the port Flask will run on
EXPOSE 5000

# Set the default command to run the application
CMD ["python", "app.py"]

