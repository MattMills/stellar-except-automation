from ghidra.app.script import GhidraScript
from ghidra.app.plugin.core.analysis import PdbAnalyzer


args = getScriptArgs()
print('GHIDRA PRESCRIPT')
print('GHIDRA PRESCRIPT - GOT ARGS %s' % (args,))

if len(args) == 1:
    setAnalysisOption(currentProgram, "PDB Universal", "false")
    setAnalysisOption(currentProgram, "PDB MSDIA", "true")
    pdb_file = java.io.File(args[0])
    PdbAnalyzer.setPdbFileOption(currentProgram, pdb_file)
