// ============================================================
// 4-Bit Brent-Kung Adder
// Parallel prefix adder - O(log2 N) depth
// Three stages: Pre-process -> Carry tree -> Post-process
//
// Pre-process : Pi = Ai ^ Bi,  Gi = Ai & Bi
// Carry tree  : Uses black cells  CG = G_hi | (P_hi & G_lo)
//                                 CP = P_hi & P_lo
// Post-process: Ci-1 = Gi | (Pi & Cin_prev)
//               Si   = Pi ^ Ci-1
// ============================================================
module bk4(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    // ---------- Pre-process ----------
    wire [3:0] P, G;
    assign P = a ^ b;
    assign G = a & b;

    // ---------- Carry generation tree ----------
    // Level 1: pairs (1,0) and (3,2)
    wire G10, P10, G32, P32;
    assign G10 = G[1] | (P[1] & G[0]);
    assign P10 = P[1] & P[0];

    assign G32 = G[3] | (P[3] & G[2]);
    assign P32 = P[3] & P[2];

    // Level 2: group (3,0)
    wire G30, P30;
    assign G30 = G32 | (P32 & G10);
    assign P30 = P32 & P10;

    // Level 3: fill missing prefix (2,0)
    wire G20;
    assign G20 = G[2] | (P[2] & G10);

    // ---------- Carries ----------
    wire C0, C1, C2, C3;
    assign C0 = G[0] | (P[0] & cin);
    assign C1 = G10  | (P10  & cin);
    assign C2 = G20  | (P[2] & P10 & cin);  // G20 already folds in G10
    assign C3 = G30  | (P30  & cin);

    // ---------- Post-process (sum) ----------
    assign sum[0] = P[0] ^ cin;
    assign sum[1] = P[1] ^ C0;
    assign sum[2] = P[2] ^ C1;
    assign sum[3] = P[3] ^ C2;
    assign cout   = C3;

endmodule
