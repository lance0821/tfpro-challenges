#!/usr/bin/env bash
# Challenge 12 — CI/CD Automation Script
#
# This script runs a non-interactive Terraform workflow suitable for CI/CD.
# Your job is to complete the TODOs so the full pipeline works without prompts.
#
# Usage: ./ci.sh <directory> [destroy]
# Example: ./ci.sh network
# Example: ./ci.sh application
# Example: ./ci.sh application destroy

set -euo pipefail

WORKING_DIR="${1:?Usage: ./ci.sh <directory> [destroy]}"
DESTROY_MODE="${2:-}"

echo "=== Terraform CI Pipeline ==="
echo "Directory: $WORKING_DIR"
echo "Mode: ${DESTROY_MODE:-apply}"
echo ""

cd "$WORKING_DIR"

# --- Step 1: Format Check ---
# TODO: Run terraform fmt -check -recursive
# If formatting is wrong, print an error and exit 1.
echo "--- Step 1: Checking formatting ---"
# terraform fmt -check -recursive || { echo "ERROR: Formatting check failed. Run 'terraform fmt' to fix."; exit 1; }

# --- Step 2: Initialize ---
# TODO: Run terraform init with -input=false so it never prompts.
echo "--- Step 2: Initializing ---"
# terraform init -input=false

# --- Step 3: Validate ---
# TODO: Run terraform validate. Exit if invalid.
echo "--- Step 3: Validating ---"
# terraform validate || { echo "ERROR: Validation failed."; exit 1; }

# --- Step 4: Plan ---
# TODO: Run terraform plan with:
#   -input=false (no prompts)
#   -detailed-exitcode (0=no changes, 1=error, 2=changes pending)
#   -out=tfplan (save the plan)
# Handle the three exit codes correctly.
echo "--- Step 4: Planning ---"

if [ "$DESTROY_MODE" = "destroy" ]; then
    echo "Running destroy plan..."
    # TODO: Add -destroy flag to the plan command
    # terraform plan -input=false -detailed-exitcode -destroy -out=tfplan
    PLAN_EXIT=0
else
    # terraform plan -input=false -detailed-exitcode -out=tfplan
    PLAN_EXIT=0
fi

# TODO: Handle exit codes:
# 0 = Success, no changes. Skip apply.
# 1 = Error. Fail the pipeline.
# 2 = Success, changes pending. Proceed to apply.

# case $PLAN_EXIT in
#     0)
#         echo "No changes detected. Nothing to apply."
#         exit 0
#         ;;
#     1)
#         echo "ERROR: Plan failed."
#         exit 1
#         ;;
#     2)
#         echo "Changes detected. Proceeding to apply."
#         ;;
# esac

# --- Step 5: Apply ---
# TODO: Apply the saved plan file (NOT a new plan).
echo "--- Step 5: Applying saved plan ---"
# terraform apply tfplan

echo "=== Pipeline complete ==="

# Clean up plan file
# rm -f tfplan
