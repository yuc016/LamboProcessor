Team members: Yuyong Chen, Jie Wang

Introduction:
    About Lambo architecture: 
        The Lambo architecture is a simple and easy to code, highly efficient architecture 
        that uses 9-bit encoded instructions. It supports 6 general purpose registers, 
        2 less general registers for specialized usage in encryption software, and a few internal 
        registers for flagging. 8 addressable registers allow for reduced memory interactions 
        for performance. There are 12 different instructions specified with also 3 bits, 
        fully capable of building small programs.


Instruction Formats:
    RR-type:
        Instructions that process two registers, each expressed in 3 bits.
        Example: <ADD r1, r2>, <STR r1, [r3]>
    RC-type:
        Instructions that process one register and one constant, each expressed in 3 bits
        Example: <LSL r3, #5>
    R-type:
        Instructions that process one register, expressed in 3 bits
        Example: <RDX r1>
    B-type:
        Branch instructions, with target within [-15, 15] from current PC
        Example: <BEQ 'label'>
    S-type:
        Instructions that does not take arguments.
        Example: <HALT>, <SHIFT>

Operations:
    Instruction - Opcode 
        Format Type
        Usage
        Description

    Compare - 000
        RR
        CMP ra, rb
        Compare register a and b and set the "is >=" condition flag
    
    Branch - 0010/0011
        B
        B/BGE #offset
        Branch to address with offset [-15, 15], option of looking at condition flag
    
    Load registr - 010
        RR
        LDR ra, [rb]
        Load value from memory address *rb into ra and increment rb by 1
    
    Store register - 011
        RR
        STR ra, [rb]
        Store value from ra into memory address *rb and increment rb by 1

    Xor registers - 100
        RR
        XOR ra, rb
        Xor register a and b and store the result to a

    Add registers - 101
        RR
        ADD ra, rb
        Add value of register a and b and store the result to a

    Subtract registers - 110
        RR
        SUB ra, rb
        Subtract value of register b from a and store the result to a
    
    Logical left shift - 111
        RC
        LSL ra, #shift_amount
        Logical left shift register a by shift_amount

    Halting - 001110000
        S
        HALT
        Halts the Machine

    LFSR Shift - 001010000
        S
        SHIFT
        Shift lfsr register (r7) with tap in tap register (r6)

    Reduction XOR - 111110
        R
        RO ra
        Xor every bit of register a and store the result to least significant bit of a

    Set register - 111111
        R
        MOV ra, #value
        Set the value of the specified register with value placed the next machine instruction 

    Inc register - 000111
        R
        Inc ra
        Increment the value of the specified register by 1


Internal Operands:
    8 registers are supported (r1-r8)
    special register r7 stores LFSR tap pattern, LSL not supported
    special register r8 stores LFSR, LSL not supported

Control Flow:
    2 types of branches are supported: branch always & branch greater than or equal to
    target address calculated by adding offset value (2's complement) to the current address 
    Branch range [-15, 15]

Addressing Mode:
    register stores pointer to memory address, e.g. [ra] = memory[ra]

Machine Classification:
    reg-reg & load-store 

Assembly Example:

  Assembly:
    d:
        LDR r4, [r1]                   
        MOV r5, #4                      
        LSL r5, #3                      
        SUB r4, r5            
        XOR r4, r7             
        RDX r5                       
        SHIFT!               
        CMP r3, r1                    
        BGE d   
        HALT    
        
  Machine code:
    010100001
    111111101
    000000100
    111101011
    110100101
    100100111
    111110101
    001010000
    000011001
    001111000
    001110000


|------------Quick Reference-------------|
|Regular 3-bit map:                      |
|    000 CMP reg, reg                    |
|    0010 B                              |
|    0011 BGE                            |
|    010 LDR reg, [reg]                  |
|    011 STR reg, [reg]                  |
|    100 XOR reg, reg                    |
|    101 ADD reg, reg                    |
|    110 SUB reg, reg                    |
|    111 LSL reg, #constant              |
|                                        |
|Special case:                           |
|    (001)010000  SHIFT                  |
|    (001)110000  HALT                   |
|    (111)110    RDX reg                 |
|    (000)111    Inc reg                 |
|                                        |
|Special operation:                      |
|    (111)111 followed by XXXXXXXXX      |
|    MOV reg                             |
|------------Quick Reference-------------|


MOV r2, #128
111111001
000100000
