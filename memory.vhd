library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
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
end memory;

architecture arch_memory of memory is

component rom_128x8_sync 
	port
	(
		-- Input ports
		address	: in std_logic_vector(7 downto 0);
		clock	: in std_logic;

		-- Output ports
		data_out	: out std_logic_vector(7 downto 0)
	);
end component;

component rw_96x8_sync 

	port
	(
		-- Input ports
		address	: in  std_logic_vector(7 downto 0);
		data_in	: in  std_logic_vector(7 downto 0);
		writen   : in  std_logic;
		clock    : in std_logic;

		-- Output ports
		data_out	: out std_logic_vector(7 downto 0)
	);
end component;

component OutputPorts16 

	port
	(
		-- Input ports
		address	: in  std_logic_vector(7 downto 0);
		data_in	: in  std_logic_vector(7 downto 0);
		writen   : in std_logic;
		clock    : in std_logic;
		reset    : in std_logic; 

		-- Output ports
		port_out_00 : out std_logic_vector(7 downto 0);
		port_out_01 : out std_logic_vector(7 downto 0)
	);
end component;


    -- Señales internas de conexión
    signal rom_data_out : std_logic_vector(7 downto 0);
    signal rw_data_out  : std_logic_vector(7 downto 0);
	 signal port_out_00_sig : std_logic_vector(7 downto 0);
    signal port_out_01_sig : std_logic_vector(7 downto 0);

begin

    -- Multiplexor de salida (selecciona qué bloque alimenta data_out)

    MUX1 : process(address, rom_data_out, rw_data_out,
                   port_in_00, port_in_01, port_in_02, port_in_03,
                   port_in_04, port_in_05, port_in_06, port_in_07,
                   port_in_08, port_in_09, port_in_10, port_in_11,
                   port_in_12, port_in_13, port_in_14, port_in_15)
    begin
        if ((to_integer(unsigned(address)) >= 0) and
           (to_integer(unsigned(address)) <= 127)) then
            data_out <= rom_data_out; -- ROM

        elsif ((to_integer(unsigned(address)) >= 128) and
              (to_integer(unsigned(address)) <= 223)) then
            data_out <= rw_data_out;  -- RAM
				
			-- Output ports: E0h - E1h
         elsif (address = x"E0") then
			data_out <= port_out_00_sig;

			elsif (address = x"E1") then
				data_out <= port_out_01_sig;

        elsif (address = x"F0") then data_out <= port_in_00;
        elsif (address = x"F1") then data_out <= port_in_01;
        elsif (address = x"F2") then data_out <= port_in_02;
        elsif (address = x"F3") then data_out <= port_in_03;
        elsif (address = x"F4") then data_out <= port_in_04;
        elsif (address = x"F5") then data_out <= port_in_05;
        elsif (address = x"F6") then data_out <= port_in_06;
        elsif (address = x"F7") then data_out <= port_in_07;
        elsif (address = x"F8") then data_out <= port_in_08;
        elsif (address = x"F9") then data_out <= port_in_09;
        elsif (address = x"FA") then data_out <= port_in_10;
        elsif (address = x"FB") then data_out <= port_in_11;
        elsif (address = x"FC") then data_out <= port_in_12;
        elsif (address = x"FD") then data_out <= port_in_13;
        elsif (address = x"FE") then data_out <= port_in_14;
        elsif (address = x"FF") then data_out <= port_in_15;

        else
            data_out <= x"00";
        end if;
    end process;

    ROM1 : rom_128x8_sync
        port map (
            address  => address,
            clock    => clock,
            data_out => rom_data_out
        );

    RAM1 : rw_96x8_sync
        port map (
            address  => address,
            data_in  => data_in,
            writen   => writen,
            clock    => clock,
            data_out => rw_data_out
        );

	OUTPORTS1 : OutputPorts16
    port map (
        address      => address,
        data_in      => data_in,
        writen       => writen,
        clock        => clock,
        reset        => reset,
        port_out_00  => port_out_00_sig,
        port_out_01  => port_out_01_sig
    );
	 
   port_out_00 <= port_out_00_sig;
   port_out_01 <= port_out_01_sig;
	
end arch_memory;
