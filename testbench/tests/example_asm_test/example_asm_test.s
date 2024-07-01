// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Western Digital Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// Assembly code for Hello World
// Not using only ALU ops for creating the string


#include "defines.h"

#define STDOUT 0xd0580000


// Code to execute
.section .text
.global _start
_start:

.option norvc

    // Clear minstret
    csrw minstret, zero
    csrw minstreth, zero

    // Set up MTVEC - not expecting to use it though
    li x1, RV_ICCM_SADR
    csrw mtvec, x1


    // Enable Caches in MRAC
    li x1, 0x5f555555
    csrw 0x7c0, x1

    // writing test cases here


    li a1, 0x1
    li a2, 0x2
//    mul a0, a1, a2
    bge a2, a1, pass

    // Load string from hw_fail_pass_data
    // and write to stdout address
    li x3, STDOUT
    la x4, hw_fail_data
    j _finish

pass:
    // Load string from hw_pass_data
    // and write to stdout address

    li x3, STDOUT
    la x4, hw_pass_data



// Write 0xff to STDOUT for TB to terminate test.
_finish:
    loop:
     lb x5, 0(x4)
     sb x5, 0(x3)
     addi x4, x4, 1
     bnez x5, loop
    li x3, STDOUT
    addi x5, x0, 0xff
    sb x5, 0(x3)
    beq x0, x0, _finish
.rept 100
    nop
.endr

.global hw_pass_data
.data
hw_pass_data:
.ascii "--------------------------------------------------------------------------\n"
.ascii "          TEST PASSED                                                     \n"
.ascii "--------------------------------------------------------------------------\n"
.byte 0


.global hw_fail_data
.data
hw_fail_data:
.ascii "--------------------------------------------------------------------------\n"
.ascii "          TEST FAILED                                                     \n"
.ascii "--------------------------------------------------------------------------\n"
.byte 0