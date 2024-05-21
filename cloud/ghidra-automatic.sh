#!/bin/bash

. ../stellar-env.sh

PLATFORM="GOG"

if [ "$PLATFORM" == "GOG" ]; then
	STELLAR_BACKUPS="$STELLAR_BACKUPS_GOG"
elif [ "$PLATFORM" == "STEAM" ]; then
	STELLAR_BACKUPS="$STELLAR_BACKUPS_STEAM"
else
	echo "ERROR: Invalid platform"
	exit
fi


OUTBOUND_DIR="/gcp/stellaris-ghidra-data/$PLATFORM/"

VM_COUNT=1

IFS=$'\n'
for FILE in $(find -L $STELLAR_BACKUPS -maxdepth 4 -iname stellaris.exe | sort)
do
	BASENAME=`basename $FILE`
	BASENAME_NO_EXT=`basename -s .exe $FILE`
	DIRNAME=`dirname $FILE`
	DDIRNAME=`dirname $DIRNAME`
	DDDIRNAME=`dirname $DDIRNAME`
    if [ "$PLATFORM" == "GOG" ]; then
    	VERSION=`basename $DDDIRNAME`
    elif [ "$PLATFORM" == "STEAM" ]; then
        VERSION=`basename $DIRNAME | awk '{print $1}'`
        if [ "$VERSION" == "version" ]; then
            continue
        fi
    fi

	DBG_FILE="$DIRNAME/$BASENAME_NO_EXT.pdb"
	EXE_FILE="$DIRNAME/$BASENAME_NO_EXT.exe"


	#echo "=============================================================="
	#echo "|"
	#echo "|"
	#echo "| Starting analysis for platform $PLATFORM version $VERSION"
	#echo "|"
	#echo "|"
	#echo "=============================================================="
    #mkdir -p $OUTBOUND_DIR/$VM_COUNT

	DBG_EXISTS=0
    DBG_URL="NA"
	if [ -f "$DBG_FILE" ]; then
		#echo "Found PDB for $VERSION"
		GHIDRA_DEST_PATH="stellaris/$VERSION/$PLATFORM/"
		if [ -f "$DBG_FILE.xml.zip" ]; then
            DBG_URL="$BASE_URL/$VM_COUNT.pdb.xml.zip"
            #rm -f $WEB_DIR/$VM_COUNT.pdb.xml.zip
            #ln -s "$DBG_FILE.xml.zip" $WEB_DIR/$VM_COUNT.pdb.xml.zip
            #cp $DBG_FILE $OUTBOUND_DIR/$VM_COUNT/
        else
            DBG_URL="NA"
		fi
	else
		GHIDRA_DEST_PATH="stellaris/$VERSION/no_pdb_$PLATFORM/"
	fi

    EXE_URL="$BASE_URL/$VM_COUNT.exe"
	
    #rm -f $WEB_DIR/$VM_COUNT.exe
    #ln -s "$EXE_FILE" $WEB_DIR/$VM_COUNT.exe
    #cp "$EXE_FILE" $OUTBOUND_DIR/$VM_COUNT/
    #if [ "$PLATFORM" == "GOG" ]; then
    #    cp "$DIRNAME/../metadata.json" $OUTBOUND_DIR/$VM_COUNT/
    #elif [ "$PLATFORM" == "STEAM" ]; then
    #    cp "$DIRNAME/metadata.json" $OUTBOUND_DIR/$VM_COUNT/
    #fi    

	#echo "VM INIT $VM_COUNT"
    if ! [ -f "$OUTBOUND_DIR/$VM_COUNT/fnhash.csv" ]; then
        echo "$OUTBOUND_DIR/$VM_COUNT"
        ./gcloud_instance.sh ghidra-$VM_COUNT "$OUTBOUND_DIR/$VM_COUNT/"
    fi
    let VM_COUNT++
done
