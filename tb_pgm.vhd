library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.libv.all;
use work.pgm.all;
entity tb_pgm is
end entity tb_pgm;

architecture test of tb_pgm is
  signal clk : std_logic:= '0';
  signal rst:  std_logic;
  signal frame_sync_in: std_logic;
	signal line_sync_in:   std_logic;
	signal frame_sync_out:  std_logic;
	signal	line_sync_out:  std_logic;
	signal	data_in:  std_logic_vector(7 downto 0);
  signal pixel_out:  std_logic_vector(7 downto 0);
  signal x_count : std_logic_vector(10 downto 0) := (others => '0');
	signal y_count : std_logic_vector(10 downto 0) := (others => '0');
  signal iscorner, ce : std_logic;
	signal	x_coord : std_logic_vector(10 downto 0);
	signal y_coord :  std_logic_vector(10 downto 0);
	signal count_tb : std_logic_vector(21 downto 0) := (others => '0');
	
component FAST_with_NMS
port(
			pixel_clk: std_logic; 
			rst: std_logic; 
			ce : std_logic;
			pixel_in : in std_logic_vector(7 downto 0);
			iscorner : out std_logic;
			x_coord, y_coord : out std_logic_vector(10 downto 0)
		);
end component;

begin  -- architecture test
process begin 
 
  rst <= '1';
  wait for 200 ns; 
  rst <= '0';
   
  wait;
end process;
     
uut: FAST_with_NMS
port map(
			pixel_clk => clk,			 
			rst  => rst,
			ce => ce,
			pixel_in => data_in,
			iscorner  => isCorner,
			x_coord => x_coord, 
			y_coord =>  y_coord
		);
      
      
clk <= not clk after 10 ns; 
test1 : process is
        variable i : pixel_array_ptr;
		  variable width : integer;
		  variable height : integer;
		  variable pixel_test : integer;
        -- Without the transpose function, we would have to present the initialisation data in a non-intuitive way.
        constant testdata : pixel_array(0 to 7, 0 to 3) := transpose(pixel_array'(
            (000, 027, 062, 095, 130, 163, 198, 232),
            (000, 000, 000, 000, 000, 000, 000, 000),
            (255, 255, 255, 255, 255, 255, 255, 255),
            (100, 100, 100, 100, 100, 255, 255, 255))
        );
        
    begin  -- process test1
          -- test on a proper image
          
          for wait1 in 0 to 1 loop
             frame_sync_in <= '0';
             line_sync_in <= '0';
			       wait until rising_edge(clk);
	        end loop;
        i := pgm_read("nature.pgm");
     
      width := i.all'length(1);
		  height:= i.all'length(2);
		   for frame_V_porch in 0 to 10 loop
			  wait until rising_edge(clk);
		    end loop;
		for frame in 0 to 1 loop    
		      for m in 0 to height-1 loop
			    for l in 0 to width-1 loop
			      frame_sync_in <= '1'; 
			      line_sync_in <= '1';
			      ce <= '1';
			      pixel_test :=i(l,m);
			      data_in <= std_logic_vector(to_unsigned(pixel_test,8));
			      count_tb<=count_tb+1;
			      wait until rising_edge(clk);
			    end loop;
		      line_sync_in <= '0';
		      ce <= '0';
			    for line_sync in 1 to 10 loop
			      wait until rising_edge(clk);
			    end loop;
		      end loop;
		      frame_sync_in <= '0';
		      for frame_sync in 1 to 2000 loop
			  wait until rising_edge(clk);
		      end loop;
		frame_sync_in <= '0';
		end loop;
   
        report "End of tests" severity note;
        wait;
    end process test1;

test2:  process is 
  variable width : integer  :=1920;
	variable height : integer :=1080;
	variable flag : integer :=0;
	variable output_img : pixel_array(0 to width-1, 0 to height-1) := (others => (others => 0));

begin 
  wait until rising_edge(clk);
  
   if( isCorner ='1' and  x_coord >=3 and y_coord >=3 and x_coord <= width -5 and y_coord <= height -5) then 
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))+3) :=  255;
        output_img(to_integer(unsigned(x_coord))-2, to_integer(unsigned(y_coord))+3) :=  255;
        output_img(to_integer(unsigned(x_coord))-1, to_integer(unsigned(y_coord))+3) :=  255;
        output_img(to_integer(unsigned(x_coord)), to_integer(unsigned(y_coord))+3) :=  255;
        output_img(to_integer(unsigned(x_coord))+1, to_integer(unsigned(y_coord))+3) :=  255;
        output_img(to_integer(unsigned(x_coord))+2, to_integer(unsigned(y_coord))+3) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))+3) :=  255;
       
        
       output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord))-2, to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord))-1, to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord)), to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord))+1, to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord))+2, to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))-3) :=  255;
     
        
            
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))-2) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))-1) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))+1) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))+2) :=  255;
        output_img(to_integer(unsigned(x_coord))+3, to_integer(unsigned(y_coord))+3) :=  255;    
        
                
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))-3) :=  255;
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))-2) :=  255;
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))-1) :=  255;
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))) :=  255;
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))+1) :=  255;
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))+2) :=  255;
        output_img(to_integer(unsigned(x_coord))-3, to_integer(unsigned(y_coord))+3) :=  255;

    end if;
  
   if (line_sync_out =  '1') then
      if(x_count = width-1) then
        x_count <= (others => '0');
        y_count <= y_count +1;
      else
        flag := 0;
        x_count <= x_count +1;
      end if;
    end if;
   if(frame_sync_out = '1') then
    if (y_count = height) then
       y_count <= (others => '0');
       flag := 1;
    end if;
   end if; 

-- if(frame_sync_out = '1' and line_sync_out =  '1') then
--  if(frame_sync_out = '1' and line_sync_out =  '1') then
--  output_img(to_integer(unsigned(x_count)), to_integer(unsigned(y_count))) :=  to_integer(unsigned(pixel_out)); 
-- end if;
-- end if;
 if(x_coord= 1903 and y_coord =1074) then
   report "Write initiated" severity note;
   pgm_write("nature_corners1.pgm", output_img);
   report "Write completed" severity note;
   
   assert false report "Simulation Finished" severity failure;
   wait;
end if;  
  
end process test2;

end test;
