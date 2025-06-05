# Tether Task Documentation

This directory contains comprehensive documentation for the MLC-LLM CI/CD pipeline, Docker implementation, and build system developed as part of the Tether task.

## Contents

### Core Documentation

- [Prerequisites and Dependencies](prerequisites.md) - System requirements, dependencies, and environment setup
- [Build and Run Guide](build-guide.md) - Complete build instructions for all platforms
- [CI/CD Pipeline Architecture](cicd-architecture.md) - Detailed workflow structure and job descriptions
- [Docker Usage Guide](docker-usage.md) - Comprehensive Docker image usage and deployment

### Reference Documentation

- [Known CI Issues](known-ci-issues.md) - Current test failures and explanations
- [TVM Compatibility Notes](build-guide.md#tvm-compatibility) - Critical TVM integration requirements

## Quick Start

1. **Prerequisites**: Review [prerequisites.md](prerequisites.md) for system setup
2. **Local Build**: Follow [build-guide.md](build-guide.md) for platform-specific builds
3. **Docker Usage**: See [docker-usage.md](docker-usage.md) for containerized workflows
4. **CI/CD**: Understand [cicd-architecture.md](cicd-architecture.md) for automation

## Project Status

**Current Status**: Production-ready CI/CD pipeline
**Python Version**: 3.11 (primary supported version)
**Docker Registry**: GitHub Container Registry (ghcr.io)
**Platforms**: Linux x64, Windows x64
**Test Success Rate**: 83.0% (15/18 tests pass)

## Pipeline Overview

### Automated Workflows

- **Testing**: Package validation and functionality tests
- **Building**: Cross-platform wheel compilation
- **Docker**: Multi-stage image build and publish
- **Releasing**: GitHub releases with artifacts
- **Verification**: Community-standard wheel testing

### Key Features

- Source-built wheels for advanced users
- TVM Unity compatibility requirements
- Multi-purpose Docker image (dev/build/runtime)
- Automated GitHub Container Registry publishing
- Comprehensive release documentation

## Architecture Highlights

### CI/CD Pipeline

```
test → docker, build-linux, build-windows → release → summary
```

### Docker Image Capabilities

- Development environment with full toolchain
- Build environment for automated compilation
- Runtime environment for production deployment
- CLI access for direct command execution

### Build Verification

- Community-standard approach (no runtime TVM testing)
- Wheel structure and dependency validation
- Compatible with both source-built and prebuilt TVM
- Clear documentation of compatibility requirements

## Support and Troubleshooting

For issues and troubleshooting:

1. Check [known-ci-issues.md](known-ci-issues.md) for documented problems
2. Review platform-specific sections in [build-guide.md](build-guide.md)
3. Consult Docker troubleshooting in [docker-usage.md](docker-usage.md)
4. Reference CI/CD debugging in [cicd-architecture.md](cicd-architecture.md)
