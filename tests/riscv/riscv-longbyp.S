//=========================================================================
// riscv-longbyp.S
//=========================================================================

#include "riscv-macros.h"

    TEST_RISCV_BEGIN

    // Should need to stall to bypass properly from X3 stage

    TEST_RR_DEST_BYP( 0 , mul, 67, 9, 603)
    TEST_RR_DEST_BYP( 1 , mul, 68, 8, 544)
    TEST_RR_DEST_BYP( 2 , mul, 69, 7, 483)
    TEST_RR_DEST_BYP( 3 , mul, 70, 6, 420)
    TEST_RR_DEST_BYP( 4 , mul, 71, 5, 355)
    TEST_RR_DEST_BYP( 5 , mul, 72, 4, 288)

    // Shouldn't need to stall: should bypass immediately

    TEST_RR_DEST_BYP( 0 , add, 67, 10, 77)
    TEST_RR_DEST_BYP( 1 , add, 68, 20, 88)
    TEST_RR_DEST_BYP( 2 , add, 69, 30, 99)
    TEST_RR_DEST_BYP( 3 , add, 70, 40, 110)
    TEST_RR_DEST_BYP( 4 , add, 71, 50, 121)
    TEST_RR_DEST_BYP( 5 , add, 72, 60, 132)

    // Test that multiply pipeline properly fits multiple insts in at once

    li x4, 4
    li x5, 5
    li x6, 6
    li x7, 7
    mul x4, x4, x4
    mul x5, x5, x5
    mul x6, x6, x6
    mul x7, x7, x7
    TEST_CHECK_EQ(x4, 16)
    TEST_CHECK_EQ(x5, 25)
    TEST_CHECK_EQ(x6, 36)
    TEST_CHECK_EQ(x7, 49)

    // Interspersed multiplys

    li x4, 4
    li x5, 5
    li x6, 6
    li x7, 7
    mul x4, x4, x4
    add x5, x5, x5
    mul x6, x6, x6
    mul x7, x7, x7
    TEST_CHECK_EQ(x4, 16)
    TEST_CHECK_EQ(x5, 10)
    TEST_CHECK_EQ(x6, 36)
    TEST_CHECK_EQ(x7, 49)

    li x4, 4
    li x5, 5
    li x6, 6
    li x7, 7
    mul x4, x4, x4
    add x5, x5, x5
    add x6, x6, x6
    mul x7, x7, x7
    TEST_CHECK_EQ(x4, 16)
    TEST_CHECK_EQ(x5, 10)
    TEST_CHECK_EQ(x6, 12)
    TEST_CHECK_EQ(x7, 49)

    li x4, 4
    li x5, 5
    li x6, 6
    li x7, 7
    mul x4, x4, x4
    div x5, x5, x5
    mul x6, x6, x6
    div x7, x7, x7
    TEST_CHECK_EQ(x4, 16)
    TEST_CHECK_EQ(x5, 1)
    TEST_CHECK_EQ(x6, 36)
    TEST_CHECK_EQ(x7, 1)

    // With dependencies: must wait until pipeline finishes

    li x4, 4
    li x5, 32
    li x6, 6
    li x7, 7
    mul x4, x4, x4
    div x5, x5, x4
    mul x6, x5, x6
    rem x7, x6, x7
    TEST_CHECK_EQ(x4, 16)
    TEST_CHECK_EQ(x5, 2)
    TEST_CHECK_EQ(x6, 12)
    TEST_CHECK_EQ(x7, 5)
    
    TEST_RISCV_END