library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OutputPorts16 is

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
end OutputPorts16;


architecture arch_OutputPorts16 of OutputPorts16 is

begin

-- port_out_00 description : ADDRESS x"E0"
 U3 :process (clock, reset)
 begin
	if (reset = '0') then
		port_out_00 <= x"00";
	elsif (clock'event and clock='1') then
		if (address = x"E0" and writen = '1') then
		port_out_00 <= data_in;
		end if;
	end if;
 end process;
 -- port_out_01 description : ADDRESS x"E1"
 U4 :process (clock, reset)
 begin
	if (reset = '0') then
		port_out_01 <= x"00";
	elsif (clock'event and clock='1') then
		if (address = x"E1" and writen = '1') then
			port_out_01 <= data_in;
		end if;
	end if;
 end process;
	
end arch_OutputPorts16;
