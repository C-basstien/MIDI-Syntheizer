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
	
			init();
			case read_s is

				when CMD =>
					if ( chunk_s == HEADER ) then
						header_proced();
					else 
						chunk_s <= TRACK;
						if ( count > '100' ) then--on  ignore les premiers bits qui sont un en-tête
						
									calc_time();--procédure pour lire le temps
									read_cmd(); --procédure pour lire les commandes
									execute_cmd(cmd_s,syst_s,meta_s,rom_adr);
								
			when others end_of_file; --l'autre état
			end case;
		end process;
	end A;

