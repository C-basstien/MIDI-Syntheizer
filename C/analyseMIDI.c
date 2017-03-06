#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int cmpr(char* cmd, FILE * F)
{
    if(feof(F)){return -1;}
	int l=strlen(cmd);
	if(l%2){printf("error cmd must have an even number");return 0;}
	int i=0;
	char* buffer=(char*)(malloc(sizeof(char)*l));
	fread (buffer,1,l,F);/*printf("/ buff:%s	/",buffer);*/
	if(feof(F)){return -1;}
	for(i=0;i<l;i++)
	{
		if(cmd[i]!='\0'){if(buffer[i]!=cmd[i]){fseek (F,-l,SEEK_CUR);/*printf("%c,%c.%d/	",buffer[i],cmd[i],i);*/return 0;}}
	}
	return 1;
}
void print_data(int d[2])
{
	int i;
	for (i=0;i<2;i++)
	{
		printf("%02x",d[i]);printf(".");
	}
	printf(" ");
}
int read_midi(char* nom_fichier_midi)
{

    int i;
	FILE * fmidi = fopen(nom_fichier_midi, "r");
	if (fmidi == NULL){perror(nom_fichier_midi);exit(1);}// fichier inexistant
	FILE * fmiditxt=fopen("midi-byte.txt","w");
	if (fmiditxt == NULL){perror("midi-byte.txt");exit(1);}// erreur de création
	FILE * fanalyse=fopen("midi-analyse.txt","w");
	if (fmidi == NULL){perror("midi-byte.txt");exit(1);}// erreur de création
	int data[2];int f=0;for (i=0;i<2;i++){data[i]=0;}
	do
	{
        for (i=0;i<2;i++)
        {
            data[i]=fgetc(fmidi);
            fprintf(fmiditxt,"%02x",data[i]);
        }
		print_data(data);//fprintf(fmiditxt,"\n");
		if(f<5){f++;}
		else{printf("\n");f=0;}

  	}while (!feof(fmidi));
  	fclose(fmidi);
  	fclose(fmiditxt);
  	fclose(fanalyse);
	if (feof(fmidi)) {return 0;}

  	return 1;
}
void clear(char* p,int l)
{
	int i;
	for(i=0;i<l;i++){p[i]='\0';}
}
unsigned int puis(int b, int e)
{
	int i;
	unsigned int res=b;
	if(e==0){return 1;}
	for(i=1;i<e;i++)
	{
		res*=b;
	}
	return res;
}
unsigned int conv(char* s)
{
	unsigned int i=0;
	unsigned int l=strlen(s);
	unsigned int res=0;
	int c;
	for(i=1;i<=l;i++)
	{
	 	if(s[l-i]>='0'&& s[l-i]< 58){c=s[l-i]-'0';}
	 	else if(s[l-i]>=97&& s[l-i]< 103){c=s[l-i]-87;}
		res=res+((c)*pow(16,i-1));
	}
	return res;
}
int read_cmd(char* s,int l,FILE* F,char* r)
{
    clear(r,8);
    fread (r,1,l,F);
    if(cmpr(s,F)==1){return 1;}
    else{fseek (F,-l,SEEK_CUR);return 0;}

}
void find_note(int n)
{
   /* if(n<0||n>=128){printf("Unbound note");}
    else*/
    {
        if(n%12==0){printf("Do %d",n/12 -1);}
        else if(n%12==1){printf("Do# %d",n/12 -1);}
        else if(n%12==2){printf("Ré %d",n/12 -1);}
        else if(n%12==3){printf("Ré# %d",n/12 -1);}
        else if(n%12==4){printf("Mi %d",n/12 -1);}
        else if(n%12==5){printf("Fa %d",n/12 -1);}
        else if(n%12==6){printf("Fa# %d",n/12 -1);}
        else if(n%12==7){printf("Sol %d",n/12 -1);}
        else if(n%12==8){printf("Sol# %d",n/12 -1);}
        else if(n%12==9){printf("La %d",n/12 -1);}
        else if(n%12==10){printf("La# %d",n/12 -1);}
        else if(n%12==11){printf("Si %d",n/12 -1);}
    }
}
int time_calc(char s[4])
{
    //printf("%d%d%d%d",(s[0]-'0'),(s[1]-'0'),(s[2]-'0'),(s[3]-'0'));
    int res=(s[3]-'0');//printf("\n%d",res);
    int r=((s[2]-'0')%8);r+=((s[1]-'0')%2)*8;
    res+=r*16;//printf("+%d*16",r);
    r=((s[1]-'0')>>1);
    r+=((s[0]-'0')%2)*8;
    res+=r*16*16;//printf("+%d*16*16",r);
    r=(s[0]-'0')>>1;
    r%=4;
    res+=r*16*16*16;//printf("+%d*16*16*16",r);
    return res;
}
void read_text(char* s)
{
	int i;
	int c; 
	char t[3];
	t[2]='\0';
	int l=strlen(s);
	printf("%s",s);
	for(i=0;i<l;i+=2)
	{
		t[0]=s[i];t[1]=s[i+1];
		printf("%c",conv(t));
		//printf("%c",c);
	}
	
}
int elseread(char* buffer,FILE * fmiditxt)
{
	int l=0;
	if (read_cmd("ff5804",2,fmiditxt,buffer)==1){l=strlen("ff5804");fseek (fmiditxt,-l-2,SEEK_CUR);clear(buffer,8);return 0;}
	if (read_cmd("ff5103",2,fmiditxt,buffer)==1){l=strlen("ff5103");fseek (fmiditxt,-l-2,SEEK_CUR);clear(buffer,8);return 0;}
	if (read_cmd("ff03",2,fmiditxt,buffer)==1){l=strlen("ff03");fseek (fmiditxt,-l-2,SEEK_CUR);clear(buffer,8);return 0;}
	if (read_cmd("90",2,fmiditxt,buffer)==1){l=strlen("90");fseek (fmiditxt,-l-2,SEEK_CUR);clear(buffer,8);return 0;}
	if (read_cmd("80",4,fmiditxt,buffer)==1){l=strlen("80");fseek (fmiditxt,-l-4,SEEK_CUR);clear(buffer,8);return 0;}
	if((cmpr("4d54726b",fmiditxt))==1){l=strlen("4d54726b");fseek (fmiditxt,-l,SEEK_CUR);clear(buffer,8);return 0;}
	return 1;
}
void analyse (void)
{
    FILE * fmiditxt=fopen("midi-byte.txt","r");
    rewind(fmiditxt);
    int t=0;
    int ntrk=0;
    int l;
    char* buffer=(char*)(malloc(sizeof(char)*8));clear(buffer,8);
    if (buffer == NULL) {fputs ("Memory error",stderr); exit (1);}
    printf("\n\n////analyse:////\n\n");
    while(!(feof(fmiditxt)) && !ferror(fmiditxt))
    {
       	if((t=cmpr("4d546864",fmiditxt))==1)
        {
            printf("\033[34m[Header chunk]\033[0m\n");
            fread (buffer,1,8,fmiditxt);
            printf("\033[33m[%d information byte]\033[0m\n",conv(buffer));clear(buffer,8);
            fread (buffer,1,4,fmiditxt);
            printf("\033[33m[MIDI type:%d]\033[0m\n",conv(buffer));clear(buffer,8);
            fread (buffer,1,4,fmiditxt);
            printf("\033[33m[%d Truck chunk]\033[0m\n",conv(buffer));clear(buffer,8);
            fread (buffer,1,4,fmiditxt);
            printf("\033[33m[Quater note length:%d]\033[0m",conv(buffer));clear(buffer,8);
            printf("\n");
        }
        else if (t==-1){break;}
        if((t=cmpr("4d54726b",fmiditxt))==1)
        {
            ntrk++;
            printf("\033[34m[Truck chunk %d]\033[0m\n",ntrk);
		    fread (buffer,1,8,fmiditxt);
            printf("\033[33m[%d information byte]\033[0m\n",conv(buffer));clear(buffer,8);
            while(!(cmpr("ff2f",fmiditxt))==1)
            {
                if (read_cmd("ff5804",2,fmiditxt,buffer))
                {
                    printf("[Time Signature time:");clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);
                    printf("%d/",conv(buffer));
                    fread (buffer,1,2,fmiditxt);
                    printf("%d ",(int)pow(2,conv(buffer)));
                    fread (buffer,1,2,fmiditxt);
                    printf("%d MIDI Clk",conv(buffer));
                    fread (buffer,1,2,fmiditxt);
                    printf("(%d 1/32 notes)/(24 MIDI Clk)]\n",conv(buffer));
                }
                if (read_cmd("ff5103",2,fmiditxt,buffer))
                {
                    printf("[Tempo:\n");
                    fread (buffer,1,6,fmiditxt);
                    printf("[%dµs by quater note]\n",conv(buffer));
                }
                if (read_cmd("ff03",2,fmiditxt,buffer))
                {
                    printf("[Text:");
                    fread (buffer,1,2,fmiditxt);
                    l=conv(buffer);
                    clear(buffer,8);
                    fread (buffer,1,l*2,fmiditxt);
                    read_text(buffer);
                    printf("]");
                }
                if (read_cmd("90",2,fmiditxt,buffer))
                {
                    printf("[Note On time:%s ",buffer);clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);find_note(conv(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);printf(" velocity %d]\n",conv(buffer));clear(buffer,8);
                }
                if (read_cmd("80",4,fmiditxt,buffer))
                {
                    printf("[Note Off time:%d ",time_calc(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);find_note(conv(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);printf(" velocity %d]\n",conv(buffer));clear(buffer,8);
                }
                if(elseread(buffer,fmiditxt))
                {
                	fread (buffer,1,2,fmiditxt);
                	printf("acv:%s\n",buffer);
                	clear(buffer,8);
                }
                //
                //
                //
            }
            printf("\033[34m[End of Truck chunk %d]\033[0m",ntrk);
            printf("\n");
        }
        else if (t==-1){break;}
        clear(buffer,8);fread (buffer,1,2,fmiditxt); printf("%s",buffer);clear(buffer,8);
    }
    printf("\n\n////fin de l'analyse:////\n\n");
	fclose(fmiditxt);


}
int main(int ac, char**av)
{
	  /*On verifie que le programme est lance  avec un nom de fichier
	*/
  	if (ac !=2  || av[1]==NULL )
	{
		printf("Usage : %s fichier_midi_entree \n",av[0]); exit(1);
	}
	/* Lecture de l'image, des nombres de lignes et colonnes */
  	int res=read_midi(av[1]);
  	if (res) { printf("Lecture midi %s Impossible\n",av[1]); exit(1); }
  	analyse();
  	

  	//printf("\n %d \n",conv("ff"));

  	return EXIT_SUCCESS;
}
