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
 SIGNAL int MIDI_FILE_P;--pointeur dans la lecture du fichier MIDI
                        --dans le cas d'un fichier MIDI de type 1 (cad:plusieurs pistes joué simultanément)
                        --il faut implanter un tableau de pointeur de la taille du  nombre de track_chunk
                        --Puis lancer une éxecution en parralèle
                        -- On se limitera donc au fichier de type 2 et 0
  BEGIN
   PROCESS nextglobalSTATE (clkMIDI)
    BEGIN
   END PROCESS nextglobalSTATE
  
   PROCESS globalSTATE (state)
    BEGIN
   END PROCESS globalSTATE

   PROCESS   nexttrack_CHUNK_STATE (state)
    BEGIN
   END PROCESS globalSTATE  

    track_chunk_state PROCESS (chunk_cmd)
    NOTE_DATA<= '0';--indique à la partie calculant les notes quel doit prendre en compte cette donnée
                    --par défaut elle est mis à 0 pour tout les autres évenments que NOTE_OFF et NOTE_ON
    BEGIN
     CASE chunk_cmd IS
      WHEN NOTE_OFF =>
       NOTE_DATA<= '1';
       NOTE_
      WHEN NOTE_ON =>
       NOTE_DATA<= '1';
      WHEN POLY_AFT =>
      WHEN CTRL_CHG =>
      WHEN PRG_CHG =>
      WHEN CHAN_PRES =>
      WHEN PITCH_RG =>
      WHEN SYST_MESS =>
      WHEN NUMB_SEQ =>
      WHEN TEXT =>
      WHEN TEMPO =>
      WHEN SMTPE_OFFSET =>
      WHEN TIME_SIGNATURE =>
      WHEN KEY_SIGNATURE =>
      WHEN SP_META=>
      WHEN ENDCHUNK =>
      WHEN OTHERS =>
   END PROCESS globalSTATE  

  BEGIN
