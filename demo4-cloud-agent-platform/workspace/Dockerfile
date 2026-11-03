FROM python:3.11-slim

# Install system dependencies and curl
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Install Database MCP Toolbox binary
ENV TOOLBOX_VERSION="0.4.0"
RUN curl -fsSL -o /usr/local/bin/toolbox "https://storage.googleapis.com/genai-toolbox/v${TOOLBOX_VERSION}/toolbox-linux-amd64" \
    && chmod +x /usr/local/bin/toolbox

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy agent application and MCP tools configuration
COPY tools.yaml .
COPY app/ app/

# Environment configuration for Gemini Enterprise Agent Platform
ENV PORT="8080"
ENV GOOGLE_CLOUD_LOCATION="global"
ENV PYTHONUNBUFFERED="1"

CMD ["python", "-m", "app.agent"]
