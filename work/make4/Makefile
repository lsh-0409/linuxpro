OBJECTS = memo.o calendar.o main.o
CFLAGS = -Wall -Wextra
TARGET = diary

all: $(TARGET) 

$(TARGET): $(OBJECTS)
	$(CC) -o $@ $^
clean:
	$(RM) *.o $(TARGET)
