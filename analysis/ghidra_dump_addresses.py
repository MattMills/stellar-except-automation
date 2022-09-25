#Dump an address list of all functions
#@author Matt Mills
#@category _stellar-ghidra
#@keybinding 
#@menupath 
#@toolbar 

import ghidra.program.model.lang.OperandType as OperandType
import ghidra.program.model.lang.Register as Register

if __name__ == "__main__":
	fm = currentProgram.getFunctionManager()
	fn_list = fm.getFunctions(toAddr(0x0), True)
	cm = currentProgram.getCodeManager()

	with open('func_addr.txt', 'w') as fh:
		for fn in fn_list:
			#if(fn.getName(True)[0:1] != "C"):
			#	continue
			fh.write("%s###%s###%s\n" % 
				(fn.getEntryPoint(), fn.getName(True), fn.getPrototypeString(True, True)))

