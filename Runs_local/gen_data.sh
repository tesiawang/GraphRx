#!/bin/bash

# Get the absolute path of the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
GEN_DATA_SCRIPT="${PROJECT_ROOT}/Data/gen_data.py"

# Verify the script exists
if [ ! -f "${GEN_DATA_SCRIPT}" ]; then
    echo "ERROR: gen_data.py not found at ${GEN_DATA_SCRIPT}"
    echo "Please check if the script exists and the path is correct."
    exit 1
fi

# Comprehensive data generation script covering all combinations
# Generation types: 0=NoneSIR, 1=MidSIR, 2=HighSIR
# Modes: offline (per SNR point), online (per channel config)

echo "Starting comprehensive data generation..."
echo "Script location: ${GEN_DATA_SCRIPT}"
echo "This will generate data for all combinations of generation_type (0,1,2) and mode (offline,online)"
echo ""

# Common parameters
SEED=42
TTI_BATCH_SIZE=32
NUM_BATCHES_SNR=5     # For offline mode, can be changed as needed
NUM_BATCHES_CONFIG=5   # For online mode, can be changed as needed

# Function to run data generation with error handling
run_generation() {
    local gen_type=$1
    local mode=$2
    local batch_param=$3
    local batch_value=$4
    
    echo "Generating data: generation_type=${gen_type}, mode=${mode}, ${batch_param}=${batch_value}"
    
    if python "${GEN_DATA_SCRIPT}" \
        --seed ${SEED} \
        --generation_type ${gen_type} \
        --mode ${mode} \
        --tti_batch_size ${TTI_BATCH_SIZE} \
        ${batch_param} ${batch_value}; then
        echo "SUCCESS: generation_type=${gen_type}, mode=${mode}"
    else
        echo "FAILED: generation_type=${gen_type}, mode=${mode}"
        return 1
    fi
    echo ""
}

# Generate data for all combinations
for generation_type in 0; do
    echo "Processing generation_type=${generation_type}"
    
    # Offline mode (generates data for each SNR point separately)
    # run_generation ${generation_type} "offline" "--num_batches_per_snr" ${NUM_BATCHES_SNR}
    
    # Online mode (generates data across SNR ranges for channel adaptation)  
    run_generation ${generation_type} "online" "--num_batches_per_config" ${NUM_BATCHES_CONFIG}
    
    echo "Completed generation_type=${generation_type}"
    echo "----------------------------------------"
done

echo "All data generation completed!"
echo ""
echo "Summary of generated data:"
echo "- Generation types: 0 (NoneSIR), 1 (MidSIR), 2 (HighSIR)"
echo "- Modes: offline (${NUM_BATCHES_SNR} batches per SNR), online (${NUM_BATCHES_CONFIG} batches per config)"
echo "- Total combinations: 6 (3 generation_types and 2 modes)"