library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIDI_SYNTHETIZER is
	port
	(
		clk : in std_logic;
		dac_wrb      : out std_logic;--Activation de l'écriture
		dac_csb      : out std_logic;--Activation du port parallel
		ldacb        : out std_logic;--Activation de la load du signal d'entrée
		clrb         : out std_logic;--CLEAR DAC
		ouputmusic   : out std_logic_vector(7 downto 0)) ;--affecte la qualitée sonore
	)
end MIDI_SYNTHETIZER;

architecture A of MIDI_SYNTHETIZER is

	component MIDI_FSM
		port
		(
			clk: 					in std_logic;
			---ports vers comp
			cmpr_state:					in statecmpr;--état de la comparaison (en cours, fini)
			cmpr_res:						in std_logic;--résultat de la dernière comparaison
			cmpr_req:						out std_logic;--demande d'une nouvelle comparaison 
			cmpr_length : 			out std_logic_vector(3 downto 0);--taille de la valeur à comparer
			cmd:								out  str_cmd;--valeur d'une comande ou donnée à comparée
			rom_comp_in: 				out  std_logic_vector(31 downto 0);--adresse initiale donée par la fsm
			--ports vers vlq
			vlq_calc_state:	in statecalc;--état du calcul de la VLQ
			vlq_res:				in std_logic_vector(31 downto 0);--résultat du calcul de la VLQ
			rom_vlq_in: 		out std_logic_vector(31 downto 0);--adresse initiale donée par la fsm
			rom_vlq_out: 		out std_logic_vector(31 downto 0);--adresse incrémentée après la conversion de la donnée vlq
			vlq_req:				out std_logic;--demande d'un nouveau calcul d'une VLQ
			--ports vers la rom midi
			midi_rom_adr : out std_logic_vector(32 downto 0);
			rom_fsm_out  : out std_logic_vector(7 downto 0);
			--ports vers la rom son
			sound_rom_adr : out std_logic_vector(6 downto 0);
		)
	end component;
	
	component MIDI_ROM
	  port
	  (
			rom_fsm_address  : 	in  std_logic_vector(9 downto 0);
			rom_comp_address :	in  std_logic_vector(9 downto 0);
			rom_vlq_address  : 	in  std_logic_vector(9 downto 0);
			--une adresse mémoire contient un byte,2^32 bytes sont stockable
			rom_fsm_out    : 		out std_logic_vector(7 downto 0);
			rom_comp_out    : 	out std_logic_vector(7 downto 0);
			rom_vlq_out    : 		out std_logic_vector(7 downto 0);
	   );
	end component;
	
	component SOUND_ROM
		port
		(
    	sound_rom_adr:in std_logic_vector(6 downto 0);--127 notes possibles en midi
      sound_rom_out : out std_logic_vector(7 downto 0)) ;--affecte la qualitée sonore
    )--une adresse mémoire contient un byte,2^32 bytes sont stockable
	end component;
	
	component COMPARATOR
	 port
	 (	
	 		clk: 								in  std_logic;--clk pour faire un process séquentiel
 			reset: 							in  std_logic;-- reset pour initialisé l'état du comparateur
	 		req_comp: 					in  std_logic;-- pour que la fsm demande une nouvelle comparaison
	 		tab:								in  str_cmd;--valeur d'une comande ou donnée à comparée
			length : 						in  std_logic_vector(3 downto 0);--taille de la valeur à comparer
	 		rom_adr_in: 				in  std_logic_vector(31 downto 0);--adresse initiale donée par la fsm
			rom_comp_address :	out std_logic_vector(31 downto 0);--adresse pour lire la mémoire en mode comparaison
			state_comp:					out statecmpr;--indique si la comparaison et toujours en cours ou fini à la fsm
			res_comp : 					out std_logic;--indique si le résultat de la comapraison est valide
	)
	end component;
	
	component VLQ_CALCULATOR
	 	port
	 	(	
 			clk: 							in std_logic;--clk pour faire un process séquentiel
 			reset: 						in std_logic;-- reset pour initialisé l'état du convertisseur
			req_vlq: 					in std_logic;-- demande de conversion de la fsm
			vlq_in:						in std_logic_vector(7 downto 0);--rélié à rom_vlq_out
			rom_adr_in: 			in std_logic_vector(31 downto 0);--adresse initiale donée par la fsm
			rom_adr_out: 			out std_logic_vector(31 downto 0);--adresse incrémentée après la conversion de la donnée vlq
			rom_vlq_address :	out std_logic_vector(31 downto 0);--adresse pour lire la mémoire en mode conversion
			state_vlq: 				out statevlq;--état de la conversion  signalé à la fsm
			res_vlq : 				out std_logic_vector(31 downto 0);--résultat de la conversion en entier
		)
	end component;
	
	component NOTE_CALCULATOR
		port 
		(
			note_req_calc:in std_logic;--1 "reveil" le circuit pour une nouvelle tache,0 pas d'evenement
			note_event_type:in std_logic;--précise si on commence(1) ou on fini(0) la note
			note_pitch:in std_logic_vector(7 downto 0);--127 notes en midi mais codage sur un byte
			velocity: in std_logic_vector(7 downto 0);-- de 0 à 127 mais codage sur un byte
			sound_rom_adr:out std_logic_vector(6 downto 0);--127 notes possibles en midi
			sound_rom_out:in std_logic_vector(7 downto 0)) ;
		)
	end component;
	
	signal midi_rom_adr:  std_logic_vector(31 downto 0);
	signal midi_rom_out:  std_logic_vector(7 downto 0));
	
	signal sound_rom_out: std_logic_vector(7 downto 0));
	signal sound_rom_adr: std_logic_vector(6 downto 0);
	
	signal res_comp: std_logic;
	signal req_comp: std_logic;
	signal lenght: std_logic_vector(3 downto 0);
	signal tab:
	signal state_comp: statecmpr;
	
	signal res_vlq: std_logic_vector(31 downto 0);
	signal req_vlq: std_logic;
	signal state_vlq: statevlq;
	
	signal note_req_calc:std_logic;
	signal note_event_type:std_logic;
	signal note_pitch:std_logic_vector(7 downto 0);
	signal velocity: std_logic_vector(7 downto 0);

	begin
	
	U1: MIDI_FSM port map
	(
			clk => clk,
			cmpr_state => cmpr_state,
			cmpr_res => cmpr_res,
			cmpr_req => cmpr_req,
			vlq_calc_state => vlq_state,
			vlq_res => vlq_res,
			vlq_req => vlq_req,
			midi_rom_adr =>midi_rom_adr,
			sound_rom_adr=> sound_rom_adr
	);
	U2: MIDI_ROM port map
	(
		midi_rom_adr => midi_rom_adr,
		midi_rom_out => midi_rom_out
	);
	U3: SOUND_ROM port map
	(
		sound_rom_adr => sound_rom_adr,
    sound_rom_out => sound_rom_out
	);
	
	U4: COMPARATOR port map
	(
			clk => clk,
	 		req_comp =>req_comp,
	 		tab => tab,
	 		midi_rom_adr => midi_rom_adr,
			lenght => lenght,
			state_comp => state_comp,
			res_comp => res_comp,
	);
	
	U5:VLQ_CALCULATOR port map
	(
		clk => clk,
		req_vlq => req_vlq,
		midi_rom_adr => midi_rom_adr,
		state_vlq => state_vlq,
		res_vlq => res_vlq
	);
	U6:NOTE_CALCULATOR port map
	(
			note_req_calc => note_req_calc,
			note_event_type => note_event_type,
			note_pitch => note_pitch,
			velocity => velocity,
			sound_rom_adr => sound_rom_adr,
			sound_rom_out =>sound_rom_out,
	);	
end A;
	
	
