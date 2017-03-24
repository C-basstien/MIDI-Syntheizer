
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package DEFS is
  type str_cmd    is array(3 downto 0) of std_logic_vector(7 downto 0);--représente une chaîne de caractère de la commande à lire
  type statecmpr is (CONVON,ENDOFCONV);--état de la conversion

  type READ_STATE is (CMD,EOF);
  type CMDS is 
  (
          NOTE_OFF,--8x
          NOTE_ON,--9x
          POLY_KEY_PRESSURE,--ax
          CONTROL_CHANGE,--bx
          PROGRAM_CHANGE,--cx
          MONO_KEY_PRESSURE,--dx
          PITCH_BEND,--ex
          SYSTEM--fx
  );
  type SYSTEMS is 
  (
          --COMMON MESSAGES
          SYS_EXCLU,--f0
          RESERVED1,--f1
          SONG_POS_POINTER,--f2
          RESERVED2,--f4
          RESERVED3,--f5
          TUNE_REQUEST,--f6
          SYS_EXCLU_END,--f7
          --REAL TIMES MESSAGES, not used
          TIMING_CLK,--f8
          RESERVED4,--f9
          START,--fa
          CONTINUE,--fb
          STOP,--fc
          RESERVED5,--fd
          ACTIVE_SENSING,--fe
          RESET--ff	
  );
  type META_EV is	
  (
  --meta_event = 0xFF + <meta_type> + <v_length> + <event_data_bytes>

          SQ_NUMB,--ff00
          TXT,--ff01
          COPYRIGHT,--ff02
          TRK_NAME,--ff03
          INST_NAME,--ff04
          LYRIC,--ff05
          MARKER,--ff06
          CUE_POINT,--ff07
          PRG_NAME,--ff08
          DEVICE_NAME,--ff09
          MIDI_CHANNEL_PR,--ff2001
          MIDI_PORT,--ff2101
          END_TRACK,--ff2f00
          TEMPO,--ff5103
          SMPTE_OFFSET,--ff5405
          TIME_SIGNATURE,--ff5804
          KEY_SIGNATURE,--ff5902
          SEQ_SPECIFIC_EV--ff7f
  );
  type CHUNK is 
  (
          HEADER,--4d546864
          TRACK,--4d54726b		
  );
  type STATUS is
  (
          WAIT_END,
          ACTIVE
  );
