#ifndef MIDI_H
#define MIDI_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#ifdef __cplusplus
extern "C" {
#endif


/**midi_opener.c**/


void print_data(int d[2]);
int read_midi(char* nom_fichier_midi);


/**calc_utilit**/

void read_text(FILE* F,int l);
int cmpr(char* cmd, FILE * F);
unsigned int get_time(char s[4],FILE* F);
int time_calc(char s[4]);
void find_note(int n);
void print_note_noscale(int n);
unsigned int conv(char* s);
void clear(char* p,int l);


/**analysis_midi**/
void analyse (void);
extern unsigned int bn;
#ifdef __cplusplus
}
#endif
#endif /*MIDI_H*/
