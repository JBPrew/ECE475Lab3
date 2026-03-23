//=========================================================================
// riscv-nonALU.S
//=========================================================================

#include "riscv-macros.h"

    TEST_RISCV_BEGIN


    // Test that simultaneous non ALU instructions are handled properly

    li x4, 4
    li x5, 5
    beq x4, x5, TESTFAIL
    bne x4, x5, TEST2

    TEST_CHECK_FAIL
    TEST_INSERT_NOPS(4)


TEST2:
    li x4, 4
    li x7, 0
    beq x4, x4, TEST3
    li x7, 1                 

    TEST_INSERT_NOPS(4)

TEST3:
    TEST_CHECK_EQ(x7, 0) // Test that 2nd instruction gets squashed after branch
    li x6, 16
    mul x5, x4, x4 // 16
    bne x5, x6, TESTFAIL 

    la    x4, tdata_0    
    la    x5, tdata_1
    lw x6, 0(x4)
    lw x7, 0(x5)
    TEST_CHECK_EQ(x6, 0x000000ff)
    TEST_CHECK_EQ(x7, 0x00007f00)

    li x6, 0xdeadbeef
    li x7, 1
    li x8, 2
    TEST_INSERT_NOPS(1)             // For alignment
    sw x6, 0(x4) 
    lw x7, 0(x4)                    // Test load after store and store after load
    sw x7, 0(x5)
    lw x8, 0(x5)
    TEST_CHECK_EQ(x7, 0xdeadbeef)
    TEST_CHECK_EQ(x8, 0xdeadbeef)

    beq x0, x0, TESTPASS

TESTFAIL:
    TEST_CHECK_FAIL

TESTPASS:
    TEST_RISCV_END

        //-----------------------------------------------------------------
        // Test data
        //-----------------------------------------------------------------

        .section .data
        .align 4

tdata_0:  .word 0x000000ff
tdata_1:  .word 0x00007f00
tdata_2:  .word 0x00000ff0
tdata_3:  .word 0x0000700f