#!/bin/sh

if [ -z "$1" ]; then
  exit 0
fi

pids=$(pgrep -d ' ' "$1")

if [ -n "$pids" ]; then
  echo "$pids"
  exit 0
else
  exit 1
fi
