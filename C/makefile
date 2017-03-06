CFLAGS= -W -Wall -g -c -I -02
LDFLAGS=-L

all: analyseMIDI


analyseMIDI :midi_opener.o analysis_midi.o calc_utility.o
	gcc -o $@  $^  $(LFLAGS)-lm
	rm -f *.o

midi_opener.o :  midi_opener.c midi_read.h
	gcc $(CFLAGS) midi_opener.c -lm
clean :
	@rm *.o
cleaner : clean
	@rm $(EXEC)
