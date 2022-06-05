inputs	= $(wildcard *.asm)
objects	= $(patsubst %.asm,%.o,$(inputs))
outputs	= $(patsubst %.asm,%,$(inputs))

all: $(outputs)

clean:
	$(RM) $(objects) $(outputs)

%.o: %.asm
	nasm -f elf64 -F dwarf  $^

%: %.o
	cc -o $@ $^