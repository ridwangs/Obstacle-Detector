----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2019 10:51:06 AM
-- Design Name: 
-- Module Name: AppTBench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AppTBench is
--  Port ( );
end AppTBench;

architecture Behavioral of AppTBench is

component MainApp is
    Port (clk           : in STD_LOGIC;
          echoPulse     : in STD_LOGIC;
          pulseTrigger  : out STD_LOGIC;
          distRange     : out STD_LOGIC_VECTOR(3 downto 0)
          );
end component;


signal clk          : STD_LOGIC := '0';
signal echoPulsed    : STD_LOGIC := '0';
signal pulseTrigger : STD_LOGIC;
signal distRange    : STD_LOGIC_VECTOR(3 downto 0);

begin
    uut: MainApp port map(
        clk => clk,
        echoPulse =>   echoPulsed,
        pulseTrigger => pulseTrigger,
        distRange => distRange
    );

clk_proc : process
begin
    wait for 4 ns;
    clk <= not clk;
end process clk_proc;

sim_proc: process
begin
   wait for 10 us;
   echoPulsed <= '1';
   echoPulsed <= '0' after 2 us;
end process sim_proc;

end Behavioral;
