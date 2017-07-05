library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.libv.all;
use work.pgm.all;
use work.Amogh_pkg.all;

entity delay_xy_tb is
end entity delay_xy_tb;

architecture test of delay_xy_tb is
  signal  clk : std_logic:= '0';
  signal  rst:  std_logic;
  signal  ce : std_logic;
  signal  x_coord : unsigned(10 downto 0);
  signal  y_coord :  unsigned(10 downto 0);

	
component delay_xy is
generic (
				depth: integer :=1920;	-- horizontal resolution
				v_res : integer :=1080 	-- vertical resolution	
				);
port(
	clk,ce,rst: in std_logic;
	x_coord,y_coord: out unsigned(10 downto 0)

	);
end component;

begin  -- architecture test
process begin 
 
  rst <= '1';
  wait for 300 ns; 
  rst <= '0';
   
  wait;
end process;
     
uut: delay_xy
port map(
			clk => clk,			 
			rst  => rst,
			ce => ce,
			x_coord => x_coord, 
			y_coord =>  y_coord
		);
      
      
clk <= not clk after 10 ns; 

			    
test2:  process is 

variable width : integer  :=1920;
variable height : integer :=1080;

begin 
  wait until rising_edge(clk);
  ce <= '1';
  wait until rising_edge(clk);
 if(x_coord= height-1 and y_coord =width-1) then
   assert false report "Simulation Finished" severity failure;
   wait;
 end if;  
  
end process test2;

end test;

