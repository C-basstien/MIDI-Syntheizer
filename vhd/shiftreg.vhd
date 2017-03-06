library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_register is
  port(req, reset : in std_logic;
	reg1_in : in std_logic_vector(7 downto 0);
	reg2_in : in std_logic_vector(7 downto 0);
	shift_in: in std_logic_vector(2 downto 0);
	reg3_out: out std_logic_vector(7 downto 0);)
	
end shift_register;

architecture A of shift_register is
signal reg :std_logic_vector(2 downto 0);
signal buff : std_logic_vector(7 downto 0);
variable i : integer := 1;
begin
  P_shift_register : process (req)
  begin
    if (req'event and req = '1') then
	if reset = '1' then 
	reg3_out <= "00000000";
	else
        buff <= reg1_in & reg2_in ;
        loop0:for i in 0 to 7 loop
        reg3_out(i)<= buff((integer)shift_in + i);
        end loop0;
     end if;
    end if;
  end process P_shift_register;
        shift_out <= reg(2);
end A;
