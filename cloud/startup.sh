#!/bin/bash
export GHIDRA_URL=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/attributes/GHIDRA_URL -H 'Metadata-Flavor: Google')
export DATA_PATH=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/attributes/DATA_PATH -H 'Metadata-Flavor: Google')
cd /opt/ghidra/
EXE_MD5=`md5sum $DATA_PATH/stellaris.exe | awk '{print $1}'`
META_VERSION=`cat $DATA_PATH/metadata.json | jq -r .string_value`
META_VERSION_ONLY=`echo $META_VERSION | grep -Eo ' v[0-9]{1}\.[0-9]{1,2}\.[0-9]{1,2}' | grep -Eo '[0-9]{1}\.[0-9]{1,2}\.[0-9]{1,2}'`
META_COMMIT_HASH=`echo $META_VERSION | grep -Eo '[a-f0-9]{32}'`
META_DATE=`echo $META_VERSION | grep -Eo '\(.*\)' | tr -d ')' | tr -d '(' | tr ':' '.'`
META_PLATFORM=`echo $DATA_PATH | awk -F'/' '{print $4}'`

if [ -f $DATA_PATH/stellaris.pdb ]; then
    META_PDB="PDB"
else
    META_PDB="no_pdb"
fi

GHIDRA_DEST_PATH="$META_VERSION_ONLY/$META_PLATFORM-$META_PDB/$EXE_MD5-$META_COMMIT_HASH-$META_DATE/"


ghidra_11.0_PUBLIC/support/analyzeHeadless \
        "$GHIDRA_URL/stellaris/$GHIDRA_DEST_PATH" \
        -import $DATA_PATH/stellaris.exe \
        -preScript ghidra_prescript.py $DATA_PATH/stellaris.pdb \
        -preScript KaijuSetupScript.java \
        -postScript KaijuExportCSVHeadless.java $DATA_PATH/fnhash.csv \
        -postscript ghidra_dump_addresses.py \
        -postscript ghidra_make_signatures.py \
        -scriptPath script/ \
        -max-cpu 4

cp ~/.ghidra/.ghidra_11.0_PUBLIC/*.log $DATA_PATH/
cp /opt/ghidra/func_sigs.txt.gz $DATA_PATH/
cp /opt/ghidra/func_addr.txt $DATA_PATH/
touch $DATA_PATH/.analysis_complete

sleep 30
export NAME=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/name -H 'Metadata-Flavor: Google')
export ZONE=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')
gcloud --quiet compute instances delete $NAME --zone=$ZONE
