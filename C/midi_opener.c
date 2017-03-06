#include "midi_read.h"
void print_data(int d[2]){int i;for (i=0;i<2;i++){printf("%02x",d[i]);printf(".");}printf(" ");}
int read_midi(char* nom_fichier_midi)
{

    int i;
	FILE * fmidi = fopen(nom_fichier_midi, "r");if (fmidi == NULL){perror(nom_fichier_midi);exit(1);}// fichier inexistant
	FILE * fmiditxt=fopen("midi-byte.txt","w");if (fmiditxt == NULL){perror("midi-byte.txt");exit(1);}// erreur de création
	FILE * fanalyse=fopen("midi-analyse.txt","w");if (fmidi == NULL){perror("midi-byte.txt");exit(1);}// erreur de création
	int data[2];for (i=0;i<2;i++){data[i]=0;}
	do
	{
        for (i=0;i<2;i++){data[i]=fgetc(fmidi);fprintf(fmiditxt,"%02x",data[i]);bn++;}//print_data(data);/*fprintf(fmiditxt,"\n");*/
  	}while (!feof(fmidi));
  	fclose(fmidi);fclose(fmiditxt);fclose(fanalyse);
  	if(feof(fmidi)) {return 0;}return 1;
}
int main(int ac, char**av)
{
  	if (ac !=2  || av[1]==NULL ){printf("Usage : %s fichier_midi_entree \n",av[0]); exit(1);}
  	int res=read_midi(av[1]);printf("\n%u byte to analyse\n",bn);bn=0;
  	if (res) { printf("Lecture midi %s Impossible\n",av[1]); exit(1); }
  	analyse();printf("\n%u byte not analysed\n",bn);
  	return EXIT_SUCCESS;
}
