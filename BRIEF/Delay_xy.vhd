
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delay_xy is
generic (
				depth: integer :=1920;	-- horizontal resolution
				v_res : integer :=1080 	-- vertical resolution	
				);
port(
	clk,ce,rst: in std_logic;
	x_coord,y_coord: out std_logic_vector(10 downto 0)

	);
end delay_xy;

architecture Behavioral of delay_xy is

signal count: unsigned(15 downto 0) := (others => '0');
signal xy_en : std_logic;
signal x_count,y_count: unsigned(10 downto 0);
--1920x3+4+8+1920x16+17+1=36510 Delay for coordinates (0,0)
constant val : unsigned(15 downto 0) := to_unsigned(36511,16);

begin

cnt : process(clk)
begin
	if clk='1' and clk'event then
		if rst='1' then
			count<=(others=>'0');
			xy_en<='0';
			x_count<=(others=>'0');
			y_count<=(others=>'0');
		elsif ce='1' then
			if (count<val) then
				count<=count+1;
				xy_en<='0';
			else
				count<=count;
				xy_en<='1';	
			end if;
			
			if(xy_en='1') then
				
				if x_count=to_unsigned(depth-1,11) then
					if y_count=to_unsigned(v_res-1, 11) then
						y_count<=to_unsigned(0,11);
					else 
						y_count<=y_count+1;
					end if;
					x_count<=to_unsigned(0,11);
				else
					x_count<=x_count+1;
				end if;
			end if;
		end if;
	end if;
end process cnt;

x_coord<=std_logic_vector(x_count);
y_coord<=std_logic_vector(y_count);
end Behavioral;

