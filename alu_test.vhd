library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_test is
    port(
        A_switches : in std_logic_vector(7 downto 0);
        B_switches : in std_logic_vector(7 downto 0);
        ALU_Sel    : in std_logic_vector(1 downto 0);

        -- Salidas a displays
        display1_B : out std_logic_vector(6 downto 0);
        display2_B : out std_logic_vector(6 downto 0);
		  display1_R : out std_logic_vector(6 downto 0);
        display2_R : out std_logic_vector(6 downto 0);
		  NZVC_leds  : out std_logic_vector(3 downto 0)
    );
end alu_test;

architecture arch_alu_test of alu_test is

    component alu 
        port(
            A        : in  std_logic_vector(7 downto 0);
            B        : in  std_logic_vector(7 downto 0);
            ALU_Sel  : in  std_logic_vector(1 downto 0);
            Result   : out std_logic_vector(7 downto 0);
            NZVC     : out std_logic_vector(3 downto 0)
        );
    end component;

    component DecoHexadecimal 
        port(
           A         : in std_logic_vector(3 downto 0);
           Display_0 : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Señales internas de la ALU
    signal alu_result : std_logic_vector(7 downto 0);
    signal alu_flags  : std_logic_vector(3 downto 0);

begin

    ALU1 : alu
        port map(
            A        => A_switches,
            B        => B_switches,
            ALU_Sel  => ALU_Sel,
            Result   => alu_result,
            NZVC     => alu_flags
        );
   
	NZVC_leds <= alu_flags;

    -- Displays de B
    DISPLAY1B : DecoHexadecimal
        port map (
            A => B_switches(7 downto 4),
            Display_0 => display1_B
        );

    DISPLAY2B : DecoHexadecimal
        port map (
            A => B_switches(3 downto 0),
            Display_0 => display2_B
        );
		  
	 -- Displays de Resultado
    DISPLAY1R : DecoHexadecimal
        port map (
            A => alu_result(7 downto 4),
            Display_0 => display1_R
        );

    DISPLAY2R : DecoHexadecimal
        port map (
            A => alu_result(3 downto 0),
            Display_0 => display2_R
        );

end arch_alu_test;

