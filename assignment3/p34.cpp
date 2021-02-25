/* Name Surname */

// STL 
#include <iostream>
#include <map>
#include <vector>
#include <set>
#include <utility>

// LLVM 
#include <llvm/Pass.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/CFG.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Constants.h>

// For older versions of llvm you may have to include instead:
// #include "llvm/Support/CFG.h"
// #include <llvm/Support/InstIterator.h>

using namespace llvm;

namespace {

class DefinitionPass  : public FunctionPass {
public:
	static char ID;
	DefinitionPass() : FunctionPass(ID) {}

	virtual void getAnalysisUsage(AnalysisUsage &au) const {
		au.setPreservesAll();
	}

	virtual bool runOnFunction(Function &F) {
		std::set<std::string> uninitialized;
		std::set<std::string> usedWhileUninitialized;
		for (const BasicBlock &b : F) {
			for (const Instruction &i : b) {
				if (isa<AllocaInst>(i)) {
					uninitialized.insert(i.getName().str());
				}
				else if (isa<StoreInst>(i)) {
					uninitialized.erase(i.getOperand(1)->getName().str());
				}
				else {
					for (int j = 0; j < i.getNumOperands(); j++) {
						const Value *v = i.getOperand(j);
						if (uninitialized.find(v->getName().str()) != uninitialized.end())
							usedWhileUninitialized.insert(v->getName().str());
					}
				}
			}
		}
		
		for (const std::string &s : usedWhileUninitialized)
			errs() << s << "\n";
		
	    return false;
	}
};

class FixingPass : public FunctionPass {
public:
	static char ID;
	FixingPass() : FunctionPass(ID){}

	virtual bool runOnFunction(Function &F){
	    return true;
	}
};
} // namespace


char DefinitionPass::ID = 0;
char FixingPass::ID = 1;

// Pass registrations
static RegisterPass<DefinitionPass> X("def-pass", "Reaching definitions pass");
static RegisterPass<FixingPass> Y("fix-pass", "Fixing initialization pass");



