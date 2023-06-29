--
-- Company : TEIS AB
-- Engineer: Robin Riis
--
-- Create Date    : 2023-Apr-04 21:41
-- Design Name    : pw_pin.vhd
-- Target Devices : DE10-Lite (ALTERA MAX 10: 10M50DAF484C7G)
-- Tool versions  : Quartus v18.1 and ModelSim
-- Testbench file : None
-- Do file        : None
--
-- History:
-----------
--  2023-04-04: something happend
--
-- Description:
---------------
--  logic for creating pwm signals on a normal GPIO pin
--  to calculate pulse_bits and clock_count_len use
--    <clock_hertz> / (<clock_count_len>*(2**<pulse_bits>-1))
--  for example
--    50000000 / (49*(2**10-1)) = 997.466.. which is about 1kHz
--
--  to get percentage of commanded duty cycle use this formula
--    (<commanded_duty_cycle>*100) / (2**<pulse_bits>-1)
--
-- In_signals:
--------------
--  clock  : std_logic                    -- System clock XX MHz
--
-- Out_signals:
---------------
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pw_pin is
  generic(
    pulse_bits      : integer := 8;
    clock_count_len : natural := 1
  );
  port(
    clock      : in  std_logic;
    reset_n    : in  std_logic;
    duty_cycle : in  std_logic_vector(pulse_bits-1 downto 0);
    pulse_out  : out std_logic
  );
end entity pw_pin;

architecture rtl of pw_pin is
-- constants
-- signals
signal clock_count : integer range 0 to clock_count_len-1;
signal pulse_count : unsigned(pulse_bits-1 downto 0);
-- components

begin
  clock_count_proc : process(clock, reset_n)
  begin
    if reset_n = '0' then
      clock_count <= 0;
    elsif rising_edge(clock) then
      if clock_count < clock_count_len-1 then
        clock_count <= clock_count + 1;
      else
        clock_count <= 0;
      end if;
    end if;
  end process clock_count_proc;
  
  pulse_width_proc : process(clock, reset_n)
  begin
    if reset_n = '0' then
      pulse_count <= (others => '0');
      pulse_out   <= '0';
    elsif rising_edge(clock) then
      if clock_count_len = 1 or clock_count = 0 then
        if pulse_count = unsigned(to_signed(-2, pulse_count'length)) then
          pulse_count <= (others => '0');
        else
          pulse_count <= pulse_count + 1;
        end if;
        
        if pulse_count < unsigned(duty_cycle) then
          pulse_out <= '1';
        else
          pulse_out <= '0';
        end if;
      end if;
    end if;
  end process pulse_width_proc;
end architecture rtl;

