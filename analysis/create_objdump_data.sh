#!/bin/bash

FOLDER="exec"
VERSION="3.5.2"
PLATFORM="gog"
OS="windows"
EXECUTABLE="stellaris.exe"
FULL_EXEC_PATH="$FOLDER/$VERSION/$PLATFORM/$OS/$EXECUTABLE"

objdump -p $FULL_EXEC_PATH  > $FULL_EXEC_PATH.objdump

IMPORT_TABLE_OFFSET=`grep -n 'The Import Tables' $FULL_EXEC_PATH.objdump  | awk -F: '{print $1}'`
EXPORT_TABLE_OFFSET=`grep -n 'The Export Tables' $FULL_EXEC_PATH.objdump  | awk -F: '{print $1}'`
FUNCTION_TABLE_OFFSET=`grep -n 'The Function Table' $FULL_EXEC_PATH.objdump  | awk -F: '{print $1}'`
RDATA_DUMP_OFFSET=`grep -n 'Dump of .rdata' $FULL_EXEC_PATH.objdump | awk -F: '{print $1}'`

echo "Import table: $IMPORT_TABLE_OFFSET Export table: $EXPORT_TABLE_OFFSET Function Table: $FUNCTION_TABLE_OFFSET RDATA: $RDATA_DUMP_OFFSET"

HEAD_N=$(expr $IMPORT_TABLE_OFFSET - 1)
head -n $HEAD_N $FULL_EXEC_PATH.objdump > $FULL_EXEC_PATH.objdump.execdata

TAIL_N=$(expr $EXPORT_TABLE_OFFSET - $IMPORT_TABLE_OFFSET)
HEAD_N=$(expr $EXPORT_TABLE_OFFSET - 3)
head -n $HEAD_N $FULL_EXEC_PATH.objdump | tail -n $TAIL_N > $FULL_EXEC_PATH.objdump.imports

TAIL_N=$(expr $FUNCTION_TABLE_OFFSET - $EXPORT_TABLE_OFFSET - 15)
HEAD_N=$(expr $FUNCTION_TABLE_OFFSET - 1)
head -n $HEAD_N $FULL_EXEC_PATH.objdump | tail -n $TAIL_N | grep -v Ordinal > $FULL_EXEC_PATH.objdump.exports

TAIL_N=$(expr $RDATA_DUMP_OFFSET - $FUNCTION_TABLE_OFFSET)
HEAD_N=$(expr $RDATA_DUMP_OFFSET - 1)
head -n $HEAD_N $FULL_EXEC_PATH.objdump | tail -n $TAIL_N > $FULL_EXEC_PATH.objdump.functions

cat $FULL_EXEC_PATH.objdump.exports | tr '[' ' ' | tr ']' ' ' | sort -nfs | grep -vE '^$' | paste -d " " - - | awk '{print $4" "$8}' > $FULL_EXEC_PATH.objdump.exports.parseable
