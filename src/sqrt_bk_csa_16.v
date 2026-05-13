// ============================================================
// 16-bit Regular Square Root Brent Kung Carry Select Adder
// (SQRTBKCSA)
//
// 5 groups with INCREASING bit widths (SQRT scheme):
//   Group 1: bits  [1:0]  - 2-bit  BK + 2-bit  RCA
//   Group 2: bits  [3:2]  - 2-bit  BK + 2-bit  RCA
//   Group 3: bits  [6:4]  - 3-bit  BK + 3-bit  RCA
//   Group 4: bits [10:7]  - 4-bit  BK + 4-bit  RCA
//   Group 5: bits [15:11] - 5-bit  BK + 5-bit  RCA
//
// Bit grouping matches Fig 7.3 in your report:
//   Sum[1:0], Sum[3:2], Sum[6:4], Sum[10:7], Sum[15:11]
// ============================================================
module sqrt_bk_csa_16(
    input  [15:0] a,
    input  [15:0] b,
    input         cin,
    output [15:0] sum,
    output        cout
);
    // ---- Group 1: bits [1:0] (2-bit) ----
    wire [1:0] bk1_s, rca1_s;
    wire       bk1_c, rca1_c;
    bk2  g1_bk  (.a(a[1:0]), .b(b[1:0]), .cin(1'b0), .sum(bk1_s), .cout(bk1_c));
    rca #(2) g1_rca (.a(a[1:0]), .b(b[1:0]), .cin(1'b1), .sum(rca1_s), .cout(rca1_c));

    wire [1:0] s1 = cin ? rca1_s : bk1_s;
    wire       c1 = cin ? rca1_c : bk1_c;
    assign sum[1:0] = s1;

    // ---- Group 2: bits [3:2] (2-bit) ----
    wire [1:0] bk2_s, rca2_s;
    wire       bk2_c, rca2_c;
    bk2  g2_bk  (.a(a[3:2]), .b(b[3:2]), .cin(1'b0), .sum(bk2_s), .cout(bk2_c));
    rca #(2) g2_rca (.a(a[3:2]), .b(b[3:2]), .cin(1'b1), .sum(rca2_s), .cout(rca2_c));

    wire [1:0] s2 = c1 ? rca2_s : bk2_s;
    wire       c2 = c1 ? rca2_c : bk2_c;
    assign sum[3:2] = s2;

    // ---- Group 3: bits [6:4] (3-bit) ----
    wire [2:0] bk3_s, rca3_s;
    wire       bk3_c, rca3_c;
    bk3  g3_bk  (.a(a[6:4]), .b(b[6:4]), .cin(1'b0), .sum(bk3_s), .cout(bk3_c));
    rca #(3) g3_rca (.a(a[6:4]), .b(b[6:4]), .cin(1'b1), .sum(rca3_s), .cout(rca3_c));

    wire [2:0] s3 = c2 ? rca3_s : bk3_s;
    wire       c3 = c2 ? rca3_c : bk3_c;
    assign sum[6:4] = s3;

    // ---- Group 4: bits [10:7] (4-bit) ----
    wire [3:0] bk4_s, rca4_s;
    wire       bk4_c, rca4_c;
    bk4  g4_bk  (.a(a[10:7]), .b(b[10:7]), .cin(1'b0), .sum(bk4_s), .cout(bk4_c));
    rca #(4) g4_rca (.a(a[10:7]), .b(b[10:7]), .cin(1'b1), .sum(rca4_s), .cout(rca4_c));

    wire [3:0] s4 = c3 ? rca4_s : bk4_s;
    wire       c4 = c3 ? rca4_c : bk4_c;
    assign sum[10:7] = s4;

    // ---- Group 5: bits [15:11] (5-bit) ----
    wire [4:0] bk5_s, rca5_s;
    wire       bk5_c, rca5_c;
    bk5  g5_bk  (.a(a[15:11]), .b(b[15:11]), .cin(1'b0), .sum(bk5_s), .cout(bk5_c));
    rca #(5) g5_rca (.a(a[15:11]), .b(b[15:11]), .cin(1'b1), .sum(rca5_s), .cout(rca5_c));

    wire [4:0] s5 = c4 ? rca5_s : bk5_s;
    wire       c5 = c4 ? rca5_c : bk5_c;
    assign sum[15:11] = s5;
    assign cout = c5;

endmodule
