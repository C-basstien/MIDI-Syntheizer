
LIBRARY ieee; -- déclaration de la fonction
USE ieee.std_logic_1164.all;
USE work.myfuncs.all; -- on déclare la bibliothèque utilisateur myfuncs
PACKAGE myfuncs IS

PACKAGE myfuncs IS

    PROCEDURE read_cmd(inout rom_adr, out cmd)
		PROCEDURE execute_cmd(in cmd_s,in syst_s,in meta_s,inout rom_adr)

END myfuncs;

PACKAGE BODY myfuncs IS

		PROCEDURE init()
		read_s <= READ_TIME;
		chunk_s <= TRACK;
		cmd_s <= NOTE_OFF;
		syst_s <= STOP;
		meta_s <= END_TRACK;
		delta_time_s <= (others =>'0');
		end init;
		PROCEDURE calc_time()
				curr_statu_s					<=	WAIT_END;				
				rom_vlq_out <= curr_rom_adress;
				vlq_re
				if (next_statu_s=WAIT_END)
				else
				end if;
				q			<= '1';--demande d'un nouveau calcul de temps au convertisseur
													--tant que le processus n'est pas terminé on bascule dans un état wait									
				=> delta_time_s <= read_time
				
		end calc_time;
    PROCEDURE read_cmd()
    PROCEDURE header_proced()
    	case count is --compteur pour savoir ou on se trouve dans le fichier
				when 10 => midi_type <= read_reg(0,2); --fonction de lecture
								=> note_lenght <= read_reg(2,2);
								=> count <= '0' --mettre le compteur a 0 pour preparer la prochaine lecture de Track
				others avancer_lecture;--rom_adress+1
    end header_process;
    PROCEDURE execute_cmd(in cmd_s,in syst_s,in meta_s,inout rom_adr)
    
    begin
    case cmd_s is

										when NOTE_OFF--8x														
														=> isnoteevent <= '1';--on active le circuit de calcul de note
														--aller chercher dans la table de sinus							
										when NOTE_ON--9x
														=> isnoteevent <= '1';--on active le circuit de calcul de note
														--aller chercher dans la table de sinus
										when POLY_KEY_PRESSURE--ax
										--ignorer pour l'instant, lire 2 bytes
										when CONTROL_CHANGE--bx
										--ignorer pour l'instant, lire 2 bytes
										when PROGRAM_CHANGE--cx
										--ignorer pour l'instant, lire 1 bytes
										when MONO_KEY_PRESSURE--dx
										--ignorer pour l'instant, lire 1 bytes
										when PITCH_BEND--ex
										--ignorer pour l'instant, lire 2 bytes
										when SYSTEM--fx
											case syst_s is
												when SYS_EXCLU--f0
												--ignorer jusqu'à f7
												when RESERVED1--f1
												--ignorer lire 2 bytes
												when SONG_POS_POINTER--f2
												--ignorer 
												when RESERVED2--f4
												--ignorer 
												when RESERVED3--f5
												--ignorer 
												when TUNE_REQUEST--f6
												--ignorer 
												when SYS_EXCLU_END--f7
												--REAL TIMES MESSAGES, not used

												when TIMING_CLK--f8
												--ignorer 
												when RESERVED4--f9
												--ignorer 
												when START--fa
												--ignorer 
												when CONTINUE--fb
												--ignorer 
												when STOP--fc
												--ignorer 
												when RESERVED5--fd
												--ignorer 
												when ACTIVE_SENSING--fe
												--ignorer 
												when RESET--ff
													case meta_s is
														--début lire texte
														when SQ_NUMB--ff00

														when TXT--ff01

														when COPYRIGHT--ff02

														when TRK_NAME--ff03

														when INST_NAME--ff04

														when LYRIC--ff05

														when MARKER--ff06

														when CUE_POINT--ff07

														when PRG_NAME--ff08

														when DEVICE_NAME--ff09

														when MIDI_CHANNEL_PR--ff2001

														when MIDI_PORT--ff2101
														--fin lire texte

														when END_TRACK--ff2f00
														--sortir de meta_s et syst_s et cmd_s et du if, goto ?
															
														when TEMPO--ff5103
														--récupérer tempo et le mettre dans une 
														--variable
														when SMPTE_OFFSET--ff5405
														--ignorer ?
														when TIME_SIGNATURE--ff5804
														--ignorer pour l'instant ?
														when KEY_SIGNATURE--ff5902
														--ignorer pour l'instant ?
														when SEQ_SPECIFIC_EV--ff7f
														--lire texte ?
													end case;--meta_s
											end case;--syst_s
									end case; --cmd_s
									
									
							end if;--fin du track chunk

    END execute_cmd;
    

END myfuncs;
