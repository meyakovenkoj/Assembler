all:
	as lab.asm -o lab.o
	ld lab.o -e _main -macosx_version_min 10.14 -o lab -lSystem
	./lab
	echo $?

clean:
	rm -f *.o
