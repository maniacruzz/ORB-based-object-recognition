----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:57:51 01/19/2012 
-- Design Name: 
-- Module Name:    input_fifo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
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


entity smooth_input_fifo is
generic (
				depth: integer :=1920;	-- bytes in FIFO (horizontal resolution)
				v_res : integer :=1080; 	-- vertical resolution				
				window_width : integer := 33
			);  
port(
		data_in : in std_logic_vector(7 downto 0);
		clk, rst, ce : in std_logic;								-- ce - global clock enable 
		smooth_patch : out vector_8bit(window_width*window_width-1 downto 0)
		
		--window_row_0, window_row_2, window_row_3, window_row_4, window_row_5, window_row_6, window_row_7, window_row_8, window_row_9 : out array (window_width-1 downto 0) of std_logic_vector(7 downto 0);
		--window_row_10, window_row_12, window_row_13, window_row_14, window_row_15, window_row_16, window_row_17, window_row_18, window_row_19 : out array (window_width-1 downto 0) of std_logic_vector(7 downto 0);
		--window_row_20, window_row_22, window_row_23, window_row_24, window_row_25, window_row_26, window_row_27, window_row_28, window_row_29 : out array (window_width-1 downto 0) of std_logic_vector(7 downto 0);
		--window_row_30, window_row_32 : out array (window_width-1 downto 0) of std_logic_vector(7 downto 0)

		);
end smooth_input_fifo;

architecture Behavioral of smooth_input_fifo is

type ram is array (depth-1 downto 0) of std_logic_vector(7 downto 0); 
--type window_row is array (window_width-1 downto 0) of std_logic_vector(7 downto 0); 
signal address_read, address_write : unsigned(10 downto 0);
signal data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7, data_out_8, data_out_9 : std_logic_vector(7 downto 0);
signal data_out_10, data_out_11, data_out_12, data_out_13, data_out_14, data_out_15, data_out_16, data_out_17, data_out_18, data_out_19 : std_logic_vector(7 downto 0);
signal data_out_20, data_out_21, data_out_22, data_out_23, data_out_24, data_out_25, data_out_26, data_out_27, data_out_28, data_out_29 : std_logic_vector(7 downto 0);
signal data_out_30, data_out_31 : std_logic_vector(7 downto 0);

signal ram_0, ram_1, ram_2, ram_3, ram_4, ram_5, ram_6, ram_7, ram_8, ram_9  : ram;
signal ram_10, ram_11, ram_12, ram_13, ram_14, ram_15, ram_16, ram_17, ram_18, ram_19  : ram;
signal ram_20, ram_21, ram_22, ram_23, ram_24, ram_25, ram_26, ram_27, ram_28, ram_29  : ram;
signal ram_30, ram_31 : ram;

signal window_row_0, window_row_1, window_row_2, window_row_3, window_row_4, window_row_5, window_row_6, window_row_7, window_row_8, window_row_9 : vector_8bit(window_width-1 downto 0);
signal window_row_10, window_row_11, window_row_12, window_row_13, window_row_14, window_row_15, window_row_16, window_row_17, window_row_18, window_row_19 : vector_8bit(window_width-1 downto 0);
signal window_row_20, window_row_21, window_row_22, window_row_23, window_row_24, window_row_25, window_row_26, window_row_27, window_row_28, window_row_29 : vector_8bit(window_width-1 downto 0);
signal window_row_30, window_row_31, window_row_32 : vector_8bit(window_width-1 downto 0);



attribute ram_style: string; 
attribute ram_style of ram_0, ram_1, ram_2, ram_3, ram_4, ram_5, ram_6, ram_7, ram_8, ram_9 : signal is "block"; 
attribute ram_style of ram_10, ram_11, ram_12, ram_13, ram_14, ram_15, ram_16, ram_17, ram_18, ram_19 : signal is "block"; 
attribute ram_style of ram_20, ram_21, ram_22, ram_23, ram_24, ram_25, ram_26, ram_27, ram_28, ram_29 : signal is "block"; 
attribute ram_style of ram_30, ram_31 : signal is "block"; 




begin

ram_handler : process(clk, rst)
begin
	if clk='1' and clk'event then
		if rst='1' then
			--o_00<=(others=>'0');	o_01<=(others=>'0');	o_02<=(others=>'0');	o_03<=(others=>'0');	o_04<=(others=>'0');	o_05<=(others=>'0');	o_06<=(others=>'0');
			--o_10<=(others=>'0');	o_11<=(others=>'0');	o_12<=(others=>'0');	o_13<=(others=>'0');	o_14<=(others=>'0');	o_15<=(others=>'0');	o_16<=(others=>'0');
			--o_20<=(others=>'0');	o_21<=(others=>'0');	o_22<=(others=>'0');	o_23<=(others=>'0');	o_24<=(others=>'0');	o_25<=(others=>'0');	o_26<=(others=>'0');
			--o_30<=(others=>'0');	o_31<=(others=>'0');	o_32<=(others=>'0');	o_33<=(others=>'0');	o_34<=(others=>'0');	o_35<=(others=>'0');	o_36<=(others=>'0');
			--o_40<=(others=>'0');	o_41<=(others=>'0');	o_42<=(others=>'0');	o_43<=(others=>'0');	o_44<=(others=>'0');	o_45<=(others=>'0');	o_46<=(others=>'0');
			--o_50<=(others=>'0');	o_51<=(others=>'0');	o_52<=(others=>'0');	o_53<=(others=>'0');	o_54<=(others=>'0');	o_55<=(others=>'0');	o_56<=(others=>'0');
			--o_60<=(others=>'0');	o_61<=(others=>'0');	o_62<=(others=>'0');	o_63<=(others=>'0');	o_64<=(others=>'0');	o_65<=(others=>'0');	o_66<=(others=>'0');
		window_row_0<=(others =>(others=>'0')); window_row_1<=(others =>(others=>'0')); window_row_2<=(others =>(others=>'0')); window_row_3<=(others =>(others=>'0')); window_row_4<=(others =>(others=>'0')); 
		window_row_5 <=(others =>(others=>'0')); window_row_6<=(others =>(others=>'0')); window_row_7<=(others =>(others=>'0')); window_row_8<=(others =>(others=>'0')); window_row_9 <=(others =>(others=>'0')); 
		window_row_10<=(others =>(others=>'0')); window_row_11<=(others =>(others=>'0')); window_row_12<=(others =>(others=>'0')); window_row_13<=(others =>(others=>'0')); window_row_14<=(others =>(others=>'0')); window_row_15 <=(others =>(others=>'0')); window_row_16<=(others =>(others=>'0')); window_row_17<=(others =>(others=>'0')); window_row_18<=(others =>(others=>'0')); window_row_19<=(others =>(others=>'0')); window_row_20<=(others =>(others=>'0')); window_row_21 <=(others =>(others=>'0')); window_row_22<=(others =>(others=>'0')); window_row_23<=(others =>(others=>'0'));window_row_24<=(others =>(others=>'0'));
		window_row_25<=(others =>(others=>'0')); window_row_26<=(others =>(others=>'0')); window_row_27 <=(others =>(others=>'0')); window_row_28<=(others =>(others=>'0')); window_row_29<=(others =>(others=>'0'));
		window_row_30<=(others =>(others=>'0')); window_row_31<=(others =>(others=>'0')); window_row_32<=(others =>(others=>'0')); 
			
			data_out_0<=(others=>'0'); data_out_1<=(others=>'0'); data_out_2<=(others=>'0'); data_out_3<=(others=>'0'); data_out_4<=(others=>'0'); data_out_5<=(others=>'0');
			data_out_6<=(others=>'0'); data_out_7<=(others=>'0'); data_out_8<=(others=>'0'); data_out_9<=(others=>'0'); data_out_10<=(others=>'0'); data_out_11<=(others=>'0');
			data_out_12<=(others=>'0'); data_out_13<=(others=>'0'); data_out_14<=(others=>'0'); data_out_15<=(others=>'0'); data_out_16<=(others=>'0'); data_out_17<=(others=>'0');
			data_out_18<=(others=>'0'); data_out_19<=(others=>'0'); data_out_20<=(others=>'0'); data_out_21<=(others=>'0'); data_out_22<=(others=>'0'); data_out_23<=(others=>'0');
			data_out_24<=(others=>'0'); data_out_25<=(others=>'0'); data_out_26<=(others=>'0'); data_out_27<=(others=>'0'); data_out_28<=(others=>'0'); data_out_29<=(others=>'0');
			data_out_30<=(others=>'0'); data_out_31<=(others=>'0'); 
			
		elsif ce='1' then
			ram_0(to_integer(unsigned(address_write)))<=data_in; 		-- data input to delay buffer 0
			ram_1(to_integer(unsigned(address_write)))<=data_out_0; 	-- data input to delay buffer 1
			ram_2(to_integer(unsigned(address_write)))<=data_out_1; 	-- data input to delay buffer 2
			ram_3(to_integer(unsigned(address_write)))<=data_out_2; 	-- data input to delay buffer 3
			ram_4(to_integer(unsigned(address_write)))<=data_out_3; 	-- data input to delay buffer 4
			ram_5(to_integer(unsigned(address_write)))<=data_out_4; 	-- data input to delay buffer 5
			ram_6(to_integer(unsigned(address_write)))<=data_out_5; 
			ram_7(to_integer(unsigned(address_write)))<=data_out_6; 			
			ram_8(to_integer(unsigned(address_write)))<=data_out_7;
			ram_9(to_integer(unsigned(address_write)))<=data_out_8;
			ram_10(to_integer(unsigned(address_write)))<=data_out_9;
			ram_11(to_integer(unsigned(address_write)))<=data_out_10;
			ram_12(to_integer(unsigned(address_write)))<=data_out_11;
			ram_13(to_integer(unsigned(address_write)))<=data_out_12;
			ram_14(to_integer(unsigned(address_write)))<=data_out_13;
			ram_15(to_integer(unsigned(address_write)))<=data_out_14;
			ram_16(to_integer(unsigned(address_write)))<=data_out_15;
			ram_17(to_integer(unsigned(address_write)))<=data_out_16;
			ram_18(to_integer(unsigned(address_write)))<=data_out_17;
			ram_19(to_integer(unsigned(address_write)))<=data_out_18;
			ram_20(to_integer(unsigned(address_write)))<=data_out_19;
			ram_21(to_integer(unsigned(address_write)))<=data_out_20;
			ram_22(to_integer(unsigned(address_write)))<=data_out_21;
			ram_23(to_integer(unsigned(address_write)))<=data_out_22;
			ram_24(to_integer(unsigned(address_write)))<=data_out_23;
			ram_25(to_integer(unsigned(address_write)))<=data_out_24;
			ram_26(to_integer(unsigned(address_write)))<=data_out_25;
			ram_27(to_integer(unsigned(address_write)))<=data_out_26;
			ram_28(to_integer(unsigned(address_write)))<=data_out_27;
			ram_29(to_integer(unsigned(address_write)))<=data_out_28;
			ram_30(to_integer(unsigned(address_write)))<=data_out_29;
			ram_31(to_integer(unsigned(address_write)))<=data_out_30;
			
			
			data_out_0<=ram_0(to_integer(unsigned(address_read)));	-- read FIFO 0
			data_out_1<=ram_1(to_integer(unsigned(address_read)));	-- read FIFO 1
			data_out_2<=ram_2(to_integer(unsigned(address_read)));	-- read FIFO 2
			data_out_3<=ram_3(to_integer(unsigned(address_read)));	-- read FIFO 3
			data_out_4<=ram_4(to_integer(unsigned(address_read)));	-- read FIFO 4
			data_out_5<=ram_5(to_integer(unsigned(address_read)));	-- read FIFO 5
			data_out_6<=ram_6(to_integer(unsigned(address_read)));	-- read FIFO 6
			data_out_7<=ram_7(to_integer(unsigned(address_read)));	-- read FIFO 7
			data_out_8<=ram_8(to_integer(unsigned(address_read)));	-- read FIFO 8
			data_out_9<=ram_9(to_integer(unsigned(address_read)));	-- read FIFO 9
			data_out_10<=ram_10(to_integer(unsigned(address_read)));	-- read FIFO 10
			data_out_11<=ram_11(to_integer(unsigned(address_read)));	-- read FIFO 11
			data_out_12<=ram_12(to_integer(unsigned(address_read)));	-- read FIFO 12
			data_out_13<=ram_13(to_integer(unsigned(address_read)));	-- read FIFO 13
			data_out_14<=ram_14(to_integer(unsigned(address_read)));	-- read FIFO 14
			data_out_15<=ram_15(to_integer(unsigned(address_read)));	-- read FIFO 15
			data_out_16<=ram_16(to_integer(unsigned(address_read)));	-- read FIFO 16
			data_out_17<=ram_17(to_integer(unsigned(address_read)));	-- read FIFO 17
			data_out_18<=ram_18(to_integer(unsigned(address_read)));	-- read FIFO 18
			data_out_19<=ram_19(to_integer(unsigned(address_read)));	-- read FIFO 19
			data_out_20<=ram_20(to_integer(unsigned(address_read)));	-- read FIFO 20
			data_out_21<=ram_21(to_integer(unsigned(address_read)));	-- read FIFO 21
			data_out_22<=ram_22(to_integer(unsigned(address_read)));	-- read FIFO 22
			data_out_23<=ram_23(to_integer(unsigned(address_read)));	-- read FIFO 23
			data_out_24<=ram_24(to_integer(unsigned(address_read)));	-- read FIFO 24
			data_out_25<=ram_25(to_integer(unsigned(address_read)));	-- read FIFO 25
			data_out_26<=ram_26(to_integer(unsigned(address_read)));	-- read FIFO 26
			data_out_27<=ram_27(to_integer(unsigned(address_read)));	-- read FIFO 27
			data_out_28<=ram_28(to_integer(unsigned(address_read)));	-- read FIFO 28
			data_out_29<=ram_29(to_integer(unsigned(address_read)));	-- read FIFO 29
			data_out_30<=ram_30(to_integer(unsigned(address_read)));	-- read FIFO 30
			data_out_31<=ram_31(to_integer(unsigned(address_read)));	-- read FIFO 31
			
			
			--row 33 in the window - latest to come in data is read from data_in
			for i in 0 to 31 loop  				
			    window_row_32(i) <= window_row_32(i+1); 
			end loop; 
			window_row_32(32) <= data_in; 
			
			--row 32 in the window - delayed by 1 FIFO so taken from RAM 0
			for i in 0 to 31 loop  				
			    window_row_31(i) <= window_row_31(i+1); 
			end loop; 
			window_row_31(32) <= data_out_0; 
			
			--row 31 in the window - delayed by 2 FIFO so taken from RAM 1
			for i in 0 to 31 loop  				
			    window_row_30(i) <= window_row_30(i+1); 
			end loop; 
			window_row_30(32) <= data_out_1; 
			
			--row 30 in the window - delayed by 3 FIFO so taken from RAM 2
			for i in 0 to 31 loop  				
			    window_row_29(i) <= window_row_29(i+1); 
			end loop; 
			window_row_29(32) <= data_out_2; 
			
			--row 29 in the window - delayed by 4 FIFO so taken from RAM 3
			for i in 0 to 31 loop  				
			    window_row_28(i) <= window_row_28(i+1); 
			end loop; 
			window_row_28(32) <= data_out_3; 
			
			--row 28 in the window - delayed by 5 FIFO so taken from RAM 4
			for i in 0 to 31 loop  				
			    window_row_27(i) <= window_row_27(i+1); 
			end loop; 
			window_row_27(32) <= data_out_4;
			
			--row 27 in the window - delayed by 6 FIFO so taken from RAM 5
			for i in 0 to 31 loop  				
			    window_row_26(i) <= window_row_26(i+1); 
			end loop; 
			window_row_26(32) <= data_out_5;
			
			--row 26 in the window - delayed by 7 FIFO so taken from RAM 6
			for i in 0 to 31 loop  				
			    window_row_25(i) <= window_row_25(i+1); 
			end loop; 
			window_row_25(32) <= data_out_6;
			
			--row 25 in the window - delayed by 8 FIFO so taken from RAM 7
			for i in 0 to 31 loop  				
			    window_row_24(i) <= window_row_24(i+1); 
			end loop; 
			window_row_24(32) <= data_out_7;
			
			--row 24 in the window - delayed by 9 FIFO so taken from RAM 8
			for i in 0 to 31 loop  				
			    window_row_23(i) <= window_row_23(i+1); 
			end loop; 
			window_row_23(32) <= data_out_8;
			
			--row 23 in the window - delayed by 10 FIFO so taken from RAM 9
			for i in 0 to 31 loop  				
			    window_row_22(i) <= window_row_22(i+1); 
			end loop; 
			window_row_22(32) <= data_out_9;
			
			--row 22 in the window - delayed by 11 FIFO so taken from RAM 10
			for i in 0 to 31 loop  				
			    window_row_21(i) <= window_row_21(i+1); 
			end loop; 
			window_row_21(32) <= data_out_10;
			
			--row 21 in the window - delayed by 12 FIFO so taken from RAM 11
			for i in 0 to 31 loop  				
			    window_row_20(i) <= window_row_20(i+1); 
			end loop; 
			window_row_20(32) <= data_out_11;
			
			--row 20 in the window - delayed by 13 FIFO so taken from RAM 12
			for i in 0 to 31 loop  				
			    window_row_19(i) <= window_row_19(i+1); 
			end loop; 
			window_row_19(32) <= data_out_12;
			
			--row 19 in the window - delayed by 14 FIFO so taken from RAM 13
			for i in 0 to 31 loop  				
			    window_row_18(i) <= window_row_18(i+1); 
			end loop; 
			window_row_18(32) <= data_out_13;
			
			--row 18 in the window - delayed by 15 FIFO so taken from RAM 14
			for i in 0 to 31 loop  				
			    window_row_17(i) <= window_row_17(i+1); 
			end loop; 
			window_row_17(32) <= data_out_14;
			
			--row 17 in the window - delayed by 16 FIFO so taken from RAM 15
			for i in 0 to 31 loop  				
			    window_row_16(i) <= window_row_16(i+1); 
			end loop; 
			window_row_16(32) <= data_out_15;
			
			--row 16 in the window - delayed by 17 FIFO so taken from RAM 16
			for i in 0 to 31 loop  				
			    window_row_15(i) <= window_row_15(i+1); 
			end loop; 
			window_row_15(32) <= data_out_16;
			
			--row 15 in the window - delayed by 18 FIFO so taken from RAM 17
			for i in 0 to 31 loop  				
			    window_row_14(i) <= window_row_14(i+1); 
			end loop; 
			window_row_14(32) <= data_out_17;
			
			--row 14 in the window - delayed by 19 FIFO so taken from RAM 18
			for i in 0 to 31 loop  				
			    window_row_13(i) <= window_row_13(i+1); 
			end loop; 
			window_row_13(32) <= data_out_18;
			
			--row 13 in the window - delayed by 20 FIFO so taken from RAM 19
			for i in 0 to 31 loop  				
			    window_row_12(i) <= window_row_12(i+1); 
			end loop; 
			window_row_12(32) <= data_out_19;
			
			--row 12 in the window - delayed by 21 FIFO so taken from RAM 20
			for i in 0 to 31 loop  				
			    window_row_11(i) <= window_row_11(i+1); 
			end loop; 
			window_row_11(32) <= data_out_20;
			
			--row 11 in the window - delayed by 22 FIFO so taken from RAM 21
			for i in 0 to 31 loop  				
			    window_row_10(i) <= window_row_10(i+1); 
			end loop; 
			window_row_10(32) <= data_out_21;
			
			--row 10 in the window - delayed by 23 FIFO so taken from RAM 22
			for i in 0 to 31 loop  				
			    window_row_9(i) <= window_row_9(i+1); 
			end loop; 
			window_row_9(32) <= data_out_22;
			
			--row 9 in the window - delayed by 24 FIFO so taken from RAM 23
			for i in 0 to 31 loop  				
			    window_row_8(i) <= window_row_8(i+1); 
			end loop; 
			window_row_8(32) <= data_out_23;
			
			--row 8 in the window - delayed by 25 FIFO so taken from RAM 24
			for i in 0 to 31 loop  				
			    window_row_7(i) <= window_row_7(i+1); 
			end loop; 
			window_row_7(32) <= data_out_24;
			
			--row 7 in the window - delayed by 26 FIFO so taken from RAM 25
			for i in 0 to 31 loop  				
			    window_row_6(i) <= window_row_6(i+1); 
			end loop; 
			window_row_6(32) <= data_out_25;
			
			--row 6 in the window - delayed by 27 FIFO so taken from RAM 26
			for i in 0 to 31 loop  				
			    window_row_5(i) <= window_row_5(i+1); 
			end loop; 
			window_row_5(32) <= data_out_26;
			
			--row 5 in the window - delayed by 28 FIFO so taken from RAM 27
			for i in 0 to 31 loop  				
			    window_row_4(i) <= window_row_4(i+1); 
			end loop; 
			window_row_4(32) <= data_out_27;
			
			--row 4 in the window - delayed by 29 FIFO so taken from RAM 28
			for i in 0 to 31 loop  				
			    window_row_3(i) <= window_row_3(i+1); 
			end loop; 
			window_row_3(32) <= data_out_28;
			
			--row 3 in the window - delayed by 30 FIFO so taken from RAM 29
			for i in 0 to 31 loop  				
			    window_row_2(i) <= window_row_2(i+1); 
			end loop; 
			window_row_2(32) <= data_out_29;
			
			--row 2 in the window - delayed by 31 FIFO so taken from RAM 30
			for i in 0 to 31 loop  				
			    window_row_1(i) <= window_row_1(i+1); 
			end loop; 
			window_row_1(32) <= data_out_30;
			
			--row 1 in the window - delayed by 32 FIFO so taken from RAM 31
			for i in 0 to 31 loop  				
			    window_row_0(i) <= window_row_0(i+1); 
			end loop; 
			window_row_0(32) <= data_out_31;
			

			
		end if;														
	end if;
end process ram_handler;

address_generator : process(clk)
begin
	if clk='1' and clk'event then
		if rst='1' then
			address_read<=(others=>'0');
			address_write<=to_unsigned(1, 11);
		else		
			if ce='1' then
				if address_read=to_unsigned(depth-1, 11) then	-- whenever max. horizontal resolution reached
					address_read<=(others=>'0');
				else
					address_read<=address_read+1;
				end if;
				address_write<=address_read;	
			end if;
		end if;
	end if;
end process address_generator;



--map array to output port
--smooth_patch<=window_row_0&window_row_1&window_row_2&window_row_3&window_row_4&window_row_5&window_row_6&window_row_7&window_row_8&window_row_9&window_row_10&window_row_11&window_row_12&window_row_13&window_row_14&window_row_15&window_row_16&window_row_17&window_row_18&window_row_19&window_row_20&window_row_21&window_row_22&window_row_23&window_row_24&window_row_25&window_row_26&window_row_27&window_row_28&window_row_29&window_row_30&window_row_31&window_row_32;

smooth_patch<=window_row_32&window_row_31&window_row_30&window_row_29&window_row_28&window_row_27&window_row_26&window_row_25&window_row_24&window_row_23&window_row_22&window_row_21&window_row_20&window_row_19&window_row_18&window_row_17&window_row_16&window_row_15&window_row_14&window_row_13&window_row_12&window_row_11&window_row_10&window_row_9&window_row_8&window_row_7&window_row_6&window_row_5&window_row_4&window_row_3&window_row_2&window_row_1&window_row_0;
end Behavioral;

