# Docker Usage Guide

## Multipurpose MLC-LLM Docker Image

The Docker image `ghcr.io/EmaLinuxawy/mlc-llm` serves multiple purposes and is automatically built and published via our CI/CD pipeline.

## Image Overview

### Single-Stage Architecture

- **Ubuntu 22.04 Base**: Modern system dependencies and Python 3.11
- **Development Tools**: Full toolchain with debugging and editing capabilities
- **Prebuilt Packages**: MLC-AI nightly packages for immediate use
- **Flexible Entrypoint**: Supports multiple usage modes

### Security Features

- Runs as non-root user `developer`
- Minimal attack surface
- Regular security updates through automated builds

## Usage Modes

### 1. Development Environment

```bash
# Interactive development shell
docker run -it --rm ghcr.io/EmaLinuxawy/mlc-llm dev

# Mount your source code for development
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/EmaLinuxawy/mlc-llm dev

# With GPU support (if available)
docker run -it --rm --gpus all \
  -v $(pwd):/workspace \
  ghcr.io/EmaLinuxawy/mlc-llm dev
```

**Features:**

- Full development toolchain
- Git, editors, debugging tools
- Python development environment
- Source code mounting support

### 2. CLI Mode (Default)

```bash
# Run MLC-LLM CLI commands
docker run --rm ghcr.io/EmaLinuxawy/mlc-llm --help

# Use the CLI directly
docker run --rm \
  -v $(pwd)/models:/models \
  ghcr.io/EmaLinuxawy/mlc-llm chat --model /models/model-name

# Generate model artifacts
docker run --rm \
  -v $(pwd)/models:/models \
  -v $(pwd)/output:/output \
  ghcr.io/EmaLinuxawy/mlc-llm gen-config --model /models/input --output /output
```

### 3. Build Mode

```bash
# Build models or packages from source
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/EmaLinuxawy/mlc-llm build --target model

# Compile with custom configurations
docker run --rm \
  -v $(pwd):/workspace \
  -e CMAKE_BUILD_TYPE=Release \
  ghcr.io/EmaLinuxawy/mlc-llm build --config custom
```

### 4. Test Mode

```bash
# Run MLC-LLM tests
docker run --rm \
  -v $(pwd):/workspace \
  ghcr.io/EmaLinuxawy/mlc-llm test

# Test with mounted source code
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/EmaLinuxawy/mlc-llm test
```

### 5. Custom Commands

```bash
# Run any Python command
docker run --rm ghcr.io/EmaLinuxawy/mlc-llm \
  python -c "import mlc_llm; print('MLC-LLM imported successfully')"

# Execute shell commands
docker run --rm ghcr.io/EmaLinuxawy/mlc-llm \
  /bin/bash -c "ls -la /workspace"

# Start interactive shell
docker run -it --rm ghcr.io/EmaLinuxawy/mlc-llm shell

# Run Jupyter notebook server
docker run -p 8888:8888 \
  -v $(pwd):/workspace \
  ghcr.io/EmaLinuxawy/mlc-llm \
  jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

## Image Tags and Versioning

### Available Tags

- `latest` - Latest stable build from main branch
- `main` - Latest build from main branch
- `v1.0.0` - Specific version tags
- `sha-abc123` - Specific commit builds

### Tag Strategy

```bash
# Production use
docker pull ghcr.io/EmaLinuxawy/mlc-llm:latest

# Specific version
docker pull ghcr.io/EmaLinuxawy/mlc-llm:v1.0.0

# Specific commit (for debugging)
docker pull ghcr.io/EmaLinuxawy/mlc-llm:sha-abc123
```

## Volume Mounts and Data Persistence

### Recommended Mount Points

```bash
# Model storage
-v $(pwd)/models:/models

# Workspace for development
-v $(pwd):/workspace

# Output directory
-v $(pwd)/output:/output

# Configuration files
-v $(pwd)/config:/config

# Cache directory (for performance)
-v mlc-cache:/home/developer/.cache
```

### Complete Development Setup

```bash
docker run -it --rm \
  --name mlc-dev \
  -v $(pwd):/workspace \
  -v $(pwd)/models:/models \
  -v $(pwd)/output:/output \
  -v mlc-cache:/home/developer/.cache \
  -p 8888:8888 \
  -p 8000:8000 \
  ghcr.io/EmaLinuxawy/mlc-llm dev
```

## Environment Variables

### Available Variables

```bash
# Model configuration
MLC_MODEL_PATH=/models/model-name
MLC_DEVICE=cpu|cuda|vulkan|metal
MLC_NUM_THREADS=4

# Environment paths (set in image)
MLC_HOME=/workspace/mlc-llm
PYTHONPATH=/workspace/mlc-llm:${PYTHONPATH}

# Python configuration
PYTHONUNBUFFERED=1
PYTHONDONTWRITEBYTECODE=1

# Build configuration
CMAKE_BUILD_TYPE=Release|Debug
USE_CUDA=ON|OFF
USE_VULKAN=ON|OFF

# Server configuration
MLC_SERVER_PORT=8000
MLC_SERVER_HOST=0.0.0.0
```

### Example with Environment

```bash
docker run -d \
  --name mlc-production \
  -p 8888:8888 \
  -e MLC_MODEL_PATH=/models/llama-2-7b \
  -e MLC_DEVICE=cpu \
  -e MLC_NUM_THREADS=8 \
  -v $(pwd)/models:/models \
  ghcr.io/EmaLinuxawy/mlc-llm dev
```

## CI/CD Integration

The Docker image is automatically built and published through our CI/CD pipeline:

### Automated Publishing

- **Trigger**: Push to main branch, version tags
- **Registry**: GitHub Container Registry (GHCR)
- **Authentication**: GitHub token with package write permissions
- **Build Context**: Full repository with submodules

### Build Features

- **Dependency Caching**: Pre-installed packages for faster startups
- **Development Tools**: Git, editors, debugging utilities
- **Python Environment**: Virtual environment with all dependencies
- **Flexible Entrypoint**: Multiple operational modes (dev, test, build, shell)

See [CI/CD Architecture](cicd-architecture.md) for detailed pipeline information.
