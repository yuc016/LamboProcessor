// Date: 8/24/2020
// This file defines the parameters used in the ALU
package definitions;
    
// Instruction map
const logic [2:0]_CMP     = 3'b000;
const logic [2:0]_BRANCH  = 3'b001;
const logic [2:0]_LOAD    = 3'b010;
const logic [2:0]_STORE   = 3'b011;
const logic [2:0]_XOR     = 3'b100;
const logic [2:0]_ADD     = 3'b101;
const logic [2:0]_SUB     = 3'b110;
const logic [2:0]_LSHIFT  = 3'b111;

typedef enum logic[2:0] {
    CMP, BRANCH, LDR, STR, XOR,
    ADD, SUB, LSHIFT } op_mne;
endpackage
