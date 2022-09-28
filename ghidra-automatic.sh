#!/bin/bash

PLATFORM="GOG"

if [ "$PLATFORM" == "GOG" ]; then
	STELLAR_BACKUPS="$STELLAR_BACKUPS_GOG"
elif [ "$PLATFORM" == "STEAM" ]; then
	STELLAR_BACKUPS="$STELLAR_BACKUPS_STEAM"
else
	echo "ERROR: Invalid platform"
	exit
fi


for FILE in $(find $STELLAR_BACKUPS -maxdepth 4 -iname stellaris.exe | sort)
do
	BASENAME=`basename $FILE`
	BASENAME_NO_EXT=`basename -s .exe $FILE`
	DIRNAME=`dirname $FILE`
	DDIRNAME=`dirname $DIRNAME`
	DDDIRNAME=`dirname $DDIRNAME`
	VERSION=`basename $DDDIRNAME`

	DBG_FILE="$DIRNAME/$BASENAME_NO_EXT.pdb"
	EXE_FILE="$DIRNAME/$BASENAME_NO_EXT.exe"

	echo "=============================================================="
	echo "|"
	echo "|"
	echo "| Starting analysis for platform $PLATFORM version $VERSION"
	echo "|"
	echo "|"
	echo "=============================================================="

	DBG_EXISTS=0

	if [ -f "$DBG_FILE" ]; then
		echo "Found PDB for $VERSION"
		GHIDRA_DEST_PATH="stellaris-auto/$VERSION/$PLATFORM/"
		if [ -f "$DBG_FILE.xml" ]; then
			echo ".pdb.xml for $VERSION already exists, skipping"
		else
			echo "Creating .pdb.xml for $VERSION"
			scp $DBG_FILE $WINDOWS_USER_HOST:
			ssh $WINDOWS_USER_HOST "pdb.exe $BASENAME > $BASENAME.xml"
			scp $WINDOWS_USER_HOST:$BASENAME.xml $DIRNAME
			ssh $WINDOWS_USER_HOST del $BASENAME $BASENAME.xml
		fi
	else
		GHIDRA_DEST_PATH="stellaris-auto/$VERSION/no_pdb_$PLATFORM/"

	fi

	

	echo "Running Ghidra Import"

	$GHIDRA_PATH/support/analyzeHeadless \
		$GHIDRA_PROJECTS $GHIDRA_DEST_PATH \
		-import $EXE_FILE \
		-preScript ghidra_prescript.py $DBG_FILE.xml \
		-scriptPath $GHIDRA_SCRIPTS/analysis/ \
		-max-cpu 12

	echo
	echo
	echo

done
