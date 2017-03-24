library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity MIDI_FSM is
  port
  (
			clk: 							in std_logic;
			reset:						in std_logic;
			---ports vers comp
			cmpr_state:				in statecmpr;--état de la comparaison (en cours, fini)
			cmpr_res:					in std_logic;--résultat de la dernière comparaison
			cmpr_req:					out std_logic;--demande d'une nouvelle comparaison 
			cmpr_length : 		out std_logic_vector(3 downto 0);--taille de la valeur à comparer
			cmd:							out  str_cmd;--valeur d'une comande ou donnée à comparée
			rom_comp_in: 			out  std_logic_vector(31 downto 0);--adresse initiale donée par la fsm
			--ports vers vlq
			vlq_calc_state:		in statecalc;--état du calcul de la VLQ
			vlq_res:					in std_logic_vector(31 downto 0);--résultat du calcul de la VLQ
			rom_vlq_in: 			out std_logic_vector(31 downto 0);--adresse initiale donée par la fsm
			rom_vlq_out: 			out std_logic_vector(31 downto 0);--adresse incrémentée après la conversion de la donnée vlq
			vlq_req:					out std_logic;--demande d'un nouveau calcul d'une VLQ
			--ports vers la rom midi
			midi_rom_adr : 		out std_logic_vector(32 downto 0);
			rom_fsm_out  :		out std_logic_vector(7 downto 0);
			--ports vers la rom son
			sound_rom_adr : 	out std_logic_vector(6 downto 0);
  )

end MIDI_FSM;
-- Machine à états contrôlant le filtre numérique.


architecture A of MID_FSM is



		signal cure_rom_fsm: std_logic_vector(31 downto 0);--adresse de la rom actuel
		signal next_rom_fsm: std_logic_vector(31 downto 0);			
		signal statu_s : STATUS;
		signal read_s : READ_STATE;
		signal chunk_s: CHUNK;
		signal cmd_s: CMDS;
		signal syst_s: SYSTEMS ;
		signal meta_s: META_EV;
		signal delta_time_s: unsigned(31 downto 0);--32bit to store large delta times
		signal count_byte: unsigned(31 downto 0);--compteur dans le fichier
		signal midi_type: unsigned(7 downto 0);--mais sut un bit en réalité
		signal note_lenght: unsigned(7 downto 0);
		signal isnoteevent: std_logic;--

	begin

		FSM_NEXT_STATE: process(clk, reset)

		begin
		if(clk'event and clk='1') then
			if(reset='1') then 
				current_state 	<= 	INIT;
				count						<=	(others =>'0');--à voir
			else
				current_state		<=	next_state;
				count						<=	count_next;
			end if;
		end if;
			end process;


			P_FSM: process(read_s,chunk_s,cmd_s,syst_s,meta_s,delta_time_s)

		begin			
			read_s <= READ_TIME;
			chunk_s <= TRACK;
			cmd_s <= NOTE_OFF;
			syst_s <= STOP;
			meta_s <= END_TRACK;
			delta_time_s <= (others =>'0');


			case read_s is

				when CMD =>
					if ( chunk_s == HEADER ) then
						case count is --compteur pour savoir ou on se trouve dans le fichier
									when 10 =>  midi_type <= read_reg(0,2); --fonction de lecture
											=> note_lenght <= read_reg(2,2);
											count <= '0' --mettre le compteur a 0 pour preparer la prochaine lecture de Track
									others avancer_lecture;

					else 
						chunk_s <= TRACK;
						if ( count > '100' ) then

		-------------------------------------------
				rom_vlq_out <= curr_rom_adress;
				vlq_req			<= '1';--demande d'un nouveau calcul de temps au convertisseur
													--tant que le processus n'est pas terminé on bascule dans un état wait
		-------------------------------------------
									=> delta_time_s <= read_time --apres le nombre de bytes du track chunk on lit le temps avec la fontion read_time a definir et incrementer le compteur
									=> cmd_s <= read_cmd --fonction pour lire les commandes
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
															=> count <= "00000000000000000000000000000000"
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
									=> count <= "00000000000000000000000000000000"
							end if;--fin du track chunk


			when others end_of_file; --l'autre état
			end case;
		end process;
	end A;
