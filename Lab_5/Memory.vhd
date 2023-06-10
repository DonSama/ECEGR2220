--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
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
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     		enout:  in std_logic;
	     		writein: in std_logic;
	     		dataout: out std_logic_vector(7 downto 0));
	end component;

	signal enouts: std_logic_vector(3 downto 0):= "0000";
	signal writins: std_logic_vector(3 downto 0) := "0000";
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
begin
	enouts <= (others => '0') 	when enout32 = '0' else
		(3 downto 2 => '1', others => '0')
	when enout16 = '0' else
		(3 downto 1 => '1', others => '0')
	when enout8 = '0' else
		(others => '1');
	writins <= (others => '1')
	when writein32 = '1' else
		(3 downto 2 => '0', others => '1')
	when writein16 = '1' else
		(3 downto 1 => '0', others => '1')
	when writein8 = '1' else
		(others => '0');
	reg32: for i in 4 downto 1 generate
		regi: register8 port map (datain((i*8-1) downto ((i-1)*8)), enouts(i-1), writins(i-1), dataout((i*8-1) downto ((i-1)*8)));

	end generate;
	-- insert code here.
end architecture biggermem;    
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) and WE = '1' and (to_integer(unsigned(Address(7 downto 0))) >= 0)
		and (to_integer(unsigned(Address)) <= 127) then
		i_ram(to_integer(unsigned(Address(7 downto 0)))) <= DataIn;
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	
    end if;
		if(OE = '0') and (to_integer(unsigned(Address)) < 127) and (to_integer(unsigned(Address)) >= 0) then
			DataOut <= i_ram(to_integer(unsigned(Address(7 downto 0))));
		else
			DataOut <= (others => 'Z');
	end if;

	-- Rest of the RAM implementation

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
SIGNAL regWrite: std_logic_vector(31 downto 1);
TYPE dataArray is Array(31 downto 1) of std_logic_vector(31 downto 0);
SIGNAL regData: dataArray := (OTHERS=>(OTHERS=>'0'));
	
begin
	regWrite <= (1 => '1', OTHERS => '0') WHEN WriteReg = "00001" AND WriteCmd = '1' ELSE
			(2 => '1', OTHERS => '0') WHEN WriteReg = "00010" AND WriteCmd = '1' ELSE
			(3 => '1', OTHERS => '0') WHEN WriteReg = "00011" AND WriteCmd = '1' ELSE
			(4 => '1', OTHERS => '0') WHEN WriteReg = "00100" AND WriteCmd = '1' ELSE
			(5 => '1', OTHERS => '0') WHEN WriteReg = "00101" AND WriteCmd = '1' ELSE
			(6 => '1', OTHERS => '0') WHEN WriteReg = "00110" AND WriteCmd = '1' ELSE
			(7 => '1', OTHERS => '0') WHEN WriteReg = "00111" AND WriteCmd = '1' ELSE
			(8 => '1', OTHERS => '0') WHEN WriteReg = "01000" AND WriteCmd = '1' ELSE
			(9 => '1', OTHERS => '0') WHEN WriteReg = "01001" AND WriteCmd = '1' ELSE
		    (10 => '1', OTHERS => '0') WHEN WriteReg ="01010" AND WriteCmd = '1' ELSE
		    (11 => '1', OTHERS => '0') WHEN WriteReg ="01011" AND WriteCmd = '1' ELSE
	  	    (12 => '1', OTHERS => '0') WHEN WriteReg ="01100" AND WriteCmd = '1' ELSE
		    (13 => '1', OTHERS => '0') WHEN WriteReg ="01101" AND WriteCmd = '1' ELSE
		    (14 => '1', OTHERS => '0') WHEN WriteReg = "01110" AND WriteCmd = '1' ELSE
		    (15 => '1', OTHERS => '0') WHEN WriteReg ="01111" AND WriteCmd = '1' ELSE
		    (16 => '1', OTHERS => '0') WHEN WriteReg ="10000" AND WriteCmd = '1' ELSE
		(17 => '1', OTHERS => '0') WHEN WriteReg ="10001" AND WriteCmd = '1' ELSE
		(18 => '1', OTHERS => '0') WHEN WriteReg ="10010" AND WriteCmd = '1' ELSE


		    (OTHERS => '0');
	
	
	RegisterMap: FOR i in 31 downto 1 GENERATE
		xi: register32 PORT MAP(WriteData, '0', '1', '1', regWrite(i), '0', '0', regData(i));
	END GENERATE;
		
	WITH ReadReg1 SELECT
		ReadData1 <= regData(1) WHEN "00001",
				regData(2) WHEN "00010",
				regData(3) WHEN "00011",
				regData(4) WHEN "00100",
				regData(5) WHEN "00101",
				regData(6) WHEN "00110",
				regData(7) WHEN "00111",
				regData(8) WHEN "01000",
				regData(9) WHEN "01001",
				regData(10) WHEN "01010",
				regData(11) WHEN "01011",
				regData(12) WHEN "01100",
				regData(13) WHEN "01101",
				regData(14) WHEN "01110",
				regData(15) WHEN "01111",
				regData(16) WHEN "10000",
				regData(17) WHEN "10001",
				regData(18) WHEN "10010",
			

			    (OTHERS => '0') WHEN OTHERS;

	WITH ReadReg2 SELECT
		ReadData2 <= regData(1) WHEN "00001",
					regData(2) WHEN "00010",
					regData(3) WHEN "00011",
					regData(4) WHEN "00100",
					regData(5) WHEN "00101",
					regData(6) WHEN "00110",
					regData(7) WHEN "00111",
					regData(8) WHEN "01000",
					regData(9) WHEN "01001",
					regData(10) WHEN "01010",
					regData(11) WHEN "01011",
					regData(12) WHEN "01100",
					regData(13) WHEN "01101",
					regData(14) WHEN "01110",
					regData(15) WHEN "01111",
					regData(16) WHEN "10000",
					regData(17) WHEN "10001",
					regData(18) WHEN "10010",

					(OTHERS => '0') WHEN OTHERS;
    -- Add your code here for the Register Bank implementation

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

