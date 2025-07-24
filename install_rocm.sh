#!/bin/bash

# DeepFace ROCm Installation Script
# This script installs DeepFace with tensorflow-rocm support

echo "Installing DeepFace with ROCm support..."
echo "This will install tensorflow-rocm 2.18.1 for AMD GPU support"
echo ""

# Check if we're in the deepface directory
if [ ! -f "setup.py" ]; then
    echo "Error: Please run this script from the DeepFace root directory"
    exit 1
fi

# Detect Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
PYTHON_VERSION_NO_DOT=$(python3 -c 'import sys; print(f"{sys.version_info.major}{sys.version_info.minor}")')

echo "Detected Python version: $PYTHON_VERSION"

# Map Python version to appropriate wheel
case $PYTHON_VERSION_NO_DOT in
    "38")
        WHEEL_URL="https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp38-cp38-manylinux_2_28_x86_64.whl"
        ;;
    "39")
        WHEEL_URL="https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp39-cp39-manylinux_2_28_x86_64.whl"
        ;;
    "310")
        WHEEL_URL="https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp310-cp310-manylinux_2_28_x86_64.whl"
        ;;
    "311")
        WHEEL_URL="https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp311-cp311-manylinux_2_28_x86_64.whl"
        ;;
    "312")
        WHEEL_URL="https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp312-cp312-manylinux_2_28_x86_64.whl"
        ;;
    *)
        echo "Error: Python $PYTHON_VERSION is not supported by tensorflow-rocm 2.18.1"
        echo "Supported versions: 3.8, 3.9, 3.10, 3.11, 3.12"
        exit 1
        ;;
esac

# Install tensorflow-rocm from official wheel first (not in requirements file)
echo "Installing tensorflow-rocm 2.18.1 from official ROCm repository..."
echo "URL: $WHEEL_URL"
pip install "$WHEEL_URL"

# Install all other dependencies from requirements_rocm.txt
echo "Installing DeepFace dependencies for ROCm..."
pip install -r requirements_rocm.txt

# Install DeepFace in editable mode without dependencies
echo "Installing DeepFace in development mode..."
pip install -e . --no-deps

echo ""
echo "Installation complete!"
echo ""
echo "To verify your installation, run:"
echo "  python -c \"import tensorflow as tf; print('TensorFlow version:', tf.__version__)\""
echo "  python -c \"from deepface import DeepFace; print('DeepFace imported successfully')\""
echo ""
echo "Note: The following models are NOT supported with ROCm:"
echo "  - FasNet (face anti-spoofing)"
echo "  - FastMTCNN (face detection)"
echo "Please use alternative models for these functions."