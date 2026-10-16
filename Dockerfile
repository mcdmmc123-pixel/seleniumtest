
FROM maven:3.9.6-eclipse-temurin-17

WORKDIR /app

# Install Chrome and its required dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    fonts-liberation \
    libglib2.0-0 \
    libnss3 \
    libfontconfig1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
       | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/google-chrome

# Copy the Maven project
COPY pom.xml .
COPY src ./src
COPY testng.xml ./

# Download dependencies during image build
RUN mvn dependency:go-offline -B

# Run Selenium tests when the container starts
CMD ["mvn", "test"]
