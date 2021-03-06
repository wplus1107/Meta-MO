# export CUDA_VISIBLE_DEVICES=5

# t1: CHEMBL262
# t2: CHEMBL267
# t3: CHEMBL3267
# t4: CHEMBL3650
# t5: CHEMBL4005
# t6: CHEMBL4282

gpu=$1
data_ratio=1.0
load_ckpt=$2
meta_iter=570
train_epoch=500
inner_iter=50
save_ckpt_every=5
keep_ckpt=10
batch_size=32
seed=$3

tasks=("CHEMBL262" "CHEMBL267" "CHEMBL3267" "CHEMBL3650" "CHEMBL4005" "CHEMBL4282")

for task in ${tasks[@]}
do
    CUDA_VISIBLE_DEVICES=${gpu} python -u all_test_zs.py \
        -seed ${seed} \
        -batch_size ${batch_size} \
        -translate_batch_size ${batch_size} \
        -meta_test_task ${task} \
        -data processed_data/meta-test/${task} \
        -output all_test_${task}_zeroshot_ckpt_${load_ckpt}_seed_${seed}.predict \
        -log_file all_test_${task}.log \
        -data_ratio ${data_ratio} \
        -load_meta_step ${load_ckpt} \
        -save_model experiments/all_train/model \
        -train_epochs ${train_epoch} \
        -inner_iterations ${inner_iter} \
        -save_checkpoint_epochs ${save_ckpt_every} \
        -keep_checkpoint ${keep_ckpt} \
        -report_every 50000 \
        -param_init_glorot \
        -position_encoding \
        -share_embeddings \
        -replace_unk \
        -fast > nohup_all_test_${task}_zeroshot_ckpt_${load_ckpt}_seed_${seed}.log 2>&1
done