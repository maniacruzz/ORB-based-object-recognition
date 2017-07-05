
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity averaging_filter_7x7 is
port(
		in00, in01, 		  in02, in03, in04, 		    in05, in06 : in std_logic_vector(7 downto 0); 
		in10,               in11, in12, in13, in14, in15, 	      in16 : in std_logic_vector(7 downto 0); 
			      in20, in21, in22, in23, in24, in25, in26 		   : in std_logic_vector(7 downto 0); 
			      in30, in31, in32, in33, in34, in35, in36 		   : in std_logic_vector(7 downto 0);
			      in40, in41, in42, in43, in44, in45, in46 		   : in std_logic_vector(7 downto 0);
		in50, 		    in51, in52, in53, in54, in55, 	          in56 : in std_logic_vector(7 downto 0);
		in60, in61, 	          in62, in63, in64, 		in65, in66 : in std_logic_vector(7 downto 0);
		clk, rst, ce : in std_logic;
		
		--result : out std_logic_vector(9 downto 0);
		smooth_out : out std_logic_vector(7 downto 0)
	);
end averaging_filter_7x7;

architecture Behavioral of averaging_filter_7x7 is

signal s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18 : unsigned(8 downto 0);
signal ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9 : unsigned(9 downto 0);
signal sss0, sss1, sss2, sss3, sss4 : unsigned(10 downto 0);
signal ssss0, ssss1, ssss2 : unsigned(11 downto 0);
signal sssss0, sssss1 : unsigned(12 downto 0);
signal sum_all : unsigned(13 downto 0);
signal mult_7 : unsigned(16 downto 0);

constant val : unsigned(2 downto 0) := to_unsigned(7,3);

begin

avg : process(clk)
begin
	if clk='1' and clk'event then
		if rst='1' then
			s0<=(others=>'0');		s1<=(others=>'0');		s2<=(others=>'0');		s3<=(others=>'0');	
			s4<=(others=>'0');		s5<=(others=>'0');		s6<=(others=>'0');		s7<=(others=>'0');
			s8<=(others=>'0');		s9<=(others=>'0');		s10<=(others=>'0');		s11<=(others=>'0');
			s12<=(others=>'0');		s13<=(others=>'0');		s14<=(others=>'0');		s15<=(others=>'0');
			s16<=(others=>'0');		s17<=(others=>'0');		s18<=(others=>'0');		
			
			ss0<=(others=>'0');		ss1<=(others=>'0');		ss2<=(others=>'0');		ss3<=(others=>'0');	
			ss4<=(others=>'0');		ss5<=(others=>'0');		ss6<=(others=>'0');		ss7<=(others=>'0');
			ss8<=(others=>'0');		ss9<=(others=>'0');		
			
			sss0<=(others=>'0');		sss1<=(others=>'0');		sss2<=(others=>'0');		sss3<=(others=>'0');
			sss4<=(others=>'0');			
			
			ssss0<=(others=>'0');		ssss1<=(others=>'0');		ssss2<=(others=>'0');		
			
			sssss0<=(others=>'0');		sssss1<=(others=>'0');	
		
			sum_all<=(others=>'0');
		elsif ce='1' then
			s0<=resize(unsigned(in02), s0'length)+resize(unsigned(in03), s0'length);
			s1<=resize(unsigned(in04), s1'length)+resize(unsigned(in11), s1'length);
			s2<=resize(unsigned(in12), s2'length)+resize(unsigned(in13), s2'length);
			s3<=resize(unsigned(in14), s3'length)+resize(unsigned(in15), s3'length);			
			s4<=resize(unsigned(in20), s4'length)+resize(unsigned(in21), s4'length);
			s5<=resize(unsigned(in22), s5'length)+resize(unsigned(in23), s5'length);
			s6<=resize(unsigned(in24), s6'length)+resize(unsigned(in25), s6'length);
			s7<=resize(unsigned(in26), s7'length)+resize(unsigned(in30), s7'length);			
  			s8<=resize(unsigned(in31), s8'length)+resize(unsigned(in32), s8'length);
			s9<=resize(unsigned(in33), s9'length)+resize(unsigned(in34), s9'length);
			s10<=resize(unsigned(in35), s10'length)+resize(unsigned(in36), s10'length);
			s11<=resize(unsigned(in40), s11'length)+resize(unsigned(in41), s11'length);			
			s12<=resize(unsigned(in42), s12'length)+resize(unsigned(in43), s12'length);
			s13<=resize(unsigned(in44), s13'length)+resize(unsigned(in45), s13'length);
			s14<=resize(unsigned(in46), s14'length)+resize(unsigned(in51), s14'length);
			s15<=resize(unsigned(in52), s15'length)+resize(unsigned(in53), s15'length);
			s16<=resize(unsigned(in54), s16'length)+resize(unsigned(in55), s16'length);
			s17<=resize(unsigned(in62), s17'length)+resize(unsigned(in63), s17'length);
			s18<=resize(unsigned(in64), s18'length);

			ss0<=resize(unsigned(s0), ss0'length)+resize(unsigned(s1), ss0'length);
			ss1<=resize(unsigned(s2), ss1'length)+resize(unsigned(s3), ss1'length);
			ss2<=resize(unsigned(s4), ss2'length)+resize(unsigned(s5), ss2'length);
			ss3<=resize(unsigned(s6), ss3'length)+resize(unsigned(s7), ss3'length);			
			ss4<=resize(unsigned(s8), ss4'length)+resize(unsigned(s9), ss4'length);
			ss5<=resize(unsigned(s10), ss5'length)+resize(unsigned(s11), ss5'length);
			ss6<=resize(unsigned(s12), ss6'length)+resize(unsigned(s13), ss6'length);
			ss7<=resize(unsigned(s14), ss7'length)+resize(unsigned(s15), ss7'length);			
  			ss8<=resize(unsigned(s16), ss8'length)+resize(unsigned(s17), ss8'length);
			ss9<=resize(unsigned(s18), ss9'length);

			sss0<=resize(unsigned(ss0), sss0'length)+resize(unsigned(ss1), sss0'length);
			sss1<=resize(unsigned(ss2), sss1'length)+resize(unsigned(ss3), sss1'length);
			sss2<=resize(unsigned(ss4), sss2'length)+resize(unsigned(ss5), sss2'length);
			sss3<=resize(unsigned(ss6), sss3'length)+resize(unsigned(ss7), sss3'length);			
			sss4<=resize(unsigned(ss8), sss4'length)+resize(unsigned(ss9), sss4'length);
			
			ssss0<=resize(unsigned(sss0), ssss0'length)+resize(unsigned(sss1), ssss0'length);
			ssss1<=resize(unsigned(sss2), ssss1'length)+resize(unsigned(sss3), ssss1'length);
			ssss2<=resize(unsigned(sss4), ssss2'length);
			
			sssss0<=resize(unsigned(ssss0), sssss0'length)+resize(unsigned(ssss1), sssss0'length);
			sssss1<=resize(unsigned(ssss2), sssss1'length);
			
			sum_all<=resize(unsigned(sssss0), sum_all'length)+resize(unsigned(sssss1), sum_all'length);
			
			-- sum_all/37=average
			mult_7<=sum_all*val;
			smooth_out<=std_logic_vector(mult_7(15 downto 8));
			
			
		end if;
	end if;
end process avg;

end Behavioral;

