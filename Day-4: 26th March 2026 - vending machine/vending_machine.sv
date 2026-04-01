module vending_machine(
    input logic clk,
    input logic coin,
    input logic resetn,
    output logic dispense);

  reg [1:0] curr_state, next_state;
  localparam S0=0, S1=1, S2=2,S3=3;

  always_comb
  begin
    next_state = S0;
    case(curr_state)
      S0:
        next_state=coin?S1:S0;
      S1:
        next_state=coin?S2:S1;
      S2:
        next_state=coin?S3:S2;
      S3:
        next_state=S0;
      default:
        next_state = S0;
    endcase
  end

  always_ff@(posedge clk)
  begin
    if(!resetn)
      curr_state<=S0;
    else
      curr_state<=next_state;
  end

  assign dispense = curr_state == S3;
endmodule
