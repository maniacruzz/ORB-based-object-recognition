
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_tree is
  generic (
    width :     positive := 256);
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(width-1 downto 0);
    sum_out     : out std_logic_vector(8 downto 0)
    );
end adder_tree;



architecture Behavioral of adder_tree is

type sum1 is array (127 downto 0) of unsigned(1 downto 0);
type sum2 is array (63 downto 0) of unsigned(2 downto 0);
type sum3 is array (31 downto 0) of unsigned(3 downto 0);
type sum4 is array (15 downto 0) of unsigned(4 downto 0);
type sum5 is array (7 downto 0) of unsigned(5 downto 0);
type sum6 is array (3 downto 0) of unsigned(6 downto 0);
type sum7 is array (1 downto 0) of unsigned(7 downto 0);

signal sum_level1 : sum1;
signal sum_level2 : sum2;
signal sum_level3 : sum3;
signal sum_level4 : sum4;
signal sum_level5 : sum5;
signal sum_level6 : sum6;
signal sum_level7 : sum7;
--signal sum_out_reg : unsigned(8 downto 0);


begin

  adder_tree : process(clk)
  begin
      if clk='1' and clk'event then
	    if rst='1' then
		sum_out    <= (others => '1');
		sum_level1 <= (others => (others => '1'));
		sum_level2 <= (others => (others => '1'));
		sum_level3 <= (others => (others => '1'));
		sum_level4 <= (others => (others => '1'));
		sum_level5 <= (others => (others => '1'));
		sum_level6 <= (others => (others => '1'));
		sum_level7 <= (others => (others => '1'));
	    elsif ce='1' then
		for i in 0 to 127 loop
		    sum_level1(i)<=unsigned('0'&in0(2*i downto 2*i)) + unsigned('0'&in0(2*i+1 downto 2*i+1));
		end loop; 
		
		for i in 0 to 63 loop
		    sum_level2(i)<=('0'&sum_level1(2*i)) + ('0'&sum_level1(2*i+1));
		end loop; 
		
		for i in 0 to 31 loop
		    sum_level3(i)<=('0'&sum_level2(2*i)) + ('0'&sum_level2(2*i+1));
		end loop; 
		
		for i in 0 to 15 loop
		    sum_level4(i)<=('0'&sum_level3(2*i)) + ('0'&sum_level3(2*i+1));
		end loop; 
		
		for i in 0 to 7 loop
		    sum_level5(i)<=('0'&sum_level4(2*i)) + ('0'&sum_level4(2*i+1));
		end loop; 
		
		for i in 0 to 3 loop
		    sum_level6(i)<=('0'&sum_level5(2*i)) + ('0'&sum_level5(2*i+1));
		end loop; 

		for i in 0 to 1 loop
		    sum_level7(i)<=('0'&sum_level6(2*i)) + ('0'&sum_level6(2*i+1));
		end loop;		
		
		sum_out<=std_logic_vector(('0'&sum_level7(0))+('0'&sum_level7(1)));
	    end if;
      end if;
  end process adder_tree;  

  --sum_out<=std_logic_vector(sum_out_reg);
  
end Behavioral;

