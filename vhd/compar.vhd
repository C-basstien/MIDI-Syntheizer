library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

type str_cmd    is array(3 downto 0) of std_logic_vector(7 downto 0);--représente une chaîne de caractère de la commande à lire
type statecmpr is (TESTON,ENDOFTEST);--état de la comparaison
			
--------------------------------------------------------------------------------------------------------------
entity COMP is
 	port
 	(	
	 	clk: 									in std_logic;
	 	reset: 								in std_logic;-- pour initialisé l'état de la fsm
	 	req_comp: 						in std_logic;-- pour que la fsm demande une nouvelle comparaison
	 	cmd: 									in str_cmd;--valeur d'une comande ou donnée à comparée
	 	comp_in : 						in std_logic_vector(7 downto 0);--<=rom_out	
	 	length : 							in std_logic_vector(3 downto 0);--taille de la valeur à comparer
	 	rom_adr_in: 					in std_logic_vector(31 downto 0);--adresse initiale donnée par la fsm
	 	rom_comp_address :		out std_logic_vector(31 downto 0);--adresse pour lire la mémoire en mode conversion
		state_comp: 					out statecmpr;--indique si la comparaison et toujours en cours ou fini à la fsm
		res_comp : 						out  std_logic;--indique si le résultat de la comapraison est valide
	)
end entity COMP;
----------------------------------------------------------------------------------------------------------------
architecture CMP of COMP is
---
signal cure_state:statecmpr;
signal next_state:statecmpr;

signal cure_count:unsigned(3 downto 0);
signal next_count:unsigned(3 downto 0);

signal cure_rom_vlq: std_logic_vector(31 downto 0);--adresse de la rom actuel
signal next_rom_vlq: std_logic_vector(31 downto 0);

signal r: std_logic;--résultat temporaire

---
begin
---
	FSM_NEXT_COMP: process(clk,reset)
		begin
		if(clk'event and clk='1') then
		
			if(reset='1') then 
			
				cure_count	<=	"0000";
				r						<=	'0';
				res_comp    <=	'0';
				cure_state	<=	ENDOFTEST;
				state_comp	<=	ENDOFTEST;
				
			else
			
				if (next_state=ENDOFTEST) then 
					cure_count<="0000";
				
				else
				
				state							<=	next_state;
				cure_state				<=	next_state;
				count							<=	next_count;
				
				rom_comp_address	<=	next_rom_vlq;
				cure_rom_vlq			<=	next_rom_vlq;
				
				end if
			end if
			
		end if
	end process;
---
	FSM_COMP: process(cure_state,req_comp)
		begin
		case cure_state is 
		
				when TESTON=>
				
					if (cure_count>=lenght-"0001") then 
						next_state<=ENDOFTEST;
					end if;
					
					if (cmd(count)=comp_in) then
						r						<=	'1';
						next_state<=TESTON;
					else 
						r						<=	'0';
						next_state	<=	ENDOFTEST;
					end if
	
					next_count <= count + "0001";

				when ENDOFTEST=>
				
					res_comp			<=	r;--on retourne le resultat à la fsm
					next_count		<=	"0000";--pret pour une nouvelle conversion
					next_state		<=	ENDOFTEST;
					
					if(reqcomp'event and reqcomp ='1') then 
						next_rom_vlq	<=	rom_adr_in;
						next_state		<=	TESTON;
					end if;
					 
		end case;
	end process;

end CMP;
