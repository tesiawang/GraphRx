#!/bin/bash

# Get the absolute path of the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PRETRAIN_SCRIPT="${PROJECT_ROOT}/OfflinePretrain/pretrain_entire_main_net.py"

sir_patterns=("NoneSIR" "HighSIR" "MidSIR")
for i in {0..2};do
    python "${PRETRAIN_SCRIPT}" --seed 42 \
                                --num_epochs 20 \
                                --save_model_every 2 \
                                --SIR_pattern ${sir_patterns[$i]} \
                                --lr 0.001 &
done