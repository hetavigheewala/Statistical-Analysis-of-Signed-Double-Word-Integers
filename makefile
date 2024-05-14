# CS 218 Assignment #4
# Simple make file for asst #4

OBJS	= Statistical-Analysis-of-Signed-Double-Word-Integers.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: Statistical-Analysis-of-Signed-Double-Word-Integers

Statistical-Analysis-of-Signed-Double-Word-Integers.o: Statistical-Analysis-of-Signed-Double-Word-Integers.asm 
	$(ASM) Statistical-Analysis-of-Signed-Double-Word-Integers.asm -l Statistical-Analysis-of-Signed-Double-Word-Integers.lst

Statistical-Analysis-of-Signed-Double-Word-Integers: Statistical-Analysis-of-Signed-Double-Word-Integers.o
	$(LD) -o Statistical-Analysis-of-Signed-Double-Word-Integers $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm	Statistical-Analysis-of-Signed-Double-Word-Integers.lst
