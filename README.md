# Stellar Exception Translator automation tooling

This repo contains the automation scripts and other data used to create analysis of stellaris executables and build the database used by the StellarStellaris Exception translator.

## Analysis

Tools used for the initial analysis and creation of data.

### create_objdump_data.sh
Runs objdump on executable to build exports and function table.

### ghidra_dump_addresses.py
Ghidra script to dump all function addresses and symbols

### ghidra_make_signatures.py
Ghidra script to dump rudimentary function signatures (used by capstone code)


## Load

### postgres_load_fn2hash.py
Loads data from fn2hash.csv (generated by CMU Pharos Ghidra fn2hash tools) into the database

### postgres_load_func_addr.py
Loads data from func_addr.txt (generated by ghidra_dump_addresses.py) into the database

### postgres_load_objdump_function.py
Loads data from objdump into the database

## Export

### postgres_dump_fn2hash_compare.py
Builds an export CSV that correlates as many functions as possible between two versions

## Other

### stellar-fnaddr.sql
Database schema for current DB.
