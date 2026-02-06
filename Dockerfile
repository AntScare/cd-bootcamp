# syntax=docker/dockerfile:1

# Build stage - stažení http-echo binárky
FROM alpine:3.19 AS downloader

# Instalace curl pro stažení binárky
RUN apk add --no-cache curl

# Stažení http-echo z GitHub releases
ARG HTTP_ECHO_VERSION=1.0.0
RUN curl -L https://github.com/hashicorp/http-echo/releases/download/v${HTTP_ECHO_VERSION}/http-echo_${HTTP_ECHO_VERSION}_linux_amd64.tar.gz \
    -o http-echo.tar.gz && \
    tar -xzf http-echo.tar.gz && \
    chmod +x http-echo

# Final stage
FROM alpine:3.19

# Instalace curl pro healthcheck
RUN apk add --no-cache curl ca-certificates && \
    addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser

# Kopírování binárky z build stage
COPY --from=downloader /http-echo /usr/local/bin/http-echo

# Vytvoření wrapper scriptu pro správné routování
RUN echo '#!/bin/sh' > /usr/local/bin/entrypoint.sh && \
    echo 'exec /usr/local/bin/http-echo -listen=:8080 -text="Hello from http-echo!"' >> /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Nastavení non-root uživatele
USER appuser

# Expose portu
EXPOSE 8080

# Healthcheck - http-echo odpovídá na všechny cesty včetně /healthz
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/healthz || exit 1

# Spuštění aplikace
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
