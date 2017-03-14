LIBRARY IEE
USE IEEE.STD_LOGIC_1164.ALL
 
ENTITY fsm_midi IS
  PORT
    (
     MIDI_data: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
     
     VLQ_CALC: IN STD_LOGIC_VECTOR (32 DOWNTO 0);
     VLQ_DATA: OUT STD_LOGIC_VECTOR (32 DOWNTO 0);
     
     COMP_CALC: IN STD_LOGIC;
     VAL_COMP_A: OUT STD_LOGIC_VECTOR (32 DOWNTO 0);
     VAL_COMP_B: OUT STD_LOGIC_VECTOR (32 DOWNTO 0);
     
     NOTES_PLAYS: STD_LOGIC_VECTOR (32 DOWNTO 0);
     CLK STD_LOGIC;
     CONV_data: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    )
END ENTITY fsm_midi;
  
 
 COMPONENT compar_data_cmd IS
-- composant comparant la valeur numérique de la donée midi entrante MIDI_c_data (buffer de taille 8) avec value_c
--lenght_rd indique la longeur à lire
--str_prt indique la ou doit commencer la lecture
--res_c indique le résultat de la comparaison
  PORT(
        MIDI_c_data: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        value_c:IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        length_rd: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        res_c: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
       )
END COMPONENT time_vlq;
  
COMPONENT time_vlq IS
  PORT(
        MIDI_t_data: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        res_t: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
       )
END COMPONENT time_vlq;
   
ARCHITECTURE fsm_midi_arch of fsm_midi IS
  

    

    

  BEGIN
