#!/usr/bin/env bash
# run.sh — Launch the C13B0⁷ Infinity AI via llama-cli
#
# Usage:
#   ./run.sh [path/to/model.gguf]
#
# If no model path is supplied the script falls back (in order) to:
#   1. The ZERO_INERTIA_MODEL environment variable
#   2. The Termux default path (Android/llama.cpp typical install)
#
# Set LLAMA_CPP_DIR to override the directory that contains bin/llama-cli.
# Example:
#   LLAMA_CPP_DIR=~/llama.cpp/build ./run.sh ~/models/gemma-3-1b-it-Q4_0.gguf

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LLAMA_CPP_DIR="${LLAMA_CPP_DIR:-$SCRIPT_DIR}"
BINARY="$LLAMA_CPP_DIR/bin/llama-cli"

DEFAULT_MODEL="${ZERO_INERTIA_MODEL:-/data/data/com.termux/files/home/models/gemma-3-1b-it-Q4_0.gguf}"
MODEL="${1:-$DEFAULT_MODEL}"

PROMPT_FILE="$SCRIPT_DIR/prompt.txt"

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "ERROR: prompt.txt not found at $PROMPT_FILE" >&2
  exit 1
fi

if [[ ! -x "$BINARY" ]]; then
  echo "ERROR: llama-cli binary not found or not executable at $BINARY" >&2
  echo "       Set LLAMA_CPP_DIR to the llama.cpp build directory, e.g.:" >&2
  echo "         LLAMA_CPP_DIR=~/llama.cpp/build $0 $MODEL" >&2
  exit 1
fi

PROMPT="$(cat "$PROMPT_FILE")"

echo "Zero-Inertia · C13B0⁷ Infinity AI"
echo "Model  : $MODEL"
echo "Context: 8192 tokens"
echo "Temp   : 0 (deterministic)"
echo "---"

exec "$BINARY" \
  -cnv \
  -t 4 \
  --ctx-size 8192 \
  --temp 0 \
  --color on \
  -m "$MODEL" \
  -p "$PROMPT"
