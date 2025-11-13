#!/bin/bash

# Get the absolute path of the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
FEDAVG_SCRIPT="${PROJECT_ROOT}/OnlineAdapt/Algo/fedavg.py"

# Verify the script exists
if [ ! -f "${FEDAVG_SCRIPT}" ]; then
    echo "ERROR: fedavg.py not found at ${FEDAVG_SCRIPT}"
    echo "Please check if the script exists and the path is correct."
    exit 1
fi

# Sample shell script for running federated learning algorithms
# Supports four algorithms: FedAvgs, FedAvgFT, FedReps, Dittos

echo "Starting federated learning experiments..."
echo "Script location: ${FEDAVG_SCRIPT}"
echo ""

# Common parameters
SEED=42
NUM_ROUNDS=2
SIR_PATTERN="NoneSIR"  # or "HighSIR"
CLIENT_DATA_DIST_TYPE=0
NUM_TOTAL_CLIENTS=6
CLIENTS_PER_ROUND=6
TRAIN_LOAD_RATIO=0.5
TEST_LOAD_RATIO=0.1
LR=1e-3
APPLY_AUG=1
AUG_TIMES=2
USE_CORESET=0
DEBUG=1  # Set to 0 to enable wandb logging

# Function to run federated algorithm with error handling
run_fed_algorithm() {
    local algorithm=$1
    local extra_params="$2"
    
    echo "Running ${algorithm} algorithm..."
    
    if python "${FEDAVG_SCRIPT}" \
        --fed_alg "${algorithm}" \
        --seed ${SEED} \
        --num_rounds ${NUM_ROUNDS} \
        --SIR_pattern "${SIR_PATTERN}" \
        --client_data_dist_type ${CLIENT_DATA_DIST_TYPE} \
        --num_total_clients ${NUM_TOTAL_CLIENTS} \
        --clients_per_round ${CLIENTS_PER_ROUND} \
        --train_load_ratio ${TRAIN_LOAD_RATIO} \
        --test_load_ratio ${TEST_LOAD_RATIO} \
        --lr ${LR} \
        --apply_aug ${APPLY_AUG} \
        --aug_times ${AUG_TIMES} \
        --use_coreset ${USE_CORESET} \
        --debug ${DEBUG} \
        ${extra_params}; then
        echo "SUCCESS: ${algorithm} completed successfully"
    else
        echo "FAILED: ${algorithm} failed"
        return 1
    fi
    echo ""
}

# ================================ ALGORITHM EXAMPLES ================================

# 1. FedAvgs - Standard Federated Averaging
echo "1. Running FedAvgs (Federated Averaging)..."
run_fed_algorithm "FedAvgs" "--num_epochs 1"

# 2. FedReps - Federated Representation Learning  
echo "2. Running FedReps (Federated Representation Learning)..."
run_fed_algorithm "FedReps" "--num_epochs_for_head 2 --num_epochs_for_rep 2 --num_glob_layers 9"

# 3. Dittos - Personalized Federated Learning with Regularization
echo "3. Running Dittos (Personalized FL with Regularization)..."
run_fed_algorithm "Dittos" "--local_iter 5 --lam 0.1 --local_lr 3e-3 --record_batch_loss_every 5"

# 4. FedAvgFT - Federated Averaging with Fine-Tuning (requires pre-trained FedAvgs model)
# Note: This requires a pre-trained FedAvgs model. Uncomment and adjust path as needed.
# echo "4. Running FedAvgFT (Federated Averaging + Fine-Tuning)..."
# FEDAVG_MODEL_PATH="${PROJECT_ROOT}/OnlineAdapt/FedAvgs/NoneSIR/AdaptedModels_Dist0_Aug2_CS0/Global/glob_para_round_4.pkl"
# run_fed_algorithm "FedAvgFT" "--FT 1 --FT_num_epochs 3 --load_fedavg_path ${FEDAVG_MODEL_PATH}"

echo "All federated learning experiments completed!"
echo ""
echo "SUMMARY:"
echo "- Algorithms tested: FedAvgs, FedReps, Dittos"
echo "- Data distribution: ${SIR_PATTERN} with dist_type=${CLIENT_DATA_DIST_TYPE}"
echo "- Training rounds: ${NUM_ROUNDS}"
echo "- Augmentation: ${AUG_TIMES}x (enabled=${APPLY_AUG})"
echo "- Models saved in: OnlineAdapt/<algorithm>/${SIR_PATTERN}/AdaptedModels_*"