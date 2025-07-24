# DeepFace with ROCm Support

This document describes how to use DeepFace with AMD GPUs via ROCm and tensorflow-rocm.

## Prerequisites

Before installing DeepFace with ROCm support, ensure you have:

1. **Linux Operating System** - ROCm is only supported on Linux
2. **AMD GPU** - Compatible AMD GPU with ROCm support
3. **ROCm Installation** - ROCm drivers and libraries installed on your system
   - Follow the official ROCm installation guide: https://rocm.docs.amd.com/
4. **Python 3.8-3.11** - tensorflow-rocm 2.18.1 supports these Python versions

## Installation

### Quick Installation

Run the provided installation script from the DeepFace root directory:

```bash
chmod +x install_rocm.sh
./install_rocm.sh
```

### Manual Installation

If you prefer to install manually:

```bash
# Install specific numpy version (ROCm requirement)
pip install numpy==1.26.4

# Install tensorflow-rocm from official ROCm repository
# Replace cp312 with your Python version (cp38, cp39, cp310, cp311, or cp312)
pip install https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp312-cp312-manylinux_2_28_x86_64.whl

# Install tf-keras for TensorFlow 2.16+ compatibility
pip install tf-keras

# Install DeepFace without dependencies
pip install -e . --no-deps

# Install remaining dependencies
pip install -r requirements_rocm.txt
```

Available tensorflow-rocm wheels for different Python versions:
- Python 3.8: `https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp38-cp38-manylinux_2_28_x86_64.whl`
- Python 3.9: `https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp39-cp39-manylinux_2_28_x86_64.whl`
- Python 3.10: `https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp310-cp310-manylinux_2_28_x86_64.whl`
- Python 3.11: `https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp311-cp311-manylinux_2_28_x86_64.whl`
- Python 3.12: `https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.2/tensorflow_rocm-2.18.1-cp312-cp312-manylinux_2_28_x86_64.whl`

## Verification

Verify your installation:

```python
# Check TensorFlow ROCm
import tensorflow as tf
print("TensorFlow version:", tf.__version__)
print("GPU available:", tf.config.list_physical_devices('GPU'))

# Check DeepFace
from deepface import DeepFace
print("DeepFace imported successfully")

# Test face verification
result = DeepFace.verify("img1.jpg", "img2.jpg")
print("Verification result:", result)
```

## Supported Models

### Face Recognition Models (All Supported)
- VGG-Face
- Facenet
- Facenet512
- OpenFace
- DeepFace
- DeepID
- ArcFace
- Dlib
- SFace
- GhostFaceNet

### Face Detection Models (Supported)
- OpenCV
- MTCNN (TensorFlow version)
- RetinaFace
- MediaPipe
- YuNet
- Yolo
- CenterFace

### Face Detection Models (NOT Supported)
- **FastMTCNN** - Requires PyTorch (use regular MTCNN instead)

### Facial Attribute Analysis (All Supported)
- Age prediction
- Gender prediction
- Emotion recognition
- Race/ethnicity prediction

### Face Anti-Spoofing (NOT Supported)
- **FasNet** - Requires PyTorch

## Usage Examples

### Face Verification
```python
from deepface import DeepFace

# Verify if two images are the same person
result = DeepFace.verify(
    img1_path="person1.jpg",
    img2_path="person2.jpg",
    model_name="VGG-Face",  # Any supported model
    detector_backend="opencv"  # Use supported detector
)
```

### Face Recognition
```python
# Find faces in database
df = DeepFace.find(
    img_path="query.jpg",
    db_path="face_database/",
    model_name="Facenet512",
    detector_backend="retinaface"
)
```

### Facial Analysis
```python
# Analyze facial attributes
analysis = DeepFace.analyze(
    img_path="face.jpg",
    actions=['age', 'gender', 'race', 'emotion'],
    detector_backend="mtcnn"  # Use MTCNN, not FastMTCNN
)
```

## Limitations

1. **PyTorch Models Not Supported**: Models requiring PyTorch (FasNet, FastMTCNN) will raise `NotImplementedError` when using tensorflow-rocm
2. **NumPy Version**: Must use NumPy < 2.0 (we pin to 1.26.4)
3. **Linux Only**: ROCm is only available on Linux systems

## Troubleshooting

### ImportError for tensorflow
If you see errors about tensorflow imports, ensure you don't have both `tensorflow` and `tensorflow-rocm` installed:
```bash
pip uninstall tensorflow tensorflow-gpu
pip install tensorflow-rocm==2.18.1
```

### GPU Not Detected
Verify ROCm installation:
```bash
rocm-smi  # Should show your AMD GPU
```

### Model Loading Issues
If you encounter issues loading models, try clearing the DeepFace weights cache:
```bash
rm -rf ~/.deepface/weights/
```

## Performance Notes

- AMD GPUs via ROCm generally provide good performance for deep learning inference
- Performance may vary compared to NVIDIA GPUs depending on the specific model and GPU
- For optimal performance, ensure ROCm and GPU drivers are up to date

## Alternative Backends

If you need functionality not supported with ROCm (like PyTorch models), consider:
1. Using CPU-only mode by uninstalling tensorflow-rocm and installing regular tensorflow
2. Using a different detector/model that doesn't require PyTorch
3. Running PyTorch models on CPU while using ROCm for TensorFlow models