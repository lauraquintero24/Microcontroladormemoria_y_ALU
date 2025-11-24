library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port
	(
		-- Input ports
		A	: in  std_logic_vector(7 downto 0);
		B	: in  std_logic_vector(7 downto 0);
		ALU_Sel : std_logic_vector(1 downto 0);
		Result : out std_logic_vector (7 downto 0);
		NZVC : out std_logic_vector (3 downto 0)
	);
end alu;


architecture arch_alu of alu is

begin

ALU_PROCESS : process (A, B, ALU_Sel)
	variable Sum_uns : unsigned (8 downto 0);
	variable Diff_uns : unsigned (8 downto 0);
	begin 
		if (ALU_Sel = "00") then -- ADDITION
			--- Sum Calculation ----------------------------
			Sum_uns := unsigned ('0' & A) + unsigned ('0' & B);
			Result <= std_logic_vector(Sum_uns(7 downto 0));
		
			---Negative Flag (N)----------------------------
			NZVC(3) <= Sum_uns(7);
		
			---Zero Flag (Z)----------------------------------
			if (Sum_uns(7 downto 0) = x"00") then
				NZVC(2) <= '1';
			else 
				NZVC(2) <= '0';
			end if;
		
			--- Overflow Flag (V)-----------------------------
			if ((A(7)='0' and B(7)='0' and Sum_uns(7)='1') or
				(A(7)='1' and B(7)='1' and Sum_uns(7)='0')) then
				NZVC(1) <= '1';
			else 
				NZVC(1) <= '0';
			end if;
		
			--- Carry Flag (C)---------------------------------
			NZVC(0) <= Sum_uns(8);
	
	--- Other ALU functionality goes here
	   elsif (ALU_Sel = "01") then  -- SUBTRACTION
		      --- Diff Calculation ----------------------------
            Diff_uns := unsigned('0' & A) - unsigned('0' & B);
            Result <= std_logic_vector(Diff_uns(7 downto 0));
				
             ---Negative Flag (N)----------------------------
				NZVC(3) <= Diff_uns(7);
				
				---Zero Flag (Z)----------------------------------
            if (Diff_uns(7 downto 0) = x"00") then
					NZVC(2) <= '1';
            else 
               NZVC(2) <= '0';
            end if;

            --- Overflow Flag (V)-----------------------------
				if ((A(7)='0' and B(7)='1' and Diff_uns(7)='1') or
               (A(7)='1' and B(7)='0' and Diff_uns(7)='0')) then
               NZVC(1) <= '1';
            else 
               NZVC(1) <= '0';
            end if;
            
				--- Carry Flag (C)---------------------------------
            NZVC(0) <= Diff_uns(8);

        --elsif (ALU_Sel = "010") then  -- AND
            --Result <= A and B;
            --NZVC(3) <= Result(7);
            --if (Result = x"00") then NZVC(2) <= '1'; else NZVC(2) <= '0'; end if;
            --NZVC(1) <= '0';
            --NZVC(0) <= '0';

        --elsif (ALU_Sel = "011") then  -- OR
            --Result <= A or B;
            --NZVC(3) <= Result(7);
            --if (Result = x"00") then NZVC(2) <= '1'; else NZVC(2) <= '0'; end if;
            --NZVC(1) <= '0';
            --NZVC(0) <= '0';

        --elsif (ALU_Sel = "100") then  -- XOR
            --Result <= A xor B;
            --NZVC(3) <= Result(7);
            --if (Result = x"00") then NZVC(2) <= '1'; else NZVC(2) <= '0'; end if;
            ---NZVC(1) <= '0';
            --NZVC(0) <= '0';

        --elsif (ALU_Sel = "101") then  -- NOT A
           -- Result <= not A;
            --NZVC(3) <= Result(7);
            --if (Result = x"00") then NZVC(2) <= '1'; else NZVC(2) <= '0'; end if;
            --NZVC(1) <= '0';
            --NZVC(0) <= '0';

        --elsif (ALU_Sel = "110") then  -- SHIFT LEFT
            --Result <= A(6 downto 0) & '0';
            --NZVC(3) <= Result(7);
            --if (Result = x"00") then NZVC(2) <= '1'; else NZVC(2) <= '0'; end if;
            --NZVC(1) <= '0';
            --NZVC(0) <= A(7);

        --elsif (ALU_Sel = "111") then  -- SHIFT RIGHT
            --Result <= '0' & A(7 downto 1);
            --NZVC(3) <= Result(7);
            --if (Result = x"00") then NZVC(2) <= '1'; else NZVC(2) <= '0'; end if;
            ---NZVC(1) <= '0';
            --NZVC(0) <= A(0);

         else
				Result <= (others => '0');
				NZVC <= (others => '0');
	
	    end if;
	
end process;

end arch_alu;



		
		