library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_128x8_sync is
	port
	(
		-- Input ports
		address	: in std_logic_vector(7 downto 0);
		clock	: in std_logic;

		-- Output ports
		data_out	: out std_logic_vector(7 downto 0)
	);
end rom_128x8_sync;


architecture arch_rom_128x8_sync of rom_128x8_sync is

    type rom_type is array (0 to 127) of std_logic_vector(7 downto 0);

    constant LDA_IMM : std_logic_vector(7 downto 0) := x"86"; --Carga con un valor inmediato
    constant STA_DIR : std_logic_vector(7 downto 0) := x"96"; --Guarda en dirección directa
    constant BRA     : std_logic_vector(7 downto 0) := x"20"; --Salta siempre
	 
	
    constant ROM : rom_type := ( 0 => LDA_IMM,  -- Carga A con un valor inmediato
											1 => x"AA",    -- Valor que se carga en A
											2 => STA_DIR,  -- Almacena A en dirección directa
											3 => x"E0",    -- Dirección donde se guarda A
											4 => BRA,      -- Salta siempre
											5 => x"00",    -- Dirección de salto (inicio)
											others => x"00" -- Sin uso
    );

    signal EN : std_logic; -- Señal interna de habilitación
begin

   enable : process(address) --solo se activará cuando la dirección esté dentro del rango válido de memoria del programa de 0 a 127
		begin
			if (to_integer(unsigned(address)) >= 0) and 
				(to_integer(unsigned(address)) <= 127) then
            EN <= '1';
			else
            EN <= '0';
			end if;
	end process;
		
	memory : process(clock) --lectura sincronizada con el reloj
		begin
			if rising_edge(clock) then
            if (EN = '1') then
                data_out <= ROM(to_integer(unsigned(address)));
            else
                data_out <= (others => '0'); -- salida nula si está fuera del rango
            end if;
         end if;
   end process;


end arch_rom_128x8_sync;
