# Deterministic Flutter test runner image
# Pin the base image to a specific Flutter release for reproducible CI behavior.
FROM ghcr.io/cirruslabs/flutter:3.24.5

WORKDIR /app

# Cache dependencies first (better build performance in CI)
COPY pubspec.yaml ./
COPY analysis_options.yaml ./
RUN flutter pub get

# Copy project sources
COPY lib ./lib
COPY test ./test

# Default command runs tests
CMD ["flutter", "test", "--reporter", "expanded"]
