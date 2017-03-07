#include "midi_read.h"
unsigned int bn;//byte number
void analyse (void)
{
    FILE * fmiditxt=fopen("midi-byte.txt","r");rewind(fmiditxt);
    int t=0;int ntrk=0;
    char* buffer=(char*)(malloc(sizeof(char)*8));clear(buffer,8);
    if (buffer == NULL) {fputs ("Memory error",stderr); exit (1);}
    printf("\n\n////analyse:////\n\n");
    while(!(feof(fmiditxt)) && !ferror(fmiditxt))
    {
       	if((t=cmpr("4d546864",fmiditxt))==1)
        {/*identifier=Header chunck*/
            printf("\033[34m[Header chunk]\033[0m\n");
            fread (buffer,1,8,fmiditxt);/*MThd len in bytes  after this*/
            printf("\033[33m[%d information byte]\033[0m\n",conv(buffer));clear(buffer,8);/*always 6 bytes of information normally */
            fread (buffer,1,4,fmiditxt);
            printf("\033[33m[MIDI type:%d]\033[0m\n",conv(buffer));clear(buffer,8);
            fread (buffer,1,4,fmiditxt);
            printf("\033[33m[%d Truck chunk]\033[0m\n",conv(buffer));clear(buffer,8);
            fread (buffer,1,4,fmiditxt);
            printf("\033[33m[Quater note length:%d]\033[0m",conv(buffer));clear(buffer,8);
            printf("\n");
        }else if (t==-1){break;}
        if((t=cmpr("4d54726b",fmiditxt))==1)
        {/*identifier=Track chunck*/
            ntrk++;
            printf("\033[34m[Track chunk %d]\033[0m\n",ntrk);
		    fread (buffer,1,8,fmiditxt);/*MTrk len in bytes  after this*/
            printf("\033[33m[%d information byte]\033[0m\n",conv(buffer));clear(buffer,8);
            while(!(cmpr("ff2f00",fmiditxt))==1)
            {
                if (read_cmd("ff5804",2,fmiditxt,buffer))
                {
                    printf("[Time Signature");
                    fread (buffer,1,2,fmiditxt);
                    printf("%d/",conv(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);
                    printf("%d ",(int)pow(2,conv(buffer)));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);
                    printf("%d MIDI Clk",conv(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);
                    printf("(%d 1/32 notes)/(24 MIDI Clk)]\n",conv(buffer));clear(buffer,8);
                }
                else if (read_cmd("ff5103",2,fmiditxt,buffer))
                {
                    printf("[Tempo:");
                    fread (buffer,1,6,fmiditxt);
                    printf("%dµs by quater note]\n",conv(buffer));clear(buffer,8);
                }
		else if (read_cmd("ff5902",2,fmiditxt,buffer))
		{
			/**Key Signature**/
		}    
		else if (read_cmd("ff5902",2,fmiditxt,buffer))
		{
			/** SMTPE Offset*/
		}
		else if (read_cmd("ff0002",2,fmiditxt,buffer))
		{
			/**Sequence Number**/	
		}
		else if (read_cmd("ff01",2,fmiditxt,buffer))
		{
		    printf("[Text:");
                    fread (buffer,1,2,fmiditxt);
                    l=conv(buffer);
                    clear(buffer,8);
                    fread (buffer,1,l*2,fmiditxt);
                    read_text(buffer);
                    printf("]");	
		}
		else if (read_cmd("ff02",2,fmiditxt,buffer))
		{
			/**Copyright**/	
		}
		else if (read_cmd("ff03",2,fmiditxt,buffer))
		{
			/**Sequence/Track Name**/	
		}
		else if (read_cmd("ff04",2,fmiditxt,buffer))
		{
			/**Instrument Name **/	
		}
		else if (read_cmd("ff05",2,fmiditxt,buffer))
		{
			/**Lyric**/	
		}
		else if (read_cmd("ff06",2,fmiditxt,buffer))
		{
			/**Marker**/	
		}
		else if (read_cmd("ff07",2,fmiditxt,buffer))
		{
			/**Cue Point **/	
		else if (read_cmd("ff2001cc",2,fmiditxt,buffer))
		{
			/**Channel**/	
		}
		else if (read_cmd("ff5405",2,fmiditxt,buffer))
		{
			/**starting point**/	
		}
		else if (read_cmd("ff7f",2,fmiditxt,buffer))
		{
			/**Sequencer-Specific Meta-event**/
		}
                else if (read_cmd("90",2,fmiditxt,buffer))
                {
                    printf("[Note On ");clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);find_note(conv(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);printf(" velocity %d]\n",conv(buffer));clear(buffer,8);
                }
                else if (read_cmd("80",4,fmiditxt,buffer))
                {
                    printf("[Note Off time:%d ",time_calc(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);find_note(conv(buffer));clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);printf(" velocity %d]\n",conv(buffer));clear(buffer,8);
                }
                else
                {
                    clear(buffer,8);
                	fread (buffer,1,2,fmiditxt);bn++;
                	printf("nrd:%s\n",buffer);
                	clear(buffer,8);
                }
            }
            printf("\033[34m[End of Truck chunk %d]\033[0m",ntrk);
            printf("\n");
        }else if (t==-1){break;}
        else{clear(buffer,8);fread (buffer,1,2,fmiditxt);printf("nrdex:%s\n",buffer);clear(buffer,8);bn++;}
    }
    printf("\n\n////fin de l'analyse:////\n\n");
	fclose(fmiditxt);


}

