#!/usr/bin/env bash
DIRNAME="$(cd "$(dirname "$0")" && pwd)"
# Prefer an app-services wrapper script if present
APP_GRADLEW="$DIRNAME/app-services/gradlew"
if [ -x "$APP_GRADLEW" ]; then
  exec "$APP_GRADLEW" "$@"
fi
# Otherwise, if the app-services wrapper jar exists, run it directly
WRAPPER_JAR="$DIRNAME/app-services/gradle/wrapper/gradle-wrapper.jar"
if [ -f "$WRAPPER_JAR" ]; then
  exec java -jar "$WRAPPER_JAR" "$@"
fi
# Fallback to the old delegated wrapper location (legacy layout)
TARGET="$DIRNAME/app-services/user/gradlew"
if [ -x "$TARGET" ]; then
  exec "$TARGET" "$@"
else
  echo "ERROR: Could not find a Gradle wrapper (checked: $APP_GRADLEW, $WRAPPER_JAR, $TARGET)" >&2
  exit 1
fi
