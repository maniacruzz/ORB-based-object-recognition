library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.libv.all;
use work.pgm.all;
use work.Amogh_pkg.all;

entity tb is
end entity tb;

architecture test of tb is
  signal  clk : std_logic:= '0';
  signal  rst:  std_logic;
  signal  ce : std_logic;
  signal  data_in0 : std_logic_vector(255 downto 0) := (others => '0');
    signal  data_in1 : std_logic_vector(255 downto 0) := (others => '1');
  signal  data_out0 :  std_logic_vector(8 downto 0) := (others => '0');
  signal  data_out1 :  std_logic_vector(9 downto 0) := (others => '0');
  signal  ind :  std_logic_vector(9 downto 0):= (others => '0');

component adder_tree is
  generic (
    width :     positive := 256);
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(width-1 downto 0);
    sum_out     : out std_logic_vector(8 downto 0)
    );
end component;

component xor_256 is
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(255 downto 0);
    in1     : in  std_logic_vector(255 downto 0);
    out_xor_256 : out std_logic_vector(255 downto 0)
    );
end component;

component matching_core is
  generic (
    width :     positive := 256);
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(width-1 downto 0);
    in1     : in  std_logic_vector(width-1 downto 0);
    index   : in  std_logic_vector(9 downto 0);
    best_index   : out std_logic_vector(9 downto 0);
    hamdist : out std_logic_vector(8 downto 0)
    );
end component;

component best_match is
  generic (
    width :     positive := 9);
  port (
    clk, rst, ce : in std_logic;
    in0   : in  std_logic_vector(width-1 downto 0);
    in1   : in  std_logic_vector(width-1 downto 0);
    smallest    : out std_logic_vector(width-1 downto 0));
end component;

begin  -- architecture test
process begin 
 
  rst <= '1';
  wait for 300 ns; 
  rst <= '0';
   
  wait;
end process;
     
uut: matching_core
  generic map(
    width => 256)
  port map(
  			clk => clk,			 
			rst  => rst,
			ce => ce,
			in0 => data_in0,
			in1 => data_in1,
			index => ind,
			hamdist => data_out0,
			best_index=> data_out1
		);



clk <= not clk after 10 ns; 

			    
test2:  process is 

begin 
  wait for 300 ns;
  ce <= '1';
  wait until rising_edge(clk);
 for i in 0 to 26 loop
     data_in0 <=std_logic_vector(to_unsigned(6532,256));
     data_in1 <=std_logic_vector(to_unsigned(i,256));
     ind <= std_logic_vector (to_unsigned(i+1,10));
     wait until rising_edge(clk);
 end loop;
 
 
end process test2;

end test;

