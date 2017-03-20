library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity NOTE_CALCULATOR is
  port(isnoteevent : in std_logic;enablenote: in std_logic;noteindice std_logic_vector (7 downto 0);amplitude std_logic_vector (7 downto 0);)
end entity NOTE_CALCULATOR;

architecture NOTE_CALC of NOTE_CALCULATOR is
--isnoteevent : signal qu'on doit prendre en compte le début ou l'arret d'une nouvelle note
--enablenote: précise si il s'agit d'un évenement de type on ou off
--noteindice: indique à quel endroit de la RAM contenant le code des notes on doit se placer (sinus)
--amplitude: indique l'amplitude de la note, pour l'instant elle est prise en compte de manière binaire
begin

end architecture NOTE_CALC;
  
  
