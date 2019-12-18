----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ridwan Sadiq
-- 
-- Create Date: 12/02/2019 09:43:22 PM
-- Design Name: 
-- Module Name: Main - Behavioral
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Main is
    Port ( sys_clk      : in STD_LOGIC;
--           switch       : in STD_LOGIC;
           echoPulse    : in STD_LOGIC;
           pulseTrigger : out STD_LOGIC; 
           distRange    : out STD_LOGIC_VECTOR (3 downto 0);
           --End of Signals for Ultrasonic sensor
           reset_btn    : in STD_LOGIC;
           TMDS         : out STD_LOGIC_VECTOR (3 downto 0);
           TMDSB        : out STD_LOGIC_VECTOR (3 downto 0);
            --End of Signals for HDMI
           mclk         : out STD_LOGIC;
           bclk         : out STD_LOGIC;
           mute         : out STD_LOGIC;
           pblrc        : out STD_LOGIC;
           pbdat : out STD_LOGIC);
           --End of Signals for Audio Codec
end Main;

architecture Behavioral of Main is
---------------------------HDMI ARCHITECTURE-------------------------
-- Video Timing Parameters
--1280x720@60HZ
constant HPIXELS_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(1280, 11)); --Horizontal Live Pixels
constant VLINES_HDTV720P  : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(720, 11));  --Vertical Live ines
constant HSYNCPW_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(80, 11));  --HSYNC Pulse Width
constant VSYNCPW_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(5, 11));    --VSYNC Pulse Width
constant HFNPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(72, 11));   --Horizontal Front Porch
constant VFNPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(3, 11));    --Vertical Front Porch
constant HBKPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(216, 11));  --Horizontal Front Porch
constant VBKPRCH_HDTV720P : std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(22, 11));   --Vertical Front Porch

constant pclk_M : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(36, 8));
constant pclk_D : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(24, 8)); 

constant tc_hsblnk: std_logic_vector(10 downto 0) := (HPIXELS_HDTV720P - 1);
constant tc_hssync: std_logic_vector(10 downto 0) := (HPIXELS_HDTV720P - 1 + HFNPRCH_HDTV720P);
constant tc_hesync: std_logic_vector(10 downto 0) := (HPIXELS_HDTV720P - 1 + HFNPRCH_HDTV720P + HSYNCPW_HDTV720P);
constant tc_heblnk: std_logic_vector(10 downto 0) := (HPIXELS_HDTV720P - 1 + HFNPRCH_HDTV720P + HSYNCPW_HDTV720P + HBKPRCH_HDTV720P);
constant tc_vsblnk: std_logic_vector(10 downto 0) := (VLINES_HDTV720P - 1);
constant tc_vssync: std_logic_vector(10 downto 0) := (VLINES_HDTV720P - 1 + VFNPRCH_HDTV720P);
constant tc_vesync: std_logic_vector(10 downto 0) := (VLINES_HDTV720P - 1 + VFNPRCH_HDTV720P + VSYNCPW_HDTV720P);
constant tc_veblnk: std_logic_vector(10 downto 0) := (VLINES_HDTV720P - 1 + VFNPRCH_HDTV720P + VSYNCPW_HDTV720P + VBKPRCH_HDTV720P);
signal sws_clk: std_logic_vector(3 downto 0); --clk synchronous output
signal sws_clk_sync: std_logic_vector(3 downto 0); --clk synchronous output
signal bgnd_hblnk : std_logic;
signal bgnd_vblnk : std_logic;

signal red_data, green_data, blue_data : std_logic_vector(7 downto 0) := (others => '0');
signal hcount, vcount : std_logic_vector(10 downto 0);
signal hsync, vsync, active : std_logic;
signal pclk : std_logic;
signal clkfb : std_logic;
signal rgb_data : std_logic_vector(23 downto 0) := (others => '0');

signal slow_clk_hdmi : std_logic;
signal countVal_hdmi : unsigned(27 downto 0):= (others => '0');

constant COLOR1_RED : std_logic_vector(7 downto 0) := x"FF";
constant COLOR1_GREEN : std_logic_vector(7 downto 0) := x"00";
constant COLOR1_BLUE : std_logic_vector(7 downto 0) := x"00";

constant COLOR2_RED : std_logic_vector(7 downto 0) := x"FF";
constant COLOR2_GREEN : std_logic_vector(7 downto 0) := x"40";
constant COLOR2_BLUE : std_logic_vector(7 downto 0) := x"40";

constant COLOR3_RED : std_logic_vector(7 downto 0) := x"F0";
constant COLOR3_GREEN : std_logic_vector(7 downto 0) := x"80";
constant COLOR3_BLUE : std_logic_vector(7 downto 0) := x"80";

constant COLOR4_RED : std_logic_vector(7 downto 0) := x"FF";
constant COLOR4_GREEN : std_logic_vector(7 downto 0) := x"C1";
constant COLOR4_BLUE : std_logic_vector(7 downto 0) := x"C1";
---------------------------HDMI ARCHITECTURE END HERE------------------------

-----------------------------------------------------------------------------
---------------------------AUDIO CODEC ARCHITECTURE--------------------------
signal mclk_sig, ready, slow_clk_codec      : std_logic;
signal l_data, r_data                       : std_logic_vector(23 downto 0) := (others => '0');
signal countVal_codec                       : unsigned(24 downto 0):= (others => '0');
--Signals for generating the audio square wave
signal tone_terminal_count, tone_counter    : unsigned(6 downto 0) := (others => '0');
signal half_tone_counter                    : std_logic_vector(23 downto 0);-- := tone_terminal_count / 2;
--Clock cycle counts for 200Hz, 400Hz, 800Hz, 1600Hz
constant COUNT_C5 : unsigned(6 downto 0):= to_unsigned(92,7);   --48KHz audio rate, 523Hz signal

type sound is (IDLE, NOTE1);
signal codec_state    : sound := IDLE;
---------------------------AUDIO CODEC END HERE----------------------------

-----------------------------------------------------------------------------
--------------------------- PROJECT SIGNALS CODE START HERE------------------
constant  triggerValue: integer:= 743;
signal triggerCountCycle: unsigned(11 downto 0):= (others => '0');
signal echoCount: unsigned(22 downto 0):= (others => '0');

type sensorState is (SEND, RECEIVE, CALCULATE, DISPLAY);
signal currentSensorState: sensorState := SEND;
type sensorRange is (NA, SHORT, MEDIUM_SHORT, MEDIUM_LONG, LONG);
signal rangeVal: sensorRange:= NA;
--------------------------- PROJECT SIGNALS CODE END HERE--------------------

begin --WHOLE PROCESS BEGINS

-------------------------------------HDMI------------------------------------
-----------------PLL Clock for HDMI (74.25 MHz), CODEC (12.288 MHz)----------
pixel_clock_gen : entity work.pxl_clk_gen port map (
    clk_in1 => sys_clk,
    clk_out1 => pclk,
    clk_out2 => mclk_sig,
    locked => open,
    reset => '0'
);
-----------------------------------PLL ENDS-----------------------------------

-----------------------------------------------------------------------------
-----------------------Slow Clock for HDMI (74.25 MHz)-----------------------
slow_clk_hdmi_proc: process(pclk)
begin
if rising_edge(pclk)then
    if countVal_hdmi = 74250000 then
        slow_clk_hdmi <= '1';
        countVal_hdmi <= (others => '0');
    else 
        slow_clk_hdmi <= '0';
        countVal_hdmi <= countVal_hdmi + 1;
    end if;
end if;
end process slow_clk_hdmi_proc;
------------------Slow Clock for HDMI (74.25 MHz) END---------------------------

-----------------------------------------------------------------------
------------------------HDMI Components Entity-------------------------
timing_inst : entity work.timing port map (
	tc_hsblnk=>tc_hsblnk, --input
	tc_hssync=>tc_hssync, --input
	tc_hesync=>tc_hesync, --input
	tc_heblnk=>tc_heblnk, --input
	hcount=>hcount, --output
	hsync=>hsync, --output
	hblnk=>bgnd_hblnk, --output
	tc_vsblnk=>tc_vsblnk, --input
	tc_vssync=>tc_vssync, --input
	tc_vesync=>tc_vesync, --input
	tc_veblnk=>tc_veblnk, --input
	vcount=>vcount, --output
	vsync=>vsync, --output
	vblnk=>bgnd_vblnk, --output
	restart=>reset_btn,
	clk=>pclk);
hdmi_controller : entity work.rgb2dvi 
    generic map (
        kClkRange => 2
    )
    port map (
        TMDS_Clk_p => TMDS(3),
        TMDS_Clk_n => TMDSB(3),
        TMDS_Data_p => TMDS(2 downto 0),
        TMDS_Data_n => TMDSB(2 downto 0),
        aRst => '0',
        aRst_n => '1',
        vid_pData => rgb_data,
        vid_pVDE => active,
        vid_pHSync => hsync,
        vid_pVSync => vsync,
        PixelClk => pclk, 
        SerialClk => '0');     
active <= not(bgnd_hblnk) and not(bgnd_vblnk); 
rgb_data <= red_data & blue_data & green_data;
----------------------COMPONENTS ENTITY ENDS-------------------------------

---------------------------------------------------------------------------
------------------------------------AUDIO----------------------------------
half_tone_counter <= (others => '0') when tone_counter < tone_terminal_count/2 else X"0FFFFF";
codec :  entity work.ssm2603_i2s 
port map(
        clk => sys_clk,
        mclk => mclk_sig,
        bclk => bclk,
        mute => mute,
        pblrc => pblrc,
        pbdat => pbdat,
        l_data => l_data,
        r_data => r_data,
        ready => ready
);
mclk <= mclk_sig;
-----------------Slow Clock for Audio CODEC (12.288 MHz) -----------------
slow_clk_codec_proc: process(mclk_sig)
begin
if rising_edge(mclk_sig)then
    if countVal_codec = 122880000 then
        slow_clk_codec <= '1';
        countVal_codec <= (others => '0');
    else 
        slow_clk_codec <= '0';
        countVal_codec <= countVal_codec + 1;
    end if;
end if;
end process slow_clk_codec_proc;
-----------------Slow Clock for Audio CODEC (12.288 MHz) END-----------------
tone_counter_proc : process(mclk_sig)
begin
if rising_edge(mclk_sig) then
    if ready = '1' then
        if tone_counter = tone_terminal_count then
            tone_counter <= (others => '0');
        else
            tone_counter <= tone_counter + 1;
            l_data <= half_tone_counter;
            r_data <= half_tone_counter;
        end if;
    end if;
end if;
end process tone_counter_proc;
----------------------AUDIO CODES END------------------------------------

---------------------------------------------------------------------------
---------------------------MAIN PROJECT STARTS HERE------------------------
initialTrigger: process(pclk)
begin
if rising_edge(pclk) then
--    if switch = '0' then
--    currentSensorState <= DISPLAY;
--    triggerCountCycle <= (others => '0');
--    echoCount <= (others => '0');
--    rangeVal <= NA;
--    else
    case currentSensorState is
        when SEND =>
            if (triggerCountCycle <= triggerValue) then --count up to 10us in order to trigger the ultransonic sensor
                pulseTrigger <= '1';
                triggerCountCycle <= triggerCountCycle + 1;
            else
                pulseTrigger <= '0';
                triggerCountCycle <= (others => '0');
                currentSensorState <= RECEIVE;
            end if;
        when RECEIVE => -- wait until the pusle start to receive some input 
            if echoPulse = '1' then
                currentSensorState <= CALCULATE; 
            end if;

        when CALCULATE =>
            if echoPulse = '0' then -- check if all the returning puslse as been received
                currentSensorState <= DISPLAY;
            end if;
            echoCount <= echoCount + 1;
        when DISPLAY =>
            if (echoCount <= 0) and (echoCount > 1747060) then   -- check to see if the echoCount is approx less than 0 m
                rangeVal <= NA;
                codec_state <= IDLE;
            elsif (echoCount > 0) and (echoCount <= 43677) then   -- check to see if the echoCount is approx 10 cm
                rangeVal <= SHORT;
                codec_state <= NOTE1;
            elsif (echoCount > 43677) and (echoCount <= 87353) then  -- check to see if the echoCount is approx within 11 and 20 cm
                rangeVal <= MEDIUM_SHORT;
                codec_state <= IDLE;
            elsif (echoCount > 87353) and (echoCount <= 131030) then -- check to see if the echoCount is approx within 21 and 30 cm
                rangeVal <= MEDIUM_LONG;
                codec_state <= IDLE;
            elsif (echoCount > 131030) then -- check to see if the echoCount is approx greater 40 cm
                rangeVal <= LONG;
                codec_state <= IDLE;
            end if;
            echoCount <= (others => '0');
            currentSensorState <= SEND;
        end case;
end if;
--end if;
end process initialTrigger;

state_proc : process(mclk_sig)
begin
if rising_edge(mclk_sig) then
	case codec_state is
        when IDLE =>
            tone_terminal_count <= (others => '0');
        when NOTE1 =>
            tone_terminal_count <= COUNT_C5;
    end case;
end if;
end process state_proc;


process(hcount, vcount, rangeVal)
begin
case rangeVal is
    when NA =>
        distRange <= "0000";
        if (hcount > 0 and hcount < 1280 and vcount > 0 and vcount < 720) then
            red_data <= (others => '0');
            green_data <= (others => '1');
            blue_data <= (others => '0');
        end if;
    when SHORT => 
        distRange <= "1111";
        if (hcount > 0 and hcount < 1280 and vcount > 0 and vcount < 720) then
            red_data <= COLOR1_RED;
            green_data <= COLOR1_GREEN;
            blue_data <= COLOR1_BLUE;
--        else
--            red_data <= (others => '0');
--            green_data <= (others => '0');
--            blue_data <= (others => '0');
        end if;
    when MEDIUM_SHORT =>
        distRange <= "1110";
        if (hcount > 0 and hcount < 1280 and vcount > 0 and vcount < 720) then
            red_data <= COLOR2_RED;
            green_data <= COLOR2_GREEN;
            blue_data <= COLOR2_BLUE;
--        else
--            red_data <= (others => '0');
--            green_data <= (others => '0');
--            blue_data <= (others => '0');
        end if;       
    when MEDIUM_LONG => 
        distRange <= "1100";
        if (hcount > 0 and hcount < 1280 and vcount > 0 and vcount < 720) then
            red_data <= COLOR3_RED;
            green_data <= COLOR3_GREEN;
            blue_data <= COLOR3_BLUE;
--        else
--            red_data <= (others => '0');
--            green_data <= (others => '0');
--            blue_data <= (others => '0');
        end if;
    when LONG =>
        distRange <= "1000";
        if (hcount > 0 and hcount < 1280 and vcount > 0 and vcount < 720) then
            red_data <= COLOR4_RED;
            green_data <= COLOR4_GREEN;
            blue_data <= COLOR4_BLUE;
--        else
--            red_data <= (others => '0');
--            green_data <= (others => '0');
--            blue_data <= (others => '0');
        end if;
end case;
end process;

end Behavioral;
