# syntax=docker/dockerfile:1.4

FROM debian:bookworm-slim AS build

# 1. Install dependencies required for Flutter Web
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Flutter
ARG FLUTTER_VERSION="3.41.5"
ENV FLUTTER_HOME=/opt/flutter
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME}

# 3. Set SDK paths
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app/core

# Copy the app and packages into the build container
COPY . /app/core

# Assign correct git ownership to avoid security errors
RUN git config --global --add safe.directory ${FLUTTER_HOME} && \
    git config --global --add safe.directory /app/core

# 4. Resolve dependencies and build the web app
RUN flutter pub get
# RUN dart scripts/env_gen.dart --copy --env=.env.prod
RUN dart run build_runner build --delete-conflicting-outputs
# RUN dart run build_pipe:build
RUN flutter build web --base-href /web/ --wasm

# 5. Compile the app server
RUN dart build cli -o build/server

# --- Stage 2: Serve the compiled web app ---
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app/core/build/server/bundle /app/server
COPY --from=build /app/core/build/web /app/build/web
COPY --from=build /app/core/content /app/content
COPY --from=build /app/core/templates /app/templates

EXPOSE 80

ENV PORT=80

CMD ["/app/server/bin/server"]