# Use Ubuntu 18.04 (Bionic Beaver) as the base image
FROM ubuntu:18.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install all required dependencies for BlockSci
# Added 'libsparsehash-dev' for Google's sparsehash library (dense_hash_map)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    git \
    cmake \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libssl-dev \
    libzmq3-dev \
    libsodium-dev \
    libczmq-dev \
    python3-dev \
    gcc-7 \
    g++-7 \
    liblz4-dev \
    libjsoncpp-dev \
    libjsonrpccpp-dev \
    libboost-all-dev \
    libsparsehash-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory for the project inside the container
WORKDIR /opt/BlockSci

# Copy your local project files into the working directory
COPY . .

# Create a build directory and move into it
RUN mkdir build
WORKDIR /opt/BlockSci/build

# Configure the project with cmake, explicitly using gcc-7 and g++-7
RUN cmake -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 ..

# Compile the project
RUN make -j$(nproc)

# Set the default command to a bash shell to explore the compiled project
CMD ["bash"]

