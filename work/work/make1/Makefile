all: diary 

diary: memo.o calendar.o main.o
	gcc -o diary memo.o calendar.o main.o

memo.o: memo.c
	gcc -Wall -Wextra -c -o memo.o memo.c

calendar.o: calendar.c
	gcc -Wall -Wextra -c -o calendar.o calendar.c

main.o: main.c
	gcc -Wall -Wextra -c -o main.o main.c

clean:
	rm -rf *.o diary
