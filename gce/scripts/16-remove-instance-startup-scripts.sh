#!/bin/bash

eval "$MYZONES_LIST"

# Bastion host
echo "=> Removing startup script for bastion host..."
zone=${DEFAULTZONE}
gcloud compute instances remove-metadata ${CLUSTERID}-bastion \
  --keys startup-script \
  --zone=${zone}

# Master nodes
echo "=> Removing startup script for master nodes..."
for i in $(seq 0 $((${MASTER_NODE_COUNT}-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  gcloud compute instances remove-metadata ${CLUSTERID}-master-${i} \
    --keys startup-script \
    --zone=${zone[$i]}
done

# Infrastructure nodes
echo "=> Removing startup script for infra nodes..."
for i in $(seq 0 $(($INFRA_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  gcloud compute instances remove-metadata ${CLUSTERID}-infra-${i} \
    --keys startup-script \
    --zone=${zone[$i]}
done

# Compute nodes
echo "=> Removing startup script for compute nodes..."
for i in $(seq 0 $(($APP_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  gcloud compute instances remove-metadata ${CLUSTERID}-compute-${i} \
    --keys startup-script \
    --zone=${zone[$i]}
done

# CNS nodes
echo "=> Removing startup script for OCS nodes..."
for i in $(seq 0 $(($CNS_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  gcloud compute instances remove-metadata \
    --keys startup-script ${CLUSTERID}-cns-${i} --zone=${zone[$i]}
done
