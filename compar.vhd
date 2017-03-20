library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

type str_cmd    is array(3 downto 0) of std_logic_vector(7 downto 0);--représente une chaîne de caractère de la commande à lire
type statecmpr is (TESTON,ENDOFTEST);--état de la comparaison
			
----------------------------------------------------------------
entity COMP is
 	port
 	(	
 	clk: 			in std_logic;
 	req_comp: 		in std_logic;-- pour que la fsm demande une nouvelle comparaison
  	reset: 			in std_logic;-- pour initialisé l'état de la fsm
 	tab: 			in str_cmd;--valeur d'une comande ou donnée à comparée
 	indice_ROM_MID: in std_logic_vector(31 downto 0);--adresse actuel à laquelle on lit les bytes
  	length : 		in std_logic_vector(3 downto 0);--taille de la valeur à comparer
  	comp_in : 		in std_logic_vector(7 downto 0);--<=rom_out
  	state_comp: 	out statecmpr;--indique si la comparaison et toujours en cours ou fini à la fsm
  	res : 			out  std_logic;--indique si le résultat de la comapraison est valide
	)
end entity COMP;
----------------------------------------------------------------
architecture CMP of COMP is
---
signal cure_state:statecmpr;
signal next_state:statecmpr;
signal count:unsigned(3 downto 0);
signal next_count:unsigned(3 downto 0);
signal r:std_logic;
---
begin
---
	FSM_NEXT_COMP: process(clk,reset)
		begin
		if(clk'event and clk='1') then
		
			if(reset='1') then 
				count<="0000";
				r<='0';
				cure_state<=ENDOFTEST;
				state<=ENDOFTEST
			else
			
				if (next_state=ENDOFTEST) then 
					count<="0000";
				
				else
				state<=next_state;
				cure_state<=next_state;
				count<=next_count;
				end if
			end if
			
		end if
	end process;
---
	FSM_COMP: process(cure_state,req_comp)
		begin
		case cure_state is 
		
				when TESTON=>
				
					if (count=lenght-1) then next_state<=ENDOFTEST;
					if (tab(count)=comp_in then r<='1';
					else r<='0';next_state<=ENDOFTEST;
					end if
					next_count <= count + "0001";
					
					
				when ENDOFTEST=>
					res<=r;--on retourne le resultat à la fsm
					next_count<="0000";--pret pour une nouvelle conversion
					next_state<=ENDOFTEST;
					if(reqcomp'event and reqcomp ='1') then next_state<=TESTON;
					
	end process;

end CMP;
