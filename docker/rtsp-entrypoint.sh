#!/bin/bash
set -e

# Apply v4l2 controls if V4L2_CONTROLS environment variable is set
if [ -n "$V4L2_CONTROLS" ]; then
    echo "Applying v4l2 controls: $V4L2_CONTROLS"
    v4l2-ctl $V4L2_CONTROLS
fi

# Execute the original command
exec "$@"