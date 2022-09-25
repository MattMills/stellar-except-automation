#!/bin/bash

for DBG_FILE in $(find $STELLAR_BACKUPS_GOG -maxdepth 4 -iname stellaris.pdb | sort)
do
	BASENAME=`basename $DBG_FILE`
	BASENAME_NO_EXT=`basename -s .pdb $DBG_FILE`
	DIRNAME=`dirname $DBG_FILE`
	DDIRNAME=`dirname $DIRNAME`
	DDDIRNAME=`dirname $DDIRNAME`
	VERSION=`basename $DDDIRNAME`

	if [ -f "$DBG_FILE.xml" ]; then
		echo ".pdb.xml for $VERSION already exists, skipping"
	else
		echo "Creating .pdb.xml for $VERSION"
		scp $DBG_FILE $WINDOWS_USER_HOST:
		ssh $WINDOWS_USER_HOST "pdb.exe $BASENAME > $BASENAME.xml"
		scp $WINDOWS_USER_HOST:$BASENAME.xml $DIRNAME
		ssh $WINDOWS_USER_HOST del $BASENAME $BASENAME.xml
	fi


	echo "Running Ghidra Import"
	$GHIDRA_PATH/support/analyzeHeadless \
		$GHIDRA_PROJECTS stellaris-auto/$VERSION \
		-import $DIRNAME/$BASENAME_NO_EXT.exe \
		-preScript ghidra_prescript.py $DBG_FILE.xml \
		-scriptPath $GHIDRA_SCRIPTS/analysis/ \
		-max-cpu 12
done
