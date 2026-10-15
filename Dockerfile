# ----- Step 1 : build -----
# Image with all compilation tools 
FROM debian:stable-slim AS build

# Install tools for C++
RUN apt-get update \
&& apt-get install -y --no-install-recommends cmake ninja-build g++ \
&& rm -rf /var/lib/apt/lists/*

# Copy source code in /src
WORKDIR /src
COPY . .

# Configure, compile, test and install in /install
RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
&& cmake --build build \
&& ctest --test-dir build --output-on-failure \
&& cmake --install build --prefix /install

# ----- Step 2 : final image -----
# Starting from a clean image : no compiler, no source code
FROM debian:stable-slim
COPY --from=build /install/bin/greet /usr/local/bin/greet
# Command run by "docker run"
CMD ["greet"]