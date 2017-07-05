
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

entity brief_top is
port(				
			clk, rst, ce : in std_logic;
		  	desc_256bit : out std_logic_vector(255 downto 0);
			int00, int01, int02, int03, int04, int05, int06 : in std_logic_vector(7 downto 0);
			int10, int11, int12, int13, int14, int15, int16 : in std_logic_vector(7 downto 0);
			int20, int21, int22, int23, int24, int25, int26 : in std_logic_vector(7 downto 0);
			int30, int31, int32, int33, int34, int35, int36 : in std_logic_vector(7 downto 0);
			int40, int41, int42, int43, int44, int45, int46 : in std_logic_vector(7 downto 0);
			int50, int51, int52, int53, int54, int55, int56 : in std_logic_vector(7 downto 0);
			int60, int61, int62, int63, int64, int65, int66 : in std_logic_vector(7 downto 0)
		);
end brief_top;

architecture Behavioral of brief_top is


signal smooth_out_sg : std_logic_vector(7 downto 0);
signal smooth_patch : vector_8bit(1088 downto 0);
signal filter_output: std_logic_vector(7 downto 0);
signal desc_256bit_reg: std_logic_vector (255 downto 0);


component averaging_filter_7x7 is
port(
		in00, in01, in02, in03, in04, in05, in06 : in std_logic_vector(7 downto 0); 
		in10, in11, in12, in13, in14, in15, in16 : in std_logic_vector(7 downto 0); 
		in20, in21, in22, in23, in24, in25, in26 : in std_logic_vector(7 downto 0); 
		in30, in31, in32, in33, in34, in35, in36 : in std_logic_vector(7 downto 0);
		in40, in41, in42, in43, in44, in45, in46 : in std_logic_vector(7 downto 0);
		in50, in51, in52, in53, in54, in55, in56 : in std_logic_vector(7 downto 0);
		in60, in61, in62, in63, in64, in65, in66 : in std_logic_vector(7 downto 0);
		clk, rst, ce : in std_logic;
		smooth_out : out std_logic_vector(7 downto 0)
	);
end component;

component smooth_input_fifo is
generic (
				depth: integer :=1920;	-- bytes in FIFO (horizontal resolution)
				v_res : integer :=1080; 	-- vertical resolution				
				window_width : integer := 33
			);  
port(
		data_in : in std_logic_vector(7 downto 0);
		clk, rst, ce : in std_logic;								-- ce - global clock enable 
		smooth_patch : out vector_8bit(window_width*window_width-1 downto 0)
		);
end component;

component brief_desc_gen is
port(
		smooth_patch : in vector_8bit(1088 downto 0); 
		clk, rst, ce : in std_logic;
		desc_256bit : out std_logic_vector(255 downto 0)
	);
end component;

begin



smoothing : averaging_filter_7x7
port map (

					in00 => int00,
					in01 => int01,
					in02 => int02, 
					in03 => int03,
					in04 => int04,
					in05 => int05, 
					in06 => int06,
					
					in10 => int10,
					in11 => int11,
					in12 => int12, 
					in13 => int13,
					in14 => int14,
					in15 => int15, 
					in16 => int16,
					
					in20 => int20,
					in21 => int21,
					in22 => int22, 
					in23 => int23,
					in24 => int24,
					in25 => int25, 
					in26 => int26,
					
					in30 => int30,
					in31 => int31,
					in32 => int32, 
					in33 => int33,
					in34 => int34,
					in35 => int35, 
					in36 => int36,
					
					in40 => int40,
					in41 => int41,
					in42 => int42, 
					in43 => int43,
					in44 => int44,
					in45 => int45, 
					in46 => int46,
					
					in50 => int50,
					in51 => int51,
					in52 => int52, 
					in53 => int53,
					in54 => int54,
					in55 => int55, 
					in56 => int56,
					
					in60 => int60,
					in61 => int61,
					in62 => int62, 
					in63 => int63,
					in64 => int64,
					in65 => int65, 
					in66 => int66,
					
					smooth_out =>smooth_out_sg,

					clk => clk,
					rst => rst,
					ce => ce
		);

sliding_window_33x33 : smooth_input_fifo
port map (
	 		clk => clk,			 
			rst  => rst,
			ce => ce,
			data_in => smooth_out_sg,
			smooth_patch=> smooth_patch
  	 );

brief_generator : brief_desc_gen 
port map(
	smooth_patch => smooth_patch,
	clk => clk, 
	rst => rst,
	ce => ce,
	desc_256bit => desc_256bit_reg
	);
desc_256bit <= desc_256bit_reg;
end Behavioral;

