
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

entity delay_corner_BRAM is
generic (delay :  integer := 24974
	 );
port(
		
		clk, rst, ce : in std_logic;
		corner_in  : in std_logic;
		corner_out : out std_logic
	);
end delay_corner_BRAM;

architecture Behavioral of delay_corner_BRAM is
type ram is array (delay-1 downto 0) of std_logic; 
signal delay_ram : ram;
attribute ram_style: string; 
attribute ram_style of delay_ram : signal is "block";
signal corner_out_reg : std_logic;
signal address_read, address_write : unsigned(14 downto 0);
begin

do_delay : process(clk,rst)
begin
	if clk'event and clk='1' then
		if rst='1' then
			corner_out_reg<='0';
		elsif ce='1' then
			delay_ram(to_integer(unsigned(address_write)))<=corner_in;
			corner_out_reg<=delay_ram(to_integer(unsigned(address_read)));
		end if;
	end if;
end process do_delay;

address_generator : process(clk)
begin
	if clk='1' and clk'event then
		if rst='1' then
			address_read<=(others=>'0');
			address_write<=to_unsigned(1, 15);
		else		
			if ce='1' then
				if address_read=to_unsigned(delay-1, 15) then
					address_read<=(others=>'0');
				else
					address_read<=address_read+1;
				end if;
				address_write<=address_read;	
			end if;
		end if;
	end if;
end process address_generator;
corner_out<=corner_out_reg;

end Behavioral;

