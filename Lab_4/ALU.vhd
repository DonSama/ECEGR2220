--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	signal tempResult: std_logic_vector(31 downto 0);
	signal addSubResult: std_logic_vector(31 downto 0);
	signal shiftResult: std_logic_vector(31 downto 0);

begin
	-- LU VHDL implementation added here
	-- add, sub, addi
	addSubComp: adder_subtracter port map(	datain_a => DataIn1,
						datain_b => DataIn2,
						add_sub => ALUCtrl(4),
						dataout => addSubResult,
						co => open);

	-- sll, slli, srl, srli
	shiftComp: shift_register port map(	datain => DataIn1,
						dir => ALUCtrl(4),
						shamt => DataIn2(4 downto 0),
						dataout => shiftResult);

	--ALU control signal decoding and output assignment
	with ALUCtrl select
    	tempResult <= DataIn2 when "00000",
      	addSubResult when "00001" | "10010"|"00011",
     	DataIn1 and DataIn2 when "00100" | "00101",
     	DataIn1 or DataIn2 when "00110"|"00111",
     	shiftResult when "01000" | "11000",
	shiftResult when "01100" | "11100",
	(others => 'X') when others;

 	-- Assign Zero output
	Zero <= '1' when tempResult = "00000000000000000000000000000000" else '0';

	-- Assign ALUResult output
 	ALUResult <= tempResult;
end architecture ALU_Arch;

-- borrowing parts from Lab 3
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	-- inserted code
	U0: bitstorage port map(datain(0), enout, writein, dataout(0));
	U1: bitstorage port map(datain(1), enout, writein, dataout(1));
	U2: bitstorage port map(datain(2), enout, writein, dataout(2));
	U3: bitstorage port map(datain(3), enout, writein, dataout(3));
	U4: bitstorage port map(datain(4), enout, writein, dataout(4));
	U5: bitstorage port map(datain(5), enout, writein, dataout(5));
	U6: bitstorage port map(datain(6), enout, writein, dataout(6));
	U7: bitstorage port map(datain(7), enout, writein, dataout(7));
	
end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- register8 placed here
	component register8
		port(datain: in std_logic_vector(7 downto 0);
			enout: in std_logic;
			writein: in std_logic;
			dataout: out std_logic_vector(7 downto 0));
	end component;

	signal enouts: std_logic_vector(3 downto 0):= "0000";
	signal writins: std_logic_vector(3 downto 0):= "0000";
begin
	-- code inserted
	enouts <= (others => '0') when enout32 = '0' else
	(3 downto 2 => '1', others => '0') when enout16 = '0' else
	(3 downto 1 => '1', others => '0') when enout8 = '0' else
	(others => '1');

	writins <= (others => '1') when writein32 = '1' else
	(3 downto 2 => '0', others => '1') when writein16 = '1' else
	(3 downto 1 => '0', others => '1') when writein8 = '1' else
	(others => '0');
	reg32: for i in 4 downto 1 generate
		regi: register8 port map(datain((i*8 - 1) downto((i - 1)*8)), enouts(i - 1), writins(i - 1), dataout((i*8 - 1) downto((i-1)*8)));
	end generate;
	
end architecture biggermem;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	signal carries: std_logic_vector(31 downto 0);
	signal b_not_b: std_logic_vector(31 downto 0);

	-- place fulladder here so I can use it
	component fulladder
		port(	a: in std_logic;
			b: in std_logic;
			cin: in std_logic;
			sum: out std_logic;
			carry: out std_logic);
	end component;

begin
	-- code inserted
	b_not_b <= datain_b when add_sub = '0' else NOT datain_b;
	F0: fulladder port map(datain_a(0), b_not_b(0), add_sub, dataout(0), carries(0));
	generate_add_sub: for i in 1 to 31 generate
		F: fulladder port map(datain_a(i), b_not_b(i), carries(i-1), dataout(i), carries(i));
		end generate;
end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	-- code inserted
	dataout <= (datain(30 downto 0) & '0') when (dir = '0' and shamt = "00001") else
	(datain(29 downto 0) & "00") when (dir = '0' and shamt = "00010") else
	(datain(28 downto 0) & "000") when (dir = '0' and shamt = "00011") else
	('0' & datain(31 downto 1)) when (dir = '1' and shamt = "00001") else 
	("00" & datain(31 downto 2)) when (dir = '1' and shamt = "00010") else
	("000" & datain(31 downto 3)) when (dir = '1' and shamt = "00011") else 
	datain;
end architecture shifter;
