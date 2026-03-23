//=========================================================================
// riscv-waw.S
//=========================================================================

#include "riscv-macros.h"

    TEST_RISCV_BEGIN

    li x3, 4
    TEST_INSERT_NOPS(1) // for alignment
    addi x2, x3, 4
    addi x2, x3, 5
    add x4, x0, x2
    TEST_CHECK_EQ(x4, 9)
    TEST_CHECK_EQ(x2, 9)
    TEST_INSERT_NOPS(1) // for alignment


    addi x2, x3, 4
    mul x2, x3, x3
    add x4, x0, x2
    TEST_CHECK_EQ(x4, 16)
    TEST_CHECK_EQ(x2, 16)
    TEST_INSERT_NOPS(1) // for alignment

    mul x2, x3, x3
    addi x2, x3, 4
    add x4, x0, x2
    TEST_CHECK_EQ(x4, 8)
    TEST_CHECK_EQ(x2, 8)


    la    x4, tdata_0    
    la    x5, tdata_1
    lw x2, 0(x5)
    lw x2, 0(x4)
    add x8, x0, x2
    TEST_CHECK_EQ(x8, 0x000000ff)
    TEST_CHECK_EQ(x2, 0x000000ff)
    TEST_INSERT_NOPS(1) // for alignment

    lw x2, 0(x5)
    addi x2, x3, 4
    add x8, x0, x2
    TEST_CHECK_EQ(x8, 8)
    TEST_CHECK_EQ(x2, 8)
    TEST_INSERT_NOPS(1) // for alignment

    addi x2, x3, 4
    lw x2, 0(x5)
    add x8, x0, x2
    TEST_CHECK_EQ(x8, 0x00007f00)
    TEST_CHECK_EQ(x2, 0x00007f00)


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