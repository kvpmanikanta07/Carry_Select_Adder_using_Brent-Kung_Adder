// ============================================================
// 16-bit Modified Linear Brent Kung Carry Select Adder
// (LMBKCSA)
//
// Same as RLBKCSA but RCA (Cin=1) is replaced by BEC.
// BEC simply adds 1 to the BK (Cin=0) result, saving area.
//
// For N-bit BK adder, we need (N+1)-bit BEC.
// 4-bit BK -> 5-bit BEC
// ============================================================
module lm_bk_csa_16(
    input  [15:0] a,
    input  [15:0] b,
    input         cin,
    output [15:0] sum,
    output        cout
);
    // ---- Group 1: bits [3:0] ----
    wire [3:0] bk1_sum;
    wire       bk1_cout;
    bk4 g1_bk (.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(bk1_sum), .cout(bk1_cout));

    // BEC: adds 1 to {bk1_cout, bk1_sum} = 5-bit input
    wire [4:0] bec1_out;
    bec5 g1_bec (.b({bk1_cout, bk1_sum}), .x(bec1_out));
    // bec1_out[3:0] = sum if Cin=1, bec1_out[4] = carry if Cin=1

    wire [3:0] s1 = cin ? bec1_out[3:0] : bk1_sum;
    wire       c1 = cin ? bec1_out[4]   : bk1_cout;
    assign sum[3:0] = s1;

    // ---- Group 2: bits [7:4] ----
    wire [3:0] bk2_sum;
    wire       bk2_cout;
    bk4 g2_bk (.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .sum(bk2_sum), .cout(bk2_cout));

    wire [4:0] bec2_out;
    bec5 g2_bec (.b({bk2_cout, bk2_sum}), .x(bec2_out));

    wire [3:0] s2 = c1 ? bec2_out[3:0] : bk2_sum;
    wire       c2 = c1 ? bec2_out[4]   : bk2_cout;
    assign sum[7:4] = s2;

    // ---- Group 3: bits [11:8] ----
    wire [3:0] bk3_sum;
    wire       bk3_cout;
    bk4 g3_bk (.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .sum(bk3_sum), .cout(bk3_cout));

    wire [4:0] bec3_out;
    bec5 g3_bec (.b({bk3_cout, bk3_sum}), .x(bec3_out));

    wire [3:0] s3 = c2 ? bec3_out[3:0] : bk3_sum;
    wire       c3 = c2 ? bec3_out[4]   : bk3_cout;
    assign sum[11:8] = s3;

    // ---- Group 4: bits [15:12] ----
    wire [3:0] bk4_sum;
    wire       bk4_cout;
    bk4 g4_bk (.a(a[15:12]), .b(b[15:12]), .cin(1'b0), .sum(bk4_sum), .cout(bk4_cout));

    wire [4:0] bec4_out;
    bec5 g4_bec (.b({bk4_cout, bk4_sum}), .x(bec4_out));

    wire [3:0] s4 = c3 ? bec4_out[3:0] : bk4_sum;
    wire       c4 = c3 ? bec4_out[4]   : bk4_cout;
    assign sum[15:12] = s4;
    assign cout = c4;

endmodule
