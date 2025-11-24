library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_test is
    port(
        -- Entradas
        clock   : in std_logic;
        reset   : in std_logic;
        writen  : in std_logic;
        data_in : in std_logic_vector(7 downto 0);

        -- Señales de dirección controladas por switches
        address_switches : in std_logic_vector(7 downto 0);

        -- Salidas a displays de 7 segmentos
        display1_address : out std_logic_vector(6 downto 0);
        display2_address : out std_logic_vector(6 downto 0);
        display1_dataout : out std_logic_vector(6 downto 0);
        display2_dataout : out std_logic_vector(6 downto 0);

        -- Puertos de salida 
        port_out_00 : out std_logic_vector(7 downto 0);
		  port_out_01 : out std_logic_vector(7 downto 0)
    );
end memory_test;


architecture arch_memory_test of memory_test is

    -- Componentes usados
component memory 
    port(
        -- Señales del CPU
        address   : in  std_logic_vector(7 downto 0);
        data_in   : in  std_logic_vector(7 downto 0);
        data_out  : out std_logic_vector(7 downto 0);
        writen    : in  std_logic;
        clock     : in  std_logic;
        reset     : in  std_logic;

        -- Puertos de entrada (DIP switches)
        port_in_00 : in std_logic_vector(7 downto 0);
        port_in_01 : in std_logic_vector(7 downto 0);
        port_in_02 : in std_logic_vector(7 downto 0);
        port_in_03 : in std_logic_vector(7 downto 0);
        port_in_04 : in std_logic_vector(7 downto 0);
        port_in_05 : in std_logic_vector(7 downto 0);
        port_in_06 : in std_logic_vector(7 downto 0);
        port_in_07 : in std_logic_vector(7 downto 0);
        port_in_08 : in std_logic_vector(7 downto 0);
        port_in_09 : in std_logic_vector(7 downto 0);
        port_in_10 : in std_logic_vector(7 downto 0);
        port_in_11 : in std_logic_vector(7 downto 0);
        port_in_12 : in std_logic_vector(7 downto 0);
        port_in_13 : in std_logic_vector(7 downto 0);
        port_in_14 : in std_logic_vector(7 downto 0);
        port_in_15 : in std_logic_vector(7 downto 0);

        -- Puertos de salida 
        port_out_00 : out std_logic_vector(7 downto 0);
		  port_out_01 : out std_logic_vector(7 downto 0)
    );
end component;

component DecoHexadecimal is
    port(
       A : in  std_logic_vector(3 downto 0);
       Display_0 : out std_logic_vector(6 downto 0)
    );
end component;

    -- Señales internas
    signal data_out_sig : std_logic_vector(7 downto 0);

begin

    -- Instancia de la memoria completa
    MEMORY1 : memory
        port map (
            address      => address_switches,
            data_in      => data_in,
            data_out     => data_out_sig,
            writen       => writen,
            clock        => clock,
            reset        => reset,
				port_in_00   => x"11",  -- 17 decimal
            port_in_01   => x"22",  -- 34 decimal
            port_in_02   => x"33",  -- 51 decimal
            port_in_03   => x"44",  -- 68 decimal
            port_in_04   => x"55",  -- 85 decimal
            port_in_05   => x"66",  -- 102 decimal
            port_in_06   => x"77",  -- 119 decimal
            port_in_07   => x"88",  -- 136 decimal
            port_in_08   => x"99",  -- 153 decimal
            port_in_09   => x"AA",  -- 170 decimal
            port_in_10   => x"BB",  -- 187 decimal
            port_in_11   => x"CC",  -- 204 decimal
            port_in_12   => x"DD",  -- 221 decimal
            port_in_13   => x"EE",  -- 238 decimal
            port_in_14   => x"F0",  -- 240 decimal
            port_in_15   => x"FF",  -- 255 decimal
            port_out_00  => port_out_00,
				port_out_01  => port_out_01
        );

    -- Decodificadores para ADDRESS (dos displays hex)
    DISPLAY1A : DecoHexadecimal
        port map (
            A => address_switches(7 downto 4),
            Display_0 => display1_address
        );

    DISPLAY2A : DecoHexadecimal
        port map (
            A => address_switches(3 downto 0),
            Display_0 => display2_address
        );

    -- Decodificadores para DATA_OUT (dos displays hex)
    DEC_DATA_HI : DecoHexadecimal
        port map (
            A => data_out_sig(7 downto 4),
            Display_0 => display1_dataout
        );

    DEC_DATA_LO : DecoHexadecimal
        port map (
            A => data_out_sig(3 downto 0),
            Display_0 => display2_dataout
        );

end arch_memory_test;
