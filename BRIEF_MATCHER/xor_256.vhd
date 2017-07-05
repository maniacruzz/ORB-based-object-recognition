
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor_256 is
  generic (
    width :     positive := 256);
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(width-1 downto 0);
    in1     : in  std_logic_vector(width-1 downto 0);
    out_xor_256 : out std_logic_vector(width-1 downto 0)
    );
end xor_256;

architecture BHV of xor_256 is
signal out_xor_reg : std_logic_vector(255 downto 0);

component xor1 is
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic;
    in1     : in  std_logic;
    out_xor : out std_logic
    );
end component;

begin

xor_256 : for i in 0 to 255 generate
	xor_1 : xor1
		port map(
			clk => clk,			 
			rst  => rst,
			ce => ce,
			in0=>in0(i),
			in1=>in1(i),
			out_xor=>out_xor_reg(i)  );
end generate xor_256;

out_xor_256 <= (out_xor_reg);

end BHV;


