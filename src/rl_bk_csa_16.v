// ============================================================
// 16-bit Regular Linear Brent Kung Carry Select Adder
// (RLBKCSA)
//
// Structure: 4 equal groups of 4 bits each
//   Group 1 (bits  3:0 ) : 4-bit BK (Cin=0) + 4-bit RCA (Cin=1) + MUX
//   Group 2 (bits  7:4 ) : same, carry in from group 1
//   Group 3 (bits 11:8 ) : same, carry in from group 2
//   Group 4 (bits 15:12) : same, carry in from group 3
//
// Group 1 uses actual cin; other groups use mux-selected carry.
// ============================================================
module rl_bk_csa_16(
    input  [15:0] a,
    input  [15:0] b,
    input         cin,
    output [15:0] sum,
    output        cout
);
    // ---- Group 1: bits [3:0], uses actual cin ----
    wire [3:0] bk1_sum, rca1_sum;
    wire       bk1_cout, rca1_cout;

    bk4  g1_bk  (.a(a[3:0]),  .b(b[3:0]),  .cin(1'b0), .sum(bk1_sum),  .cout(bk1_cout));
    rca #(4) g1_rca (.a(a[3:0]), .b(b[3:0]), .cin(1'b1), .sum(rca1_sum), .cout(rca1_cout));

    wire [3:0] s1 = cin ? rca1_sum  : bk1_sum;
    wire       c1 = cin ? rca1_cout : bk1_cout;
    assign sum[3:0] = s1;

    // ---- Group 2: bits [7:4] ----
    wire [3:0] bk2_sum, rca2_sum;
    wire       bk2_cout, rca2_cout;

    bk4  g2_bk  (.a(a[7:4]),  .b(b[7:4]),  .cin(1'b0), .sum(bk2_sum),  .cout(bk2_cout));
    rca #(4) g2_rca (.a(a[7:4]), .b(b[7:4]), .cin(1'b1), .sum(rca2_sum), .cout(rca2_cout));

    wire [3:0] s2 = c1 ? rca2_sum  : bk2_sum;
    wire       c2 = c1 ? rca2_cout : bk2_cout;
    assign sum[7:4] = s2;

    // ---- Group 3: bits [11:8] ----
    wire [3:0] bk3_sum, rca3_sum;
    wire       bk3_cout, rca3_cout;

    bk4  g3_bk  (.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .sum(bk3_sum),  .cout(bk3_cout));
    rca #(4) g3_rca (.a(a[11:8]),.b(b[11:8]),.cin(1'b1), .sum(rca3_sum), .cout(rca3_cout));

    wire [3:0] s3 = c2 ? rca3_sum  : bk3_sum;
    wire       c3 = c2 ? rca3_cout : bk3_cout;
    assign sum[11:8] = s3;

    // ---- Group 4: bits [15:12] ----
    wire [3:0] bk4_sum, rca4_sum;
    wire       bk4_cout, rca4_cout;

    bk4  g4_bk  (.a(a[15:12]),.b(b[15:12]),.cin(1'b0), .sum(bk4_sum),  .cout(bk4_cout));
    rca #(4) g4_rca (.a(a[15:12]),.b(b[15:12]),.cin(1'b1),.sum(rca4_sum),.cout(rca4_cout));

    wire [3:0] s4 = c3 ? rca4_sum  : bk4_sum;
    wire       c4 = c3 ? rca4_cout : bk4_cout;
    assign sum[15:12] = s4;
    assign cout = c4;

endmodule
