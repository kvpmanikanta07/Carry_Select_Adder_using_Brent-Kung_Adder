// ============================================================
// 2-Bit Brent-Kung Adder
// ============================================================
module bk2(
    input  [1:0] a,
    input  [1:0] b,
    input        cin,
    output [1:0] sum,
    output       cout
);
    wire [1:0] P, G;
    assign P = a ^ b;
    assign G = a & b;

    wire C0 = G[0] | (P[0] & cin);
    wire G10 = G[1] | (P[1] & G[0]);
    wire P10 = P[1] & P[0];
    wire C1 = G10 | (P10 & cin);

    assign sum[0] = P[0] ^ cin;
    assign sum[1] = P[1] ^ C0;
    assign cout   = C1;
endmodule

// ============================================================
// 3-Bit Brent-Kung Adder
// ============================================================
module bk3(
    input  [2:0] a,
    input  [2:0] b,
    input        cin,
    output [2:0] sum,
    output       cout
);
    wire [2:0] P, G;
    assign P = a ^ b;
    assign G = a & b;

    // Level 1
    wire G10 = G[1] | (P[1] & G[0]);
    wire P10 = P[1] & P[0];

    // Prefix (2,0)
    wire G20 = G[2] | (P[2] & G10);
    wire P20 = P[2] & P10;

    // Carries
    wire C0 = G[0] | (P[0] & cin);
    wire C1 = G10  | (P10  & cin);
    wire C2 = G20  | (P20  & cin);

    assign sum[0] = P[0] ^ cin;
    assign sum[1] = P[1] ^ C0;
    assign sum[2] = P[2] ^ C1;
    assign cout   = C2;
endmodule

// ============================================================
// 5-Bit Brent-Kung Adder
// ============================================================
module bk5(
    input  [4:0] a,
    input  [4:0] b,
    input        cin,
    output [4:0] sum,
    output       cout
);
    wire [4:0] P, G;
    assign P = a ^ b;
    assign G = a & b;

    // Level 1 pairs: (1,0),(3,2)
    wire G10 = G[1] | (P[1] & G[0]);
    wire P10 = P[1] & P[0];
    wire G32 = G[3] | (P[3] & G[2]);
    wire P32 = P[3] & P[2];

    // Level 2: (3,0)
    wire G30 = G32 | (P32 & G10);
    wire P30 = P32 & P10;

    // Fill (2,0)
    wire G20 = G[2] | (P[2] & G10);

    // (4,0) via (4,3)+(3,0)
    wire G43 = G[4] | (P[4] & G[3]);
    wire G40 = G43 | (P[4] & G30); // simplified as G[4]|(P[4]&G30)
    // more precisely:
    // G40 = G[4] | (P[4] & G30)
    wire G40_c = G[4] | (P[4] & G30);
    wire P40   = P[4] & P30;

    // Carries
    wire C0 = G[0] | (P[0] & cin);
    wire C1 = G10  | (P10  & cin);
    wire C2 = G20  | (P[2] & P10 & cin);
    wire C3 = G30  | (P30  & cin);
    wire C4 = G40_c | (P40 & cin);

    assign sum[0] = P[0] ^ cin;
    assign sum[1] = P[1] ^ C0;
    assign sum[2] = P[2] ^ C1;
    assign sum[3] = P[3] ^ C2;
    assign sum[4] = P[4] ^ C3;
    assign cout   = C4;
endmodule
