CC = gcc
CFLAGS = -Wall -Wextra
TARGET = diary

all: $(TARGET) 

$(TARGET): memo.o calendar.o main.o
	$(CC) -o $@ $^

memo.o: memo.c
	$(CC) $(CFLAGS) -c -o $@ $^

calendar.o: calendar.c
	$(CC) $(CFLAGS) -c -o $@ $^

main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $^

clean:
	$(RM) *.o $(TARGET)
