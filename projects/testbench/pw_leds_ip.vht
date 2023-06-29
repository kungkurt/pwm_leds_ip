-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "04/06/2023 02:35:50"
                                                            
-- Vhdl Test Bench template for design  :  pw_leds_ip
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all; 
use ieee.numeric_std.all;                               

ENTITY pw_leds_ip_test IS
END pw_leds_ip_test;
ARCHITECTURE pw_leds_ip_arch OF pw_leds_ip_test IS
-- constants
constant sys_clk_period : time := 20 ns;

-- types
subtype led_current_value is std_logic_vector(7 downto 0);
type led_adress is array(9 downto 0) of led_current_value;

-- signals                                                   
SIGNAL addr : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL clock : STD_LOGIC := '1';
SIGNAL cs_n : STD_LOGIC := '1';
SIGNAL din : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
SIGNAL dout : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
SIGNAL leds : STD_LOGIC_VECTOR(9 DOWNTO 0) := (others =>'0');
SIGNAL read_n : STD_LOGIC := '1';
SIGNAL reset_n : STD_LOGIC := '0';
SIGNAL write_n : STD_LOGIC := '1';

COMPONENT pw_leds_ip
	PORT (
    addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    clock : IN STD_LOGIC;
    cs_n : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    leds : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    read_n : IN STD_LOGIC;
    reset_n : IN STD_LOGIC;
    write_n : IN STD_LOGIC
	);
END COMPONENT;

alias led_ram is <<signal .pw_leds_ip_test.i1.pulse_leds.led_mem : led_adress>>;

BEGIN
	i1 : pw_leds_ip
	PORT MAP (
    addr => addr,
    clock => clock,
    cs_n => cs_n,
    din => din,
    dout => dout,
    leds => leds,
    read_n => read_n,
    reset_n => reset_n,
    write_n => write_n
	);
  
  clock <= not clock after sys_clk_period/2;
  
  test_pw_led_ip : process
  begin
    wait for sys_clk_period*2;
    reset_n <= '1';
    
    -- write to leds
    for led in 0 to 9 loop
      din     <= std_logic_vector(to_unsigned(led*20, din'length));
      addr    <= std_logic_vector(to_unsigned(led, addr'length));
      cs_n    <= '0';
      write_n <= '0';
      wait for sys_clk_period;
      cs_n    <= '1';
      write_n <= '1';
      wait for sys_clk_period*2;
      report "[Note] set led " & integer'image(led) & " to brightness " & integer'image(led*20) & " :)"  severity Note;
    end loop;
    
    wait for sys_clk_period*10;
    
    -- read leds
    for led in 0 to 9 loop
      addr   <= std_logic_vector(to_unsigned(led, addr'length));
      wait for sys_clk_period;
      cs_n   <= '0';
      read_n <= '0';
      wait for sys_clk_period;
      assert to_integer(unsigned(dout)) = led*20
        report "[Error] Led should have value " & integer'image(led*20) & " but have value " & integer'image(to_integer(unsigned(dout)))
        severity Failure;
      assert to_integer(unsigned(dout)) /= led*20
        report "[Ok] Led have correct value"
        severity Note;
      wait for sys_clk_period;
      cs_n   <= '1';
      read_n <= '1';
    end loop;
    
    assert false report "== All tests have passed ==" severity Failure;
  end process test_pw_led_ip;
                                         
END pw_leds_ip_arch;
