
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.Amogh_pkg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delay_corner is
generic (delay :  integer := 24972
	 );
port(
		
		clk, rst, ce : in std_logic;
		corner_in  : in std_logic;
		corner_out : out std_logic
	);
end delay_corner;

architecture Behavioral of delay_corner is
type ram is array (delay-1 downto 0) of std_logic; 
signal delay_ram : ram;
attribute ram_style: string; 
attribute ram_style of delay_ram : signal is "block";

begin

do_delay : process(clk)
begin
	if clk'event and clk='1' then
		if rst='1' then
			delay_ram <= (others => '0');
		elsif ce='1' then
			delay_ram(0)<=corner_in;
			for i in 0 to delay-2 loop
				delay_ram(i+1)<=delay_ram(i);
			end loop;
			corner_out<=delay_ram(delay-1);
		end if;
	end if;
end process do_delay;

end Behavioral;

