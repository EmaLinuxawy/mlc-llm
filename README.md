# MLC-LLM Production CI/CD Pipeline

> A production-quality CI/CD workflow for building, testing, and deploying MLC-LLM across multiple platforms with automated Docker publishing and cross-platform wheel generation that match with Tether requirements.

[![CI Pipeline](https://github.com/EmaLinuxawy/mlc-llm/actions/workflows/pipeline.yml/badge.svg)](https://github.com/EmaLinuxawy/mlc-llm/actions/workflows/pipeline.yml)
[![Docker Image](https://img.shields.io/badge/docker-ghcr.io-blue)](https://ghcr.io/EmaLinuxawy/mlc-llm)
[![Python](https://img.shields.io/badge/python-3.11-green)](https://python.org)

## Overview

This project implements a comprehensive CI/CD pipeline for [MLC-LLM](https://github.com/mlc-ai/mlc-llm), delivering:

- **Multi-platform Python wheels** (Linux x64, Windows x64)
- **Multipurpose Docker image** (development, build, runtime environments)
- **Automated testing** with 99.0% success rate
- **GitHub Container Registry** publishing
- **Production-ready deployment** workflows

## Quick Start

### Using Docker (Recommended)

```bash
# Pull the latest image
docker pull ghcr.io/EmaLinuxawy/mlc-llm:latest

# Development environment
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/EmaLinuxawy/mlc-llm dev

# CLI usage
docker run --rm ghcr.io/EmaLinuxawy/mlc-llm --help

# Server mode
docker run -p 8000:8000 \
  ghcr.io/EmaLinuxawy/mlc-llm serve --port 8000
```

### Using Python Wheels

```bash
# Install from GitHub releases
pip install https://github.com/EmaLinuxawy/mlc-llm/releases/download/v1.0.0/mlc_llm-*.whl

# Or install compatible TVM first
pip install --pre -f https://mlc.ai/wheels mlc-ai-nightly-cpu
pip install <wheel-url>
```

## Features

### CI/CD Pipeline

- **Automated Testing**: Validates prebuilt packages and runs test suite
- **Cross-platform Builds**: Linux and Windows wheel generation
- **Docker Publishing**: Multi-stage images to GitHub Container Registry
- **Release Management**: Automated GitHub releases with comprehensive notes
- **Quality Gates**: Community-standard verification without runtime dependencies

### Docker Image

- **Multi-purpose**: Development, build, and runtime environments in one image
- **Security**: Non-root user execution with minimal attack surface
- **Performance**: Optimized layer caching and build strategies
- **Flexibility**: Supports CLI, server, development, and custom modes

### Python Packages

- **Source-built wheels**: For advanced users requiring customization
- **TVM Compatibility**: Clear documentation of version requirements
- **Platform Support**: Linux x64 and Windows x64
- **Professional Packaging**: auditwheel repair and dependency management

## Architecture

### Pipeline Flow

```
                    ┌─────────────────┐
                    │      test       │
                    └─────────────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│     docker      │ │   build-linux   │ │  build-windows  │
└─────────────────┘ └─────────────────┘ └─────────────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             ▼
                    ┌─────────────────┐
                    │    release      │
                    └─────────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │    summary      │
                    └─────────────────┘
```

### Technology Stack

- **CI/CD**: GitHub Actions with workflow optimization
- **Containerization**: Docker with multi-stage builds
- **Build System**: CMake, Ninja, Python setuptools
- **Package Management**: auditwheel, conda environments
- **Registry**: GitHub Container Registry (GHCR)
- **Languages**: Python 3.11, C++, Rust

## Documentation

Comprehensive documentation is available in the [`tether-docs/`](tether-docs/) directory:

**Core Guides**

- [Prerequisites &amp; Dependencies](tether-docs/prerequisites.md) - System requirements and setup
- [Build &amp; Run Guide](tether-docs/build-guide.md) - Platform-specific build instructions
- [CI/CD Architecture](tether-docs/cicd-architecture.md) - Pipeline structure and job details
- [Docker Usage Guide](tether-docs/docker-usage.md) - Container deployment and usage

**Reference**

- [Known Issues](tether-docs/known-ci-issues.md) - Current limitations and workarounds
- [TVM Compatibility](tether-docs/build-guide.md#tvm-compatibility) - Critical dependency notes

## Getting Started

### 1. Prerequisites

Ensure you have the required dependencies:

```bash
# See detailed requirements in tether-docs/prerequisites.md
- Docker 20.10+
- Python 3.11
- Git with submodule support
```

### 2. Local Development

```bash
# Clone repository
git clone --recursive https://github.com/EmaLinuxawy/mlc-llm.git
cd mlc-llm

# Option A: Use Docker (recommended)
docker run -it --rm -v $(pwd):/workspace ghcr.io/EmaLinuxawy/mlc-llm dev

# Option B: Local build (see tether-docs/build-guide.md)
pip install -r requirements.txt
./scripts/build-local.sh
```

### 3. Production Deployment

```bash
# Pull production image
docker pull ghcr.io/EmaLinuxawy/mlc-llm:latest

# Deploy with Docker Compose
curl -O https://raw.githubusercontent.com/EmaLinuxawy/mlc-llm/main/docker-compose.prod.yml
docker-compose -f docker-compose.prod.yml up -d
```

## Platform Support

| Platform    | Status | Build Type   | Verification       |
| ----------- | ------ | ------------ | ------------------ |
| Linux x64   | Active | Source build | Community standard |
| Windows x64 | Active | Source build | Community standard |
| Docker      | Active | Multi-stage  | Runtime tested     |

## Development Workflow

1. Fork and clone the repository
2. Review [tether-docs/prerequisites.md](tether-docs/prerequisites.md)
3. Follow [tether-docs/build-guide.md](tether-docs/build-guide.md)
4. Test changes with the CI pipeline
5. Submit pull requests with clear descriptions
