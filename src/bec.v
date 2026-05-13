// ============================================================
// Binary to Excess-1 Converter (BEC)
// Adds 1 to input without a full adder.
// Used to replace the Cin=1 RCA path in Modified CSA designs.
//
// 4-bit BEC equations:
//   X0 = ~B0
//   X1 =  B1 ^ B0
//   X2 =  B2 ^ (B1 & B0)
//   X3 =  B3 ^ (B2 & B1 & B0)
//
// For N-bit:  Xi = Bi ^ (B[i-1] & B[i-2] & ... & B[0])
//             (XOR with AND of all lower bits)
// ============================================================

// --- 3-bit BEC (replaces 2-bit BK; outputs 3 bits = sum + carry) ---
module bec3(
    input  [1:0] b,       // original 2-bit BK sum (Cin=0 result)
    output [2:0] x        // result as if Cin=1 was used; x[2]=carry out
);
    assign x[0] = ~b[0];
    assign x[1] = b[1] ^ b[0];
    assign x[2] = b[1] & b[0];   // carry out
endmodule

// --- 4-bit BEC (replaces 3-bit BK) ---
module bec4(
    input  [2:0] b,
    output [3:0] x        // x[3] = carry out
);
    assign x[0] = ~b[0];
    assign x[1] = b[1] ^ b[0];
    assign x[2] = b[2] ^ (b[1] & b[0]);
    assign x[3] = b[2] & b[1] & b[0];  // carry out
endmodule

// --- 5-bit BEC (replaces 4-bit BK) ---
module bec5(
    input  [3:0] b,
    output [4:0] x        // x[4] = carry out
);
    assign x[0] = ~b[0];
    assign x[1] = b[1] ^ b[0];
    assign x[2] = b[2] ^ (b[1] & b[0]);
    assign x[3] = b[3] ^ (b[2] & b[1] & b[0]);
    assign x[4] = b[3] & b[2] & b[1] & b[0];  // carry out
endmodule

// --- 6-bit BEC (replaces 5-bit BK) ---
module bec6(
    input  [4:0] b,
    output [5:0] x        // x[5] = carry out
);
    assign x[0] = ~b[0];
    assign x[1] = b[1] ^ b[0];
    assign x[2] = b[2] ^ (b[1] & b[0]);
    assign x[3] = b[3] ^ (b[2] & b[1] & b[0]);
    assign x[4] = b[4] ^ (b[3] & b[2] & b[1] & b[0]);
    assign x[5] = b[4] & b[3] & b[2] & b[1] & b[0];  // carry out
endmodule
