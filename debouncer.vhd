entity debouncer is
    Generic (DELAY_VALUE : integer := 100);
    Port ( clk : in STD_LOGIC;
    signal_in : in STD_LOGIC;
    signal_out : out STD_LOGIC
    );
   end entity debouncer;
   architecture Behavioral of debouncer is
    type legalStates is (INIT_OUTPUT, IDLING, WAITING, CHANGING);
    signal countReset : std_logic := 'U';
    signal countDone : std_logic := 'U';
    begin
   
    dbnceSM: process (clk)
    variable state : legalStates := INIT_OUTPUT;
    variable lastInput : std_logic := '0';
   
    begin
   
    sync_events: if rising_edge(clk) then
    case state is
    when INIT_OUTPUT =>
    signal_out <= '0';
    state := IDLING;
    when IDLING =>
    countReset <= '1';
   if ((lastInput /= signal_in) and (lastInput /= 'U')) then
    countReset <= '0';
   state := WAITING; 
   end if;
lastInput := signal_in;
 when WAITING =>
 countReset <= '0';

 if (lastInput /= signal_in) then
 lastInput := signal_in;
countReset <= '1';
 end if;
if (countDone = '1') then
 signal_out <= signal_in;
countReset <= '1';
state := IDLING;
 end if;
 when others=>
 signal_out <= 'U';
 end case;
 end if sync_events;
 end process dbnceSM;

 cntr: process (clk)
 constant adjLimit : integer := DELAY_VALUE - 3;
 variable internalCount : integer range 0 to adjLimit := adjLimit;
 begin
 if rising_edge(clk) then
 if (countReset = '1') then
 internalCount := adjLimit;
 countDone <= '0';
 else
 countDone <= '0';
 if (internalCount = 0) then
 countDone <= '1';
 else
 internalCount := internalCount - 1;
 end if;
 end if;
 end if;
 end process cntr;
 end Behavioral;