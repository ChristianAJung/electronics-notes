# set the offset for the jump
ld r8, 0xc
# try to load some immediate (upper 16bit)
ldu r11, 0xa5a5
# (and lower)
ld r13, 0xff
# try to multiply something
mul r11, r13
# now load from memory
ld r9, [r0 + 0x24]
# try to push
push r9
ld r1, 0x7
ld r10, 0x18
jrrl r10
# JUMP to halt
jrrl r8, r12
nop
nop
nop
# STOP THE CPU
hl
# this is loaded above
.word 0x01020304

# function
# calling convention: r1, r2, r3, r4 argument, r5 return value
ld r5, 0x2
mul r1, r5
jr r15
