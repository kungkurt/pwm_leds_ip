--
-- Company : TEIS AB
-- Engineer: Robin Riis
--
-- Create Date    : 2023-Apr-04 21:20
-- Design Name    : pw_leds.vhd
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
--  leds controlled with pulsewidth to set brightness on regular on-off pins
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

entity pw_leds is
  generic(
    nr_of_leds      : integer := 10;
    pulse_bits      : integer := 8;
    clock_count_len : natural := 196
  );
  port(
    clock    : in  std_logic;
    reset_n  : in  std_logic;
    write_n  : in  std_logic;
    addr     : in  std_logic_vector(3 downto 0);
    set_duty : in  std_logic_vector(pulse_bits-1 downto 0);
    led_val  : out std_logic_vector(31 downto 0);
    leds     : out std_logic_vector(nr_of_leds-1 downto 0)
  );
end entity pw_leds;

architecture rtl of pw_leds is
-- types
subtype led_current_value is std_logic_vector(pulse_bits-1 downto 0);
type led_adress is array(nr_of_leds-1 downto 0) of led_current_value;

-- signals
signal led_mem      : led_adress;
signal led_register : std_logic_vector(pulse_bits-1 downto 0);

-- components
component pw_pin is
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
end component pw_pin;

begin
  led_val(31 downto pulse_bits)  <= (others => '0');
  led_val(pulse_bits-1 downto 0) <= led_mem(to_integer(unsigned(addr)));
  
  pw_led_mem : process(clock, reset_n)
  begin
    if rising_edge(clock) then
      if write_n = '0' then
        led_mem(to_integer(unsigned(addr))) <= set_duty;
      end if;
    end if;
  end process pw_led_mem;
  
  pulse_width_leds : for led in 0 to nr_of_leds-1 generate
  signal duty_cycle : std_logic_Vector(pulse_bits-1 downto 0);
  begin
    set_duty_cycle : process(clock, reset_n)
    begin
      if reset_n = '0' then
        duty_cycle <= (others => '0');
      elsif rising_edge(clock) then
        if led = to_integer(unsigned(addr)) then
          duty_cycle <= led_mem(to_integer(unsigned(addr)));
        end if;
      end if;
    end process set_duty_cycle;
    
    pw_led : pw_pin generic map(pulse_bits => pulse_bits, clock_count_len => clock_count_len) port map(
      clock      => clock,
      reset_n    => reset_n,
      duty_cycle => duty_cycle,
      pulse_out  => leds(led)
    );
  end generate;
end architecture rtl;

