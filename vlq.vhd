library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

type str_cmd    is array(3 downto 0) of std_logic_vector(7 downto 0);--représente une chaîne de caractère de la commande à lire
type statecmpr is (CONVON,ENDOFCONV);--état de la conversion
			
----------------------------------------------------------------
entity VLQ_CALC is
 	port
 	(
 			clk: in std_logic;--clk pour faire un process séquentiel
 			reset: in std_logic;-- reset pour initialisé l'état du convertisseur
			req_vlq: in std_logic;-- demande de conversion de la fsm
			rom_adr_in: in std_logic_vector(31 downto 0);--adresse initiale donée par la fsm
			rom_adr_out: out std_logic_vector(31 downto 0);--adresse incrémentée après la comparaisonde la donnée vlq
			rom_vlq_address :out std_logic_vector(31 downto 0);--adresse pour lire la mémoire en mode conversion
			vlq_in:in std_logic_vector(7 downto 0);--rélié à rom_vlq_out
			state_vlq: out statevlq;--état de la conversion  signalé à la fsm
			res_vlq : out  std_logic_vector(31 downto 0);--résultat de la conversion en entier
 	)
end entity COMP;
----------------------------------------------------------------
architecture A of VLQ_CALC is
---
signal cure_state:statecmpr;--état de la conversion
signal next_state:statecmpr;

signal cure_count:unsigned(2 downto 0);--compteur sur 3 bit car on lit 6 ou 5 byte au max
signal next_count:unsigned(2 downto 0);


signal cure_rom_vlq: std_logic_vector(31 downto 0);--adresse de la rom actuel
signal next_rom_vlq: std_logic_vector(31 downto 0);

signal r:std_logic_vector(31 downto 0);
signal next_r:std_logic_vector(31 downto 0);
---
begin
---
	FSM_NEXT_VLQ: process(clk,reset)
		begin
		if(clk'event and clk='1') then
		
			if(reset='1') then 
				cure_count<="000";
				r<='0';
				cure_state<=ENDOFCONV;
				state<=ENDOFCONV;
				cure_rom_vlq<= (others =>'0');
				rom_vlq_address<= (others =>'0');
				rom_adr_out<=(others =>'0');
				
			else
			
				if (next_state=ENDOFCONV) then 
					count<="000";
				
				else
				state<=next_state;
				cure_state<=next_state;
				cure_count<=next_count;
				cure_rom_vlq<=next_rom_vlq;
				end if
			end if
			
		end if
	end process;
---
	FSM_VLQ: process(cure_state,req_comp)
		begin
		rom_vlq_address<=cure_rom_vlq;
		rom_adr_out<=cure_rom_vlq;
		case cure_state is 
		
				when CONVON=>
					next_count <= cure_count + "001";
					next_rom_vlq<=cure_rom_vlq + conv_std_logic_vector(1,32);
					next_r<= (r * conv_std_logic_vector(128,32))+ conv_std_logic_vector((to_integer(unsigned(vlq_in)) mod 128),32); 
					if (cure_count<6) then next_state<=ENDOFCONV;
					if (to_integer(unsigned(vlq_in))<128)then next_state<=ENDOFCONV;
					
					
				when ENDOFCONV=>
					res_vlq<=r;--on retourne le resultat à la fsm
					next_r<=(others =>'0');--initialisation pour la prochaine conversion
					next_count<="000";--pret pour une nouvelle conversion
					
					next_state<=ENDOFCONV;
					if(req_vlq'event and req_vlq ='1') then next_state<=CONVON;‏
					
	end process;

end A;
