#include "midi_read.h"
unsigned int bn;//byte number
void analyse (void)
{
	FILE * fmiditxt=fopen("midi-byte.txt","r"); rewind(fmiditxt);
	int t=0; int ntrk=0;unsigned int time=0;
	char* buffer=(char*)(malloc(sizeof(char)*8)); clear(buffer,8);
	if (buffer == NULL) {fputs ("Memory error",stderr); exit (1);}
	printf("\n\n////START ANALYSE:////\n\n");
	while(!(feof(fmiditxt)) && !ferror(fmiditxt))
	{/** Standard MIDI File Structure* = <header_chunk> + <track_chunk> [+ <track_chunk> ...]*/
		if((t=cmpr("4d546864",fmiditxt))==1)
		{	/**header_chunk = <identifier> + <header_length> + <format> + <track_chunk number> + <time division>
                                4bytes          4bytes          2bytes          2bytes              2bytes      **/
			printf("\033[34m[Header chunk]\033[0m\n");
			fread (buffer,1,8,fmiditxt);/*MThd len in bytes  after this*/
			printf("\033[33m[%d information byte]\033[0m\n",conv(buffer)); clear(buffer,8); /*always 6 bytes of information normally */
			fread (buffer,1,4,fmiditxt);
			printf("\033[33m[MIDI type:%d]\033[0m\n",conv(buffer)); clear(buffer,8);
			fread (buffer,1,4,fmiditxt);
			printf("\033[33m[%d Truck chunk]\033[0m\n",conv(buffer)); clear(buffer,8);
			fread (buffer,1,4,fmiditxt);
			printf("\033[33m[Quater note length:%d]\033[0m",conv(buffer)); clear(buffer,8);
			printf("\n");
		} else if (t==-1) {break;}
		if((t=cmpr("4d54726b",fmiditxt))==1)
		{	/**track_chunk = <identifier> + <track_length> + <track_event> [+ <track_event> ...]
                              4bytes         4bytes             **/
            /** track_event = <v_time> + <midi_event> | <meta_event> | <sysex_event>**/
            /**<v_time> a variable length value**/
            /**meta_event = 0xFF + <meta_type> + <v_length> + <event_data_bytes>**/
			ntrk++;
			printf("\033[34m[Track chunk %d]\033[0m\n",ntrk);
			fread (buffer,1,8,fmiditxt);/*MTrk len in bytes  after this*/
			printf("\033[33m[%d information byte]\033[0m\n",conv(buffer)); clear(buffer,8);
			while(!(cmpr("ff2f00",fmiditxt))==1)
			{
			    time=get_time(buffer,fmiditxt);printf("[t:%d]",time);
			    /**Midi event**/
                if (cmpr("8",fmiditxt))
				{/**Note Off**/
					printf("[Note Off: ");clear(buffer,8);fread (buffer,1,1,fmiditxt);printf("channel %d ",conv(buffer));clear(buffer,8);
					fread (buffer,1,2,fmiditxt); find_note(conv(buffer)); clear(buffer,8);
					fread (buffer,1,2,fmiditxt);printf(" velocity %d]\n",conv(buffer)); clear(buffer,8);
				}
                else if (cmpr("9",fmiditxt))
				{/**Note On**/
					printf("[Note On: ");clear(buffer,8);fread (buffer,1,1,fmiditxt);printf("channel %d ",conv(buffer));clear(buffer,8);
					fread (buffer,1,2,fmiditxt); find_note(conv(buffer)); clear(buffer,8);
					fread (buffer,1,2,fmiditxt); printf(" velocity %d]\n",conv(buffer)); clear(buffer,8);
				}
                else if (cmpr("a",fmiditxt))
				{/**Polyphonic aftertouch**/
					printf("[Polyphonic aftertouch ");clear(buffer,8);fread (buffer,1,1,fmiditxt);printf("channel %d ",conv(buffer));clear(buffer,8);
					fread (buffer,1,2,fmiditxt); find_note(conv(buffer)); clear(buffer,8);
					fread (buffer,1,2,fmiditxt); printf(" pressure %d]\n",conv(buffer)); clear(buffer,8);
				}
                else if (cmpr("b",fmiditxt))
				{/**Control mode change**/
					printf("[Control mode change: ");clear(buffer,8);fread (buffer,1,1,fmiditxt);printf("channel %d ",conv(buffer));clear(buffer,8);
					fread (buffer,1,2,fmiditxt); printf(" controller %d",conv(buffer)); clear(buffer,8);
					fread (buffer,1,2,fmiditxt); printf(" value %d]\n",conv(buffer)); clear(buffer,8);
				}
                else if (cmpr("c",fmiditxt))
				{/**Program change**/
					printf("[Program change: ");clear(buffer,8);fread (buffer,1,1,fmiditxt);printf("channel %d ",conv(buffer));clear(buffer,8);
					fread (buffer,1,2,fmiditxt); printf(" program %d]\n",conv(buffer)); clear(buffer,8);
				}
                else if (cmpr("d",fmiditxt))
				{/**Channel Pressure*/
                    printf("[Channel Pressure: ");clear(buffer,8);fread (buffer,1,1,fmiditxt);printf("channel %d ",conv(buffer));clear(buffer,8);
					fread (buffer,1,2,fmiditxt); printf("pressure %d]\n",conv(buffer)); clear(buffer,8);
				}
                else if (cmpr("e",fmiditxt))
				{/**Pitch wheel range*/
					printf("[Pitch wheel range: "); clear(buffer,8);
					fread (buffer,1,4,fmiditxt);printf("%d]\n",conv(buffer)); clear(buffer,8);
				}
				/**syst event**/
				else if (cmpr("f0",fmiditxt))
				{/**System exclusives message**/
					printf("[ MIDI system exclusive message"); clear(buffer,8);
					while(!cmpr("f7",fmiditxt)){fread (buffer,1,2,fmiditxt);}
					printf("]\n"); clear(buffer,8);
				}
                /**meta event**/
                else if (cmpr("ff0002",fmiditxt))
				{/**Sequence Number**/
					printf("[Sequence number:");clear(buffer,8);fread (buffer,1,4,fmiditxt);printf("%d ",conv(buffer));clear(buffer,8);
					printf("]\n");
				}
                else if (cmpr("ff01",fmiditxt))
				{/**Text**/
				    printf("[Text:");
					int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]");
				}
                else if (cmpr("ff02",fmiditxt))
				{/**Copyright**/
                    printf("[Copyright:");
					int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
				else if (cmpr("ff03",fmiditxt))
				{/**Sequence/Track Name**/
                    clear(buffer,8);printf("[Track name:");
					int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
				else if (cmpr("ff04",fmiditxt))
				{/**Instrument Name **/
                    printf("[Instrument name:");
 					int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
				else if (cmpr("ff05",fmiditxt))
				{/**Lyric**/
                    printf("[Lyric:");
					int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
				else if (cmpr("ff06",fmiditxt))
				{/**Marker**/
                    printf("[Marker:");
					int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
				else if (cmpr("ff07",fmiditxt))
				{/**Cue Point **/
                    printf("[Cue point:");
                    int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
                else if (cmpr("ff08",fmiditxt))
				{/**Program Name**/
                    printf("[Program Name:");
                    int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
                else if (cmpr("ff08",fmiditxt))
				{/**Device Name**/
                    printf("[Device Name");
					int l=get_time(buffer,fmiditxt);
					read_text(fmiditxt,l);
					printf("]\n");
				}
                else if (cmpr("ff2001cc",fmiditxt))
				{/**MIDI Channel Prefix**/
                    printf("[MIDI Channel Prefix");
                    clear(buffer,8);fread (buffer,1,2,fmiditxt);printf("%d ",conv(buffer));clear(buffer,8);
					printf("]");
				}
                else if (cmpr("ff2101",fmiditxt))
				{/**MIDI Port**/
                    printf("[MIDI Port:");clear(buffer,8);fread (buffer,1,2,fmiditxt);printf("%d ",conv(buffer));clear(buffer,8);
					printf("]\n");
				}
				else if (cmpr("ff5103",fmiditxt))
				{/**Tempo**/
					printf("[Tempo:");clear(buffer,8);
					fread (buffer,1,6,fmiditxt);
					printf("%dµs by quater note]\n",conv(buffer)); clear(buffer,8);
				}
				else if (cmpr("ff5405",fmiditxt))
				{/** SMTPE Offset*/
                    printf("[SMTPE Offset:");
                    clear(buffer,8);fread (buffer,1,2,fmiditxt);printf("%dh:",conv(buffer));
                    clear(buffer,8);fread (buffer,1,2,fmiditxt);printf("%dm:",conv(buffer));
                    clear(buffer,8);fread (buffer,1,2,fmiditxt);printf(", %d frames and",conv(buffer));
                    clear(buffer,8);fread (buffer,1,2,fmiditxt);printf("%d fractional frames",conv(buffer));
					printf("]\n");
				}
				else if (cmpr("ff5804",fmiditxt))
				{/**Time Signature**/
					printf("[Time Signature");
					fread (buffer,1,2,fmiditxt);
					printf("%d/",conv(buffer)); clear(buffer,8);
					fread (buffer,1,2,fmiditxt);
					printf("%d ",(int)pow(2,conv(buffer))); clear(buffer,8);
					fread (buffer,1,2,fmiditxt);
					printf("%d MIDI Clk",conv(buffer)); clear(buffer,8);
					fread (buffer,1,2,fmiditxt);
					printf("(%d 1/32 notes)/(24 MIDI Clk)]\n",conv(buffer)); clear(buffer,8);
				}
				else if (cmpr("ff5902",fmiditxt))
				{/**Key Signature**/
                    printf("[Key signature:");
                    fread (buffer,1,2,fmiditxt);
                    unsigned int Mm;
                    int flat=(signed char)conv(buffer);clear(buffer,8);
                    fread (buffer,1,2,fmiditxt);Mm=conv(buffer);
                    if(Mm==0){print_note_noscale(1200+flat);printf(" major");}
                    else if (Mm==1){print_note_noscale(1209+flat);printf(" minor");}
                    clear(buffer,8);
					printf("]\n");
				}
				else if (cmpr("ff7f",fmiditxt))
				{/**Sequencer-Specific Meta-event**/
                    printf("[Sequencer-Specific Meta-event:");
                    int l=get_time(buffer,fmiditxt);
					fread (buffer,1,2*l,fmiditxt);clear(buffer,8);
					printf("]\n");
				}
				else
				{
					if(cmpr("ff2f00",fmiditxt)==1){goto out_chunk;}
					fread (buffer,1,2,fmiditxt);
					printf("nrd:%s\n",buffer);
					//if(conv(buffer)>=00&&conv(buffer)<0x80){}
					bn++;
				}
			}
			out_chunk:
			printf("\033[34m[End of Truck chunk %d]\033[0m",ntrk);
			printf("\n");
		} else if (t==-1) {break;}
		else {if(cmpr("ff",fmiditxt)==1){goto eof;}clear(buffer,8);fread(buffer,1,2,fmiditxt);printf("nrdex:%s\n",buffer); clear(buffer,8); bn++;}
	}
	eof:printf("\n\n////END OF ANALYSIS////\n\n");
	fclose(fmiditxt);


}
