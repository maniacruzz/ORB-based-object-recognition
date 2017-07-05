library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity wrapper is
 port (
    clk, rst, ce : in std_logic;
    data_out0     : out  std_logic_vector(8 downto 0);
    data_out1     : out  std_logic_vector(9 downto 0)
    );
end entity wrapper;

architecture BHV of wrapper is

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

begin  -- architecture test
  
uut: matching_core
  generic map(
    width => 256)
  port map(
  			clk => clk,			 
			rst  => rst,
			ce => ce,
			in0 => (others => '1'),
			in1 => std_logic_vector(to_unsigned(0,256)),
			index => std_logic_vector(to_unsigned(5,10)),
			hamdist => data_out0,
			best_index=> data_out1
		);


end BHV;

