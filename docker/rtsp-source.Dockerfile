ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Install v4l-utils for camera control
RUN apt-get update && apt-get install -y --no-install-recommends \
    v4l-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy custom entrypoint script
COPY docker/rtsp-entrypoint.sh /rtsp-entrypoint.sh
RUN chmod +x /rtsp-entrypoint.sh

ENTRYPOINT ["/rtsp-entrypoint.sh"]
CMD ["go2rtc", "-config", "/config/go2rtc.yaml"]
