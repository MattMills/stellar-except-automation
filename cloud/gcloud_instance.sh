#/bin/bash

if [ -z "$1" ]
then
    echo "Missing instance name"
    exit
fi


#    --machine-type=t2d-standard-4 \

gcloud beta compute instances create $1 \
    --project=stellarstellaris-ghidra \
    --zone=us-central1-c \
    --machine-type=n2d-highmem-8 \
    --network-interface=network-tier=STANDARD,no-address,stack-type=IPV4_ONLY,subnet=default \
    --no-restart-on-failure \
    --maintenance-policy=TERMINATE \
    --provisioning-model=SPOT \
    --instance-termination-action=DELETE \
    --max-run-duration=10800s \
    --scopes=https://www.googleapis.com/auth/devstorage.read_write,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append,compute-rw \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/stellarstellaris-ghidra/global/images/ghidra-image,mode=rw,size=10,type=projects/stellarstellaris-ghidra/zones/us-central1-c/diskTypes/pd-standard \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any \
    --metadata=ssh-keys="ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1F9ibOLKAOwknQwwkFLfdeomW9pA2QCfGvJMpvF3jw key-2016-8-9",GHIDRA_URL="$GHIDRA_URL",DATA_PATH="$2" \
    --metadata-from-file=startup-script=startup.sh
