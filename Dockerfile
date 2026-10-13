# syntax=docker/dockerfile:1.4
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY build/server/bundle /app/server
COPY build/web /app/build/web
COPY content /app/content
COPY templates /app/templates
EXPOSE 80
ENV PORT=80
CMD ["/app/server/bin/server"]
