#include "midi_read.h"
void clear(char* p,int l)
{
	int i;
	for(i=0;i<l;i++){p[i]='\0';}
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
void print_note_noscale(int n)
{

        if(n%12==0){printf("Do");}else if(n%12==1){printf("Do#");}
        else if(n%12==2){printf("Ré");}else if(n%12==3){printf("Ré#");}
        else if(n%12==4){printf("Mi");}else if(n%12==5){printf("Fa");}
        else if(n%12==6){printf("Fa#");}else if(n%12==7){printf("Sol");}
        else if(n%12==8){printf("Sol#");}else if(n%12==9){printf("La");}
        else if(n%12==10){printf("La#");}else if(n%12==11){printf("Si");}
}
unsigned int get_time(char s[4],FILE* F)
{
    clear(s,8);
    unsigned int cont=1;unsigned int res=0;unsigned int i,r;r=0;i=0;
    while(cont==1 && i <6)
    {
        fread (s,1,2,F);r=conv(s);
        if(r>127){cont=1;}else{cont=0;}
        res*=128;
        res+=(r%128);
        i++;clear(s,8);
    }
    return res;
}
/*int time_calc(char s[4])
{
    int res=(s[3]-'0');
    int r=((s[2]-'0')%8);r+=((s[1]-'0')%2)*8;
    res+=r*16;r=((s[1]-'0')>>1);
    r+=((s[0]-'0')%2)*8;
    res+=r*16*16;
    r=(s[0]-'0')>>1;
    r%=4;
    res+=r*16*16*16;return res;
}*/
int cmpr(char* cmd, FILE * F)
{
    if(feof(F)){return -1;}
	int l=strlen(cmd);
	int i=0;
	char* buffer=(char*)(malloc(sizeof(char)*l));
	fread (buffer,1,l,F);
	if(feof(F)){return -1;}
	for(i=0;i<l;i++){{if(buffer[i]!=cmd[i]){fseek (F,-l,SEEK_CUR);return 0;}}}return 1;
}
int read_cmd(char* s,int l,FILE* F,char* r)
{
    clear(r,8);
    fread (r,1,l,F);
    if(cmpr(s,F)==1){return 1;}
    else{fseek (F,-l,SEEK_CUR);return 0;}

}
void read_text(FILE* F,int l)
{
	int i;
	char t[2];
	t[0]='\0';t[1]='\0';
	for(i=0;i<l;i++)
	{
		fread (t,1,2,F);
		printf("%c",conv(t));
	}
}
