entity lab2_design_top is
    Port ( reset_pin : in STD_LOGIC;
    clock_pin : in STD_LOGIC;
    serialDataIn_pin : in STD_LOGIC;
    serialDataOut_pin : out STD_LOGIC;
    LED_hi_pin : out STD_LOGIC;
    LED_lo_pin : out STD_LOGIC;
    DIP_pins : in STD_LOGIC_VECTOR (3 downto 0)
    );
   end lab2_design_top;
   architecture structural of lab_design_top is
    signal parallelDataOut : std_logic_vector(7 downto 0) := (others=>'U');
    signal dataValid : std_logic := 'U';
    signal parallelDataIn : std_logic_vector(7 downto 0) := (others=>'U');
    signal transmitRequest : std_logic := 'U';
    signal tx_ready : std_logic := 'U';
    signal send_character : std_logic := 'U';
    signal character_to_send : std_logic_vector(7 downto 0) := (others=>'U');
    signal DIP_debounced : std_logic_vector(3 downto 0) := (others=>'0');
    signal gnd : std_logic := '0';
   begin
   make_UART: UART
   generic map (BAUD_RATE => 9600,
   CLOCK_RATE => 40000000)
   port map(reset => reset_pin,
   clock => clock_pin,
   serialDataIn => serialDataIn_pin,
   parallelDataOut => parallelDataOut,
   dataValid => dataValid,
   parallelDataIn => parallelDataIn,
   transmitRequest => transmitRequest,
   txIsReady => tx_ready,
   serialDataOut => serialDataOut_pin
   );
   
   decoder: character_decoder
   generic map (CLOCK_FREQUENCY => 40_000_000)
   port map(clk => clock_pin,
   charFromUART_valid => dataValid,
   charFromUART => parallelDataOut,
   LED_hi => LED_hi_pin,
   LED_lo => LED_lo_pin,
   send_character => send_character,
   character_to_send => character_to_send
   );
   encoder: character_encoder
   port map(clk => clock_pin,
    character_decoded => send_character,
    character_to_send => character_to_send,
    tx_ready => tx_ready,
    parallelDataIn => parallelDataIn,
    transmitRequest => transmitRequest,
    DIP_dbncd => DIP_debounced
   );
   DIP_debouncers: for i in 0 to 3 generate
   dbncr: debouncer
   generic map (DELAY_VALUE => 4_000_000)
   port map(clk => clock_pin,
   signal_in => DIP_pins(i),
   signal_out => DIP_debounced(i)
   );
   end generate DIP_debouncers; 
   end structural;