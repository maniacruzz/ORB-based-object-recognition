
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity delay is
generic (delay :  integer := 9;
	 width :  integer  := 10
	 );
port(
		
		clk, rst, ce : in std_logic;
		inD  : in std_logic_vector(width-1 downto 0);
		outD : out std_logic_vector(width-1 downto 0)
	);
end delay;

architecture Behavioral of delay is
type d is array (delay-1 downto 0) of std_logic_vector(width-1 downto 0); 
signal delay_sig : d;

begin

do_delay : process(clk)
begin
	if clk'event and clk='1' then
		if rst='1' then
			delay_sig <= (others => (others => '0'));
			outD <= (others => '0');
		elsif ce='1' then
			delay_sig(0)<=inD;
			for i in 0 to delay-2 loop
				delay_sig(i+1)<=delay_sig(i);
			end loop;
			outD<=delay_sig(delay-1);
		end if;
	end if;
end process do_delay;

end Behavioral;

