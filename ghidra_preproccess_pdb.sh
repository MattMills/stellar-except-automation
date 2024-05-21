#!/bin/bash

. ./stellar-env.sh

PLATFORM="STEAM"

if [ "$PLATFORM" == "GOG" ]; then
	STELLAR_BACKUPS="$STELLAR_BACKUPS_GOG"
elif [ "$PLATFORM" == "STEAM" ]; then
	STELLAR_BACKUPS="$STELLAR_BACKUPS_STEAM"
else
	echo "ERROR: Invalid platform"
	exit
fi

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
    PDB_FILE="$BASENAME_NO_EXT.pdb"


	echo "| Starting analysis for platform $PLATFORM version $VERSION"

	DBG_EXISTS=0

	if [ -f "$DBG_FILE" ]; then
		echo "Found PDB for $VERSION"
		GHIDRA_DEST_PATH="stellaris-auto/$VERSION/$PLATFORM/"
		if [ -f "$DBG_FILE.xml.zip" ]; then
			echo ".pdb.xml for $VERSION already exists, skipping"
		else
			echo "Creating .pdb.xml for $VERSION"
			scp $DBG_FILE $WINDOWS_USER_HOST:
			ssh $WINDOWS_USER_HOST "pdb.exe $PDB_FILE > $PDB_FILE.xml"
            ssh $WINDOWS_USER_HOST "\"C:\Program Files\7-Zip\7z.exe\" a $PDB_FILE.xml.zip $PDB_FILE.xml "
			scp $WINDOWS_USER_HOST:$PDB_FILE.xml.zip $DIRNAME
			ssh $WINDOWS_USER_HOST del $PDB_FILE $PDB_FILE.xml $PDB_FILE.xml.zip
            
		fi
	else
		GHIDRA_DEST_PATH="stellaris/$VERSION/no_pdb_$PLATFORM/"
	fi
done
