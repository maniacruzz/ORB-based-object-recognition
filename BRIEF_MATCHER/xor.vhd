
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor1 is
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic;
    in1     : in  std_logic;
    out_xor : out std_logic
    );
end xor1;

architecture BHV of xor1 is
begin
X_or : process(clk)
begin
  if clk='1' and clk'event then
	if rst='1' then
	    out_xor<='1';
	elsif ce='1' then
	    out_xor<=in0 xor in1;
	end if;
  end if;
end process X_or; 


end BHV;


