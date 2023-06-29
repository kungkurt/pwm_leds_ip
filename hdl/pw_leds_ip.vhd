--
-- Company : TEIS AB
-- Engineer: Robin Riis
--
-- Create Date    : 2023-Apr-05 05:07
-- Design Name    : pw_leds_ip.vhd
-- Target Devices : DE10-Lite (ALTERA MAX 10: 10M50DAF484C7G)
-- Tool versions  : Quartus v18.1 and ModelSim
-- Testbench file : None
-- Do file        : None
--
-- History:
-----------
--  2023-04-05: something happend
--
-- Description:
---------------
--  this is a new file..
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

entity pw_leds_ip is
  generic(
    nr_of_leds      : integer := 10;
    pulse_bits      : integer := 8;
    clock_count_len : natural := 196
  );
  port(
    clock   : in  std_logic;
    reset_n : in  std_logic;
    cs_n    : in  std_logic;
    addr    : in  std_logic_vector(3 downto 0);
    write_n : in  std_logic;
    read_n  : in  std_logic;
    din     : in  std_logic_vector(31 downto 0);
    dout    : out std_logic_vector(31 downto 0);
    leds    : out std_logic_vector(nr_of_leds-1 downto 0)
  );
end entity pw_leds_ip;

architecture rtl of pw_leds_ip is
-- signals
signal data_register : std_logic_vector(31 downto 0);
signal ctrl_register : std_logic_Vector(pulse_bits-1 downto 0);

-- components
component pw_leds is
  generic(
    nr_of_leds      : integer := 10;
    pulse_bits      : integer := 10;
    clock_count_len : natural := 49
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
end component pw_leds;

begin
  
  bus_read : process(cs_n, read_n, write_n, data_register)
  --------
  -- output from data register
  begin
    if cs_n = '0' and (read_n = '0' and write_n = '1') then
      dout <= data_register;
    else
      dout <= (others => '0');
    end if;
  end process bus_read;
  
  bus_write : process(cs_n, read_n, write_n, din)
  ---------
  -- write to control register
  begin
    if cs_n = '0' and (read_n = '1' and write_n = '0') then
      ctrl_register <= din(pulse_bits-1 downto 0);
    else
      ctrl_register <= (others => '0');
    end if;
  end process bus_write;
  
  pulse_leds : pw_leds generic map(
    nr_of_leds      => nr_of_leds,
    pulse_bits      => pulse_bits,
    clock_count_len => clock_count_len
  ) port map (
    clock    => clock,
    reset_n  => reset_n,
    write_n  => write_n,
    addr     => addr,
    set_duty => ctrl_register,
    led_val  => data_register,
    leds     => leds
  );
end architecture rtl;

