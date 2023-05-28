CC         = nim c
CFLAGS     =
TARGET     = render
SRC        = main.nim
# these are for just watching when they are updated
REQUISITES = 

$(TARGET): $(SRC) $(REQUISITES)
	$(CC) -d:danger --opt:speed -o=$@ $(SRC)

$(RUN):
	./$(TARGET)

all: clean $(TARGET) run

run:
	-./$(TARGET)

clean:
	-rm $(TARGET) 