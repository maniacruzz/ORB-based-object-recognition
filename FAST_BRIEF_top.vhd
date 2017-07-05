
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FAST_BRIEF_top is
port(
			clk,rst,ce : in std_logic;
			pixel_in : in std_logic_vector(7 downto 0);
			iscorner : out std_logic;
			x_coord, y_coord : out std_logic_vector(10 downto 0);
			desc_256bit : out std_logic_vector(255 downto 0)
			--desc_256bit : out std_logic_vector(1 downto 0)
		);
end FAST_BRIEF_top;

architecture Behavioral of FAST_BRIEF_top is

signal x_coord_int, y_coord_int,x_coord_out, y_coord_out : std_logic_vector(10 downto 0);
signal score_int : std_logic_vector(12 downto 0);
signal iscorner_int ,corner_out_reg: std_logic;
signal int00, int01, int02, int03, int04, int05, int06 : std_logic_vector(7 downto 0); -- to FIFO
signal int10, int11, int12, int13, int14, int15, int16 : std_logic_vector(7 downto 0);
signal int20, int21, int22, int23, int24, int25, int26 : std_logic_vector(7 downto 0);
signal int30, int31, int32, int33, int34, int35, int36 : std_logic_vector(7 downto 0);
signal int40, int41, int42, int43, int44, int45, int46 : std_logic_vector(7 downto 0);
signal int50, int51, int52, int53, int54, int55, int56 : std_logic_vector(7 downto 0);
signal int60, int61, int62, int63, int64, int65, int66 : std_logic_vector(7 downto 0);
signal desc_256bit_reg: std_logic_vector (255 downto 0);
signal temp: std_logic_vector (127 downto 0);

component input_fifo is
generic (
				depth: integer :=1920;	
				v_res : integer :=1080 					
			);  
port(
		data_in : in std_logic_vector(7 downto 0);
		clk, rst, ce : in std_logic;								-- ce - global clock enable 
		x_coord : out std_logic_vector(10 downto 0);			-- delayed X coord.
		y_coord : out std_logic_vector(10 downto 0);			-- delayed Y coord.
		o00, o01, o02, o03, o04, o05, o06 : out std_logic_vector(7 downto 0); 
		o10, o11, o12, o13, o14, o15, o16 : out std_logic_vector(7 downto 0); 
		o20, o21, o22, o23, o24, o25, o26 : out std_logic_vector(7 downto 0); 
		o30, o31, o32, o33, o34, o35, o36 : out std_logic_vector(7 downto 0);
		o40, o41, o42, o43, o44, o45, o46 : out std_logic_vector(7 downto 0);
		o50, o51, o52, o53, o54, o55, o56 : out std_logic_vector(7 downto 0);
		o60, o61, o62, o63, o64, o65, o66 : out std_logic_vector(7 downto 0)
		);
end component;


component fast_top is
port(				
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
end component;

component NMS_top is
port(
		data_in : in std_logic_vector(12 downto 0); -- corner score data
		iscorner, clk, EN, rst : in std_logic;	-- contig + clock data
		x_coord_in, y_coord_in : in std_logic_vector(10 downto 0);
		x_coord_out, y_coord_out : out std_logic_vector(10 downto 0);
		corner_out : out std_logic -- corners detected after NMS
);
end component;

component brief_top
port(
			clk, rst, ce : in std_logic;
			desc_256bit : out std_logic_vector(255 downto 0);
			int00, int01, int02, int03, int04, int05, int06 : in std_logic_vector(7 downto 0); -- to FIFO
			int10, int11, int12, int13, int14, int15, int16 : in std_logic_vector(7 downto 0);
			int20, int21, int22, int23, int24, int25, int26 : in std_logic_vector(7 downto 0);
			int30, int31, int32, int33, int34, int35, int36 : in std_logic_vector(7 downto 0);
			int40, int41, int42, int43, int44, int45, int46 : in std_logic_vector(7 downto 0);
			int50, int51, int52, int53, int54, int55, int56 : in std_logic_vector(7 downto 0);
			int60, int61, int62, int63, int64, int65, int66 : in std_logic_vector(7 downto 0)
		);
end component;


--component delay_xycorner is
--generic (delay :  integer;
--	 width :  integer);
--port(
--		
--		clk, rst, ce : in std_logic;
--		xycorner_in  : in std_logic_vector (width-1 downto 0);
--		xycorner_out : out std_logic_vector(width-1 downto 0)
--	);
--end component;


component delay_corner_BRAM is
generic (delay :  integer);
port(
		
		clk, rst, ce : in std_logic;
		corner_in  : in std_logic;
		corner_out : out std_logic
	);
end component;

component delay_xy is
generic (
				depth: integer :=1920;	-- horizontal resolution
				v_res : integer :=1080 	-- vertical resolution	
				);
port(
	clk,ce,rst: in std_logic;
	x_coord,y_coord: out std_logic_vector(10 downto 0)

	);
end component;

begin

fifo_delay : input_fifo 
generic map(
				depth => 1920,	
				v_res => 1080 					
			)
port map (
					--ring
					o00 => int00,
					o01 => int01,
					o02 => int02, 
					o03 => int03,
					o04 => int04,
					o05 => int05, 
					o06 => int06,
					
					o10 => int10,
					o11 => int11,
					o12 => int12, 
					o13 => int13,
					o14 => int14,
					o15 => int15, 
					o16 => int16,
					
					o20 => int20,
					o21 => int21,
					o22 => int22, 
					o23 => int23,
					o24 => int24,
					o25 => int25, 
					o26 => int26,
					
					o30 => int30,
					o31 => int31,
					o32 => int32, 
					o33 => int33,
					o34 => int34,
					o35 => int35, 
					o36 => int36,
					
					o40 => int40,
					o41 => int41,
					o42 => int42, 
					o43 => int43,
					o44 => int44,
					o45 => int45, 
					o46 => int46,
					
					o50 => int50,
					o51 => int51,
					o52 => int52, 
					o53 => int53,
					o54 => int54,
					o55 => int55, 
					o56 => int56,
					
					o60 => int60,
					o61 => int61,
					o62 => int62, 
					o63 => int63,
					o64 => int64,
					o65 => int65, 
					o66 => int66,
		
					
					clk => clk,
					rst => rst,
					ce => ce,
					x_coord=>x_coord_int,
					y_coord=>y_coord_int,
					data_in => pixel_in
				);  

do_fast : fast_top port map(
				clk => clk,
				ce => ce,
				rst => rst,
				iscorner => iscorner_int,
				score => score_int,
				int03 => int03,
				int04 => int04,
				int15 => int15,
				int26 => int26,
				int36 => int36,
				int46 => int46,
				int55 => int55,
				int64 => int64,
				int63 => int63,
				int62 => int62,
				int51 => int51,
				int40 => int40,
				int30 => int30,
				int20 => int20,
				int11 => int11,
				int02 => int02,
				int33 => int33
				);

----Delay the signals x,y and iscorner by 24972 cycles (delay BRIEF - delay FAST)			
--do_delay_xycorner : delay_xycorner 
--generic map ( delay => 24972,
--	      width => 23)
--port map (
--		clk => clk,
--		ce => ce,
--		rst => rst,
--		xycorner_in(10 downto 0)=>x_coord_out,
--		xycorner_in(21 downto 11)=>y_coord_out,
--		xycorner_in(22)=>corner_out,
--		xycorner_out(10 downto 0)=>x_coord,
--		xycorner_out(21 downto 11)=>y_coord,
--		xycorner_out(22)=>iscorner
--		
--	    );


do_delay_corner : delay_corner_BRAM 
generic map(delay =>  24974)
port map(
        clk => clk,
		ce => ce,
		rst => rst,
		corner_in =>corner_out_reg,
		corner_out =>iscorner
	);
	
do_generate_xy : delay_xy
generic map(	depth => 1920,	
		v_res  => 1080 )
port map(
			clk => clk,			 
			rst  => rst,
			ce => ce,
			x_coord => x_coord, 
			y_coord =>  y_coord
		); 


do_nms : NMS_top port map(
			clk => clk,
			EN => ce,
			rst => rst,
			data_in => score_int,
			x_coord_in => x_coord_int,
			y_coord_in => y_coord_int,
			x_coord_out => x_coord_out,
			y_coord_out => y_coord_out,
			iscorner => iscorner_int,
			corner_out => corner_out_reg
			);


								
do_brief: brief_top
port map(
			clk => clk,			 
			rst  => rst,
			ce => ce,
			--desc_256bit=> desc_256bit_reg,
			desc_256bit=> desc_256bit,
			int00 => int00,
			int01 => int01,
			int02 => int02, 
			int03 => int03,
			int04 => int04,
			int05 => int05, 
			int06 => int06,
			
			int10 => int10,
			int11 => int11,
			int12 => int12, 
			int13 => int13,
			int14 => int14,
			int15 => int15, 
			int16 => int16,
			
			int20 => int20,
			int21 => int21,
			int22 => int22, 
			int23 => int23,
			int24 => int24,
			int25 => int25, 
			int26 => int26,
					
			int30 => int30,
			int31 => int31,
			int32 => int32, 
			int33 => int33,
			int34 => int34,
			int35 => int35, 
			int36 => int36,
					
			int40 => int40,
			int41 => int41,
			int42 => int42, 
			int43 => int43,
			int44 => int44,
			int45 => int45, 
			int46 => int46,
					
			int50 => int50,
			int51 => int51,
			int52 => int52, 
			int53 => int53,
			int54 => int54,
			int55 => int55, 
			int56 => int56,
					
			int60 => int60,
			int61 => int61,
			int62 => int62, 
			int63 => int63,
			int64 => int64,
			int65 => int65, 
			int66 => int66
		);

--temp <= std_logic_vector(unsigned(desc_256bit_reg(255 downto 128))+unsigned(desc_256bit_reg(127 downto 0)));
--desc_256bit <= temp(127 downto 126);   

end Behavioral;

