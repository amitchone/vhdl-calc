entity UART_baudRateGenerator is
    generic (BAUD_RATE : integer := 19200;
    CLOCK_RATE : integer := 100000000);
    port ( reset : in STD_LOGIC;
    clock : in STD_LOGIC;
    baudRateEnable : out STD_LOGIC;
    baudRateEnable_x16 : out STD_LOGIC
    );
    constant nCountsPerBaud : integer := CLOCK_RATE / BAUD_RATE;
    constant nCountsPerBaud_X16 : integer := nCountsPerBaud / 16;
end entity UART_baudRateGenerator;
architecture BEHAVIORAL of UART_baudRateGenerator is
 begin

 make_x16en: process (clock)
 variable clockCount : integer range 0 to nCountsPerBaud_X16 := 0;
 begin
 syncEvents: if rising_edge(clock) then
 baudRateEnable_x16 <= '0';
 clockCount := clockCount + 1;
isCountDone: if (clockCount = nCountsPerBaud_X16) then
 baudRateEnable_x16 <= '1';
clockCount := 0;
 end if isCountDone;
 end if syncEvents;
 end process make_x16en;
 make_baudEn: process (clock)
 variable clockCount : integer range 0 to nCountsPerBaud := 0;
 begin
 syncEvents: if rising_edge(clock) then
 baudRateEnable <= '0';
 clockCount := clockCount + 1;
isCountDone: if (clockCount = nCountsPerBaud) then
 baudRateEnable <= '1';
clockCount := 0;
 end if isCountDone;
 end if syncEvents;
 end process make_baudEn;
 end architecture BEHAVIORAL;