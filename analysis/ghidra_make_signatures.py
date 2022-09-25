#Generate function signatures
#@author Matt Mills
#@category _stellar-ghidra
#@keybinding 
#@menupath 
#@toolbar 

import ghidra.program.model.lang.OperandType as OperandType
import ghidra.program.model.lang.Register as Register
import gzip

def uniqueSig(bs):
	"""
	Returns true if only one result containing the pattern was found.
	"""
	result = findBytes(None, bs, 2)
	return len(result) == 1

def dumpOperandInfo(ins, op):
	t = hex(ins.getOperandType(op))
	print('  ' + str(ins.getPrototype().getOperandValueMask(op)) + ' ' + str(t))
	
	# TODO if register
	for opobj in ins.getOpObjects(op):
		print('  - ' + str(opobj))

def shouldMaskOperand(ins, opIndex):
	optype = ins.getOperandType(opIndex)
	# if any(reg.getName() == "EBP" for reg in filter(lambda op: isinstance(op, Register), ins.getOpObjects(opIndex))):
		# return False
	return optype & OperandType.DYNAMIC or optype & OperandType.ADDRESS

def getMaskedInstruction(ins):
	"""
	Returns a generator that outputs either a byte to match or None if the byte should be masked.
	"""
	# print(ins)
	
	# resulting mask should match the instruction length
	mask = [0] * ins.length
	
	proto = ins.getPrototype()
	# iterate over operands and mask bytes
	for op in range(proto.getNumOperands()):
		# dumpOperandInfo(ins, op)
		
		# TODO deal with partial byte masks
		if shouldMaskOperand(ins, op):
			mask = [ m | v & 0xFF for m, v in zip(mask, proto.getOperandValueMask(op).getBytes()) ]
	# print('  ' + str(mask))
	
	# return None if the byte should be masked, else yield the byte
	# TODO improve this logic
	for m, b in zip(mask, ins.getBytes()):
		if m == 0xFF:
			yield  b & 0xFF#None
		else:
			yield b & 0xFF

if __name__ == "__main__":
    fm = currentProgram.getFunctionManager()
    fn = fm.getFunctionContaining(currentAddress)
    fn_list = fm.getFunctionsNoStubs(toAddr(0x0), True)
    cm = currentProgram.getCodeManager()
    
    with gzip.open('func_sigs.txt.gz', 'w') as fh:
        for fn in fn_list:
            #if(fn.getName(True)[0:1] != "C"):
            #	continue
            ins = cm.getInstructionAt(fn.getEntryPoint())

            pattern = "" # contains pattern string (supports regular expressions)
            byte_pattern = [] # contains integers 0x00 to 0xFF, or None if the byte was masked
            
            found = True

            i = 0
            while i < 50 and ins != None and fm.getFunctionContaining(ins.getAddress()) == fn:
                i += 1
                for entry in getMaskedInstruction(ins):
                    pattern += r'\x{:02x}'.format(entry)
                    byte_pattern.append(entry)
                ins = ins.getNext()
            
        
            if not found:
                #print(" ".join('{:02X}'.format(b) if b is not None else '?' for b in byte_pattern))
                raise Exception("Could not find unique signature")
                #print(fn.getName(True) + " no_unique_sig")
                #continue
            else:
                fh.write(fn.getName(True) + " ### " + " ".join('{:02X}'.format(b) if b is not None else '?' for b in byte_pattern) + "\n")
                #print("".join(r'\x{:02X}'.format(b) if b is not None else r'\x2A' for b in byte_pattern))

