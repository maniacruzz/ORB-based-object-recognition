library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fast_top is
port(				
			--data_in : in std_logic_vector(7 downto 0);
			clk, rst, ce : in std_logic;
			iscorner : out  std_logic;
			score : out std_logic_vector(12 downto 0);
			int02, int03, int04 : in std_logic_vector(7 downto 0); 
			int11, int15 : in std_logic_vector(7 downto 0);
			int20, int26 : in std_logic_vector(7 downto 0);
			int30, int33, int36 : in std_logic_vector(7 downto 0);
			int40, int46 : in std_logic_vector(7 downto 0);
			int51, int55 : in std_logic_vector(7 downto 0);
			int62, int63, int64 : in std_logic_vector(7 downto 0)
		);
end fast_top;

architecture Behavioral of fast_top is




signal int0b, int1b, int2b, int3b, int4b, int5b, int6b, int7b, int8b, int9b, int10b, int11b, int12b, int13b, int14b, int15b : std_logic_vector(9 downto 0); -- for corner score
signal int0d, int1d, int2d, int3d, int4d, int5d, int6d, int7d, int8d, int9d, int10d, int11d, int12d, int13d, int14d, int15d : std_logic_vector(9 downto 0);

signal bright_int, dark_int : std_logic_vector(15 downto 0);

component fast_main is
generic (threshold :  signed:= to_signed(10, 10) );
port(
		in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15 : in std_logic_vector(7 downto 0);
		clk, rst, ce : in std_logic;
		center : in std_logic_vector(7 downto 0);
		o0b, o1b, o2b, o3b, o4b, o5b, o6b, o7b, o8b, o9b, o10b, o11b, o12b, o13b, o14b, o15b : out std_logic_vector(9 downto 0);
		o0d, o1d, o2d, o3d, o4d, o5d, o6d, o7d, o8d, o9d, o10d, o11d, o12d, o13d, o14d, o15d : out std_logic_vector(9 downto 0);
		--result : out std_logic_vector(9 downto 0);
		bright, dark : out std_logic_vector(15 downto 0)
	);
end component;

component contig_processor is
port(
		input_d, input_b : in std_logic_vector(15 downto 0);
		clk, rst, ce : in std_logic;
		contig : out std_logic
		);
end component;

component corner_score is
port(
		output : out std_logic_vector(12 downto 0);
		i0b, i1b, i2b, i3b, i4b, i5b, i6b, i7b, i8b, i9b, i10b, i11b, i12b, i13b, i14b, i15b : in std_logic_vector(9 downto 0);
		i0d, i1d, i2d, i3d, i4d, i5d, i6d, i7d, i8d, i9d, i10d, i11d, i12d, i13d, i14d, i15d : in std_logic_vector(9 downto 0);
		clk, rst, ce : in std_logic
	);
end component;


begin


main_component : fast_main
port map (

					in0 => int03,
					in1 => int04,
					in2 => int15,
					in3 => int26,
					in4 => int36,
					in5 => int46,
					in6 => int55,
					in7 => int64,
					in8 => int63,
					in9 => int62,
					in10 => int51,
					in11 => int40,
					in12 => int30,
					in13 => int20,
					in14 => int11,
					in15 => int02,

					center => int33,
					
					o0b => int0b,
					o1b => int1b,
					o2b => int2b,
					o3b => int3b,
					o4b => int4b,
					o5b => int5b,
					o6b => int6b,
					o7b => int7b,
					o8b => int8b,
					o9b => int9b,
					o10b => int10b,
					o11b => int11b,
					o12b => int12b,
					o13b => int13b,
					o14b => int14b,
					o15b => int15b,

					o0d => int0d,
					o1d => int1d,
					o2d => int2d,
					o3d => int3d,
					o4d => int4d,
					o5d => int5d,
					o6d => int6d,
					o7d => int7d,
					o8d => int8d,
					o9d => int9d,
					o10d => int10d,
					o11d => int11d,
					o12d => int12d,
					o13d => int13d,
					o14d => int14d,
					o15d => int15d,

					bright => bright_int,
					dark => dark_int,

					clk => clk,
					rst => rst,
					ce => ce
		);

contiguity : contig_processor
port map(

					input_b => bright_int,
					input_d => dark_int,
					
					contig => iscorner,
					
					clk => clk,
					rst => rst,
					ce => ce
			);

fast_score : corner_score
port map(


					i0b => int0b,
					i1b => int1b,
					i2b => int2b,
					i3b => int3b,
					i4b => int4b,
					i5b => int5b,
					i6b => int6b,
					i7b => int7b,
					i8b => int8b,
					i9b => int9b,
					i10b => int10b,
					i11b => int11b,
					i12b => int12b,
					i13b => int13b,
					i14b => int14b,
					i15b => int15b,


					i0d => int0d,
					i1d => int1d,
					i2d => int2d,
					i3d => int3d,
					i4d => int4d,
					i5d => int5d,
					i6d => int6d,
					i7d => int7d,
					i8d => int8d,
					i9d => int9d,
					i10d => int10d,
					i11d => int11d,
					i12d => int12d,
					i13d => int13d,
					i14d => int14d,
					i15d => int15d,
					
					output => score,

					clk => clk,
					rst => rst,
					ce => ce

			);

end Behavioral;

