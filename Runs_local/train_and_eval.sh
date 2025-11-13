#!/bin/bash

# Get the absolute path to the GraphRx root directory (parent of Runs_local)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GRAPHRX_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Running federated training and evaluation from: ${GRAPHRX_ROOT}"

python "${GRAPHRX_ROOT}/OnlineAdapt/Algo/fedgraph.py" \
                                    --seed 53 \
                                    --load_pretrained 0 \
                                    --client_data_dist_type 0 \
                                    --save_model_every 10 \
                                    --local_iter 160 \
                                    --record_batch_loss_every 40 \
                                    --lr 0.001 \
                                    --clients_per_round 6 \
                                    --num_total_clients 6 \
                                    --train_load_ratio 0.8 \
                                    --test_load_ratio 0.2 \
                                    --num_rounds 30 \
                                    --weighted_initial 1 \
                                    --penalty 0 \
                                    --dist_metric "l2" \
                                    --hyper_c 0.6 \
                                    --directed_graph 1


python "${GRAPHRX_ROOT}/Evaluation/online_eval.py" \
                          --num_total_clients 6 \
                          --num_rounds 30 \
                          --fl_method "fedgraph_new" \
                          --eval_baseline 1 \
                          --client_data_dist_type 0