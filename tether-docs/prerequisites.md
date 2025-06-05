# Prerequisites and Dependencies

## System Requirements

### Operating Systems

- **Linux**: Ubuntu 20.04+ (recommended), CentOS 8+, RHEL 8+
- **Windows**: Windows 10+ with WSL2 (for development)
- **macOS**: macOS 11+ (for development)

### Hardware Requirements

- **RAM**: Minimum 8GB, Recommended 16GB+
- **Storage**: 10GB+ free space for builds
- **CPU**: x64 architecture (Intel/AMD)

## Software Dependencies

### Required Tools

- **Git**: Version 2.30+
- **Docker**: Version 20.10+ (for containerized workflows)
- **Python**: 3.11 (primary supported version)

### Build Dependencies (Linux)

```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    curl \
    ccache \
    patchelf \
    libvulkan-dev \
    vulkan-tools \
    spirv-tools \
    libshaderc-dev \
    glslang-dev \
    glslang-tools \
    spirv-headers

# RHEL/CentOS
sudo yum groupinstall "Development Tools"
sudo yum install cmake ninja-build git curl ccache patchelf vulkan-devel
```

### Build Dependencies (Windows)

- **Miniconda**: For conda environment management
- **Visual Studio 2019+**: With C++ build tools
- **Git**: With long path support enabled
- **CUDA Toolkit**: Optional, for GPU support

### Python Dependencies

```bash
pip install --upgrade pip wheel setuptools
pip install build auditwheel twine
pip install torch --index-url https://download.pytorch.org/whl/cpu
pip install transformers tokenizers numpy scipy pytest
```

## TVM Compatibility

### Critical Dependency

MLC-LLM requires **Apache TVM Unity**. Source-built wheels have specific compatibility requirements:

#### Option 1: Source-built TVM (Recommended for development)

```bash
git clone --recursive https://github.com/mlc-ai/relax.git tvm-unity
cd tvm-unity
# Follow TVM Unity build instructions
```

#### Option 2: Prebuilt TVM (Quick testing)

```bash
pip install --pre -f https://mlc.ai/wheels mlc-ai-nightly-cpu
```

**Note**: Compatibility between source-built MLC-LLM and prebuilt TVM is not guaranteed.

## GitHub Environment

### Repository Access

- Fork or clone: `https://github.com/mlc-ai/mlc-llm`
- Submodules are required: Use `--recursive` flag

### GitHub Actions

- Repository must have Actions enabled
- Container Registry access for Docker publishing
- Release creation permissions for wheel publishing

### Environment Variables

```bash
# Required for builds
export CARGO_INCREMENTAL=0
export CARGO_PROFILE_DEV_DEBUG=0
export CARGO_TERM_COLOR=always
export RUST_BACKTRACE=short
export RUSTFLAGS="-D warnings"
```

## Network Requirements

### Package Repositories

- **PyPI**: For Python packages
- **mlc.ai/wheels**: For prebuilt MLC packages
- **PyTorch wheels**: For framework dependencies
- **GitHub Container Registry**: For Docker images

### Bandwidth Considerations

- Full build: ~5GB download
- Docker base images: ~2GB
- Submodules: ~1GB
- Python packages: ~1GB

## Development Environment Setup

### Recommended IDE

- **VS Code**: With Python, Docker, and GitLens extensions
- **PyCharm**: Professional edition with Docker support

### Optional Tools

- **act**: For local GitHub Actions testing
- **ccache**: For faster rebuilds
- **ninja**: For parallel builds
