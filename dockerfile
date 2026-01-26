# Use Miniconda base image
FROM continuumio/miniconda3

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Copy the requirements file
COPY face-recognition.txt .

# Create and activate Conda environment
RUN conda create --name face python=3.12 && \
    conda run -n face conda install -r face-recognition.txt

# Ensure Conda environment is activated when running the script
CMD ["bash", "-c", "source activate face && python face_recognition_model.py"]
