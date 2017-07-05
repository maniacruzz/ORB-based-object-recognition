library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matching_core is
  generic (
    width :     positive := 32);
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(width-1 downto 0);
    in1     : in  std_logic_vector(width-1 downto 0);
    x_coord : in  std_logic_vector(10 downto 0);
    y_coord : in  std_logic_vector(10 downto 0);
    index   : in  std_logic_vector(9 downto 0);
    x_coord_out : out  std_logic_vector(10 downto 0);
    y_coord_out : out  std_logic_vector(10 downto 0);
    best_index   : out std_logic_vector(9 downto 0);
    hamdist : out std_logic_vector(8 downto 0)
    );
end matching_core;

architecture BHV of matching_core is
signal out_xor_reg : std_logic_vector(255 downto 0);
signal hamdist_reg : std_logic_vector(8 downto 0);
signal small_reg : std_logic_vector(8 downto 0);
signal d_index : std_logic_vector(9 downto 0);
signal in0_reg,in1_reg : std_logic_vector(255 downto 0);
attribute keep:string;
attribute keep of in0_reg,in1_reg : signal is "true";
component xor_256 is
  generic (
    width :     positive := 256);
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(width-1 downto 0);
    in1     : in  std_logic_vector(width-1 downto 0);
    out_xor_256 : out std_logic_vector(width-1 downto 0)
    );
end component;

component adder_tree is
  generic (
    width :     positive := 256);
  port (
    clk, rst, ce : in std_logic;
    in0     : in  std_logic_vector(width-1 downto 0);
    sum_out     : out std_logic_vector(8 downto 0)
    );
end component;

component best_match is
  generic (
    width :     positive := 9);
  port (
    clk, rst, ce : in std_logic;
    in0   : in  std_logic_vector(width-1 downto 0);
    in1   : in  std_logic_vector(width-1 downto 0);
    index : in  std_logic_vector(9 downto 0);
    smallest    : out std_logic_vector(width-1 downto 0);
    best_index : out std_logic_vector(9 downto 0)
    );
end component;

component delay is
generic (delay :  integer := 8;
	 width :  integer  := 10
	 );
port(
		
		clk, rst, ce : in std_logic;
		inD  : in std_logic_vector(width-1 downto 0);
		outD : out std_logic_vector(width-1 downto 0)
	);
end component;

begin

in0_reg<=std_logic_vector(resize(unsigned(in0),256));
in1_reg<=std_logic_vector(resize(unsigned(in1),256));


delay_index : delay 
generic map(delay => 8,
	 width => 10
	 )
port map(
    			clk => clk,			 
			rst  => rst,
			ce => ce,
			inD => index,
			outD => d_index
	);
     
x_256 : xor_256
  generic map(
    width => 256)
  port map(
    			clk => clk,			 
			rst  => rst,
			ce => ce,
			in0 => in0_reg,
			in1 => in1_reg,
			out_xor_256 => out_xor_reg
		);
      
hamdistance : adder_tree
  generic map(
    width => 256)
  port map(
    			clk => clk,			 
			rst  => rst,
			ce => ce,
			in0 => out_xor_reg,
			sum_out => hamdist_reg
		);

best_hamm : best_match 
  generic map(
    width => 9)
  port map(
 			clk => clk,			 
			rst  => rst,
			ce => ce,
			in0 => hamdist_reg,
			in1 => small_reg,
			index => d_index,
			best_index => best_index,
			smallest=>small_reg
	  );
hamdist<=small_reg;
end BHV;


