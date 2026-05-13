# ⚡ High-Speed Low-Power Carry Select Adder using Brent-Kung Adder
### + 16×16 Vedic Multiplier Implementation in Verilog

> **Bachelor of Engineering Project** — Electronics & Communication Engineering  
> S.R.K.R. Engineering College, Bhimavaram (2018–2022)  
> Implemented and simulated using **Vivado Xilinx (FPGA)**

---

## 📌 Overview

This project implements and compares **four Carry Select Adder (CSA) architectures** that use the **Brent-Kung (BK) parallel prefix adder** instead of conventional Ripple Carry Adders (RCA), targeting reduced power consumption and improved speed.

The best-performing adder (**Modified SQRT BK CSA**) is then used as the core addition unit inside a **16×16 Vedic Multiplier**, demonstrating a complete low-power arithmetic datapath.

---

## 🎯 Motivation

| Adder Type | Speed | Area | Power |
|---|---|---|---|
| Ripple Carry Adder (RCA) | ❌ Slow O(N) | ✅ Small | ✅ Low |
| Carry Lookahead (CLA) | ✅ Fast | ❌ Large | ❌ High |
| **Carry Select Adder (CSA)** | ✅ Good | ✅ Medium | ✅ Medium |

Standard CSA uses dual RCAs — this project replaces them with **Brent-Kung adders** (O(log₂N) depth) and **Binary-to-Excess-1 Converters (BEC)** to further reduce area and power.

---

## 🏗️ Architecture

### Building Blocks

```
full_adder.v          →  1-bit Full Adder
rca.v                 →  N-bit Ripple Carry Adder (parameterized)
bk4.v                 →  4-bit Brent-Kung Adder
bk_variants.v         →  2-bit, 3-bit, 5-bit BK Adders
bec.v                 →  Binary-to-Excess-1 Converters (3/4/5/6-bit)
```

### The Four CSA Designs (16-bit)

```
rl_bk_csa_16.v        →  Regular Linear BK CSA
lm_bk_csa_16.v        →  Modified Linear BK CSA   (BEC replaces RCA)
sqrt_bk_csa_16.v      →  Regular SQRT BK CSA
msqrt_bk_csa_16.v     →  Modified SQRT BK CSA ★   (Best — lowest power)
```

### Application

```
vedic_multiplier.v    →  4×4 → 8×8 → 16×16 Vedic Multiplier
```

---

## 📐 Design Details

### Brent-Kung Adder (3-Stage Parallel Prefix)

```
Stage 1 — Pre-process:
    Pi = Ai XOR Bi   (Propagate)
    Gi = Ai AND Bi   (Generate)

Stage 2 — Carry Tree (Black Cells):
    G(i:j) = G(i:k+1)  OR  (P(i:k+1) AND G(k:j))
    P(i:j) = P(i:k+1)  AND P(k:j)

Stage 3 — Post-process:
    Ci   = G(i:0) OR (P(i:0) AND Cin)
    Si   = Pi XOR C(i-1)
```

### Binary-to-Excess-1 Converter (BEC)

Replaces the entire Cin=1 RCA path using only XOR and AND gates:

```
X0  = ~B0
X1  =  B1 XOR B0
X2  =  B2 XOR (B1 AND B0)
X3  =  B3 XOR (B2 AND B1 AND B0)
Cout = B3 AND B2 AND B1 AND B0
```

For an N-bit BK adder, a (N+1)-bit BEC is used.

### SQRT Grouping Scheme (16-bit)

| Group | Bit Range | Width |
|-------|-----------|-------|
| 1 | [1:0]   | 2-bit |
| 2 | [3:2]   | 2-bit |
| 3 | [6:4]   | 3-bit |
| 4 | [10:7]  | 4-bit |
| 5 | [15:11] | 5-bit |

Progressive group sizes balance MUX chain delay with adder computation delay, achieving O(sqrt(N)) overall delay.

### 16x16 Vedic Multiplier (Urdhva Tiryakbhyam)

```
A[15:0] x B[15:0]:

  Split:  AH = A[15:8],  AL = A[7:0]
          BH = B[15:8],  BL = B[7:0]

  Compute four 8x8 products:
    P0 = AL x BL    P1 = AL x BH
    P2 = AH x BL    P3 = AH x BH

  Final: Product = P0 + (P1 + P2)<<8 + P3<<16
         (addition uses Modified SQRT BK CSA)
```

---

## 📊 Results

### 16-bit Adder Comparison (Vivado Synthesis)

| Design | Setup Time (ns) | Hold Time (ns) | Total Delay (ns) | Power (W) |
|--------|:-:|:-:|:-:|:-:|
| CSA with RCA (baseline) | 9.070 | 2.465 | 11.535 | 11.589 |
| Regular Linear BK CSA | 9.235 | 2.260 | 11.495 | 11.879 |
| Modified Linear BK CSA | 9.087 | 2.277 | 11.364 | 11.445 |
| Regular SQRT BK CSA | 8.280 | 2.382 | **10.662** | 11.886 |
| **Modified SQRT BK CSA** | 8.522 | 2.279 | 10.801 | **11.562** |

### 16-bit Vedic Multiplier Comparison

| Design | Total Delay (ns) | Power (W) |
|--------|:-:|:-:|
| Vedic + Regular CSA | 19.468 | 39.435 |
| **Vedic + SQRT BK CSA** | **18.988** | **38.979** |

> **Modified SQRT BK CSA** achieves the best power consumption.  
> **SQRT BK CSA** achieves the best timing delay.  
> Vedic Multiplier with SQRT BK CSA outperforms baseline on both metrics.

---

## 🗂️ Repository Structure

```
carry-select-adder-brent-kung/
├── src/
│   ├── full_adder.v          — 1-bit Full Adder
│   ├── rca.v                 — Ripple Carry Adder (parameterized)
│   ├── bk4.v                 — 4-bit Brent-Kung Adder
│   ├── bk_variants.v         — 2-bit, 3-bit, 5-bit BK Adders
│   ├── bec.v                 — BEC converters
│   ├── rl_bk_csa_16.v        — Regular Linear BK CSA (16-bit)
│   ├── lm_bk_csa_16.v        — Modified Linear BK CSA (16-bit)
│   ├── sqrt_bk_csa_16.v      — Regular SQRT BK CSA (16-bit)
│   ├── msqrt_bk_csa_16.v     — Modified SQRT BK CSA (16-bit) BEST
│   └── vedic_multiplier.v    — 16x16 Vedic Multiplier
├── tb/
│   └── testbenches.v         — Testbenches for all designs
├── docs/
│   ├── reference_paper.pdf   — Pallavi Saxena, VLSI-SATA 2015
│   └── project_report.pdf    — Bachelor's Project Report
├── sim/
│   └── (waveform screenshots from Vivado)
└── README.md
```

---

## 🚀 How to Run in Vivado

**1. Clone the repository**
```bash
git clone https://github.com/<your-username>/carry-select-adder-brent-kung.git
cd carry-select-adder-brent-kung
```

**2. Open Vivado and Create Project**
- Select: RTL Project
- Add all `.v` files from `src/` as Design Sources
- Add `tb/testbenches.v` as Simulation Source

**3. Set Top Module**

For adder testing:
```
Top module:       msqrt_bk_csa_16
Simulation top:   tb_msqrt_bk_csa_16
```

For Vedic multiplier:
```
Top module:       vedic16x16_sqrtbk
Simulation top:   tb_vedic16x16
```

**4. Run Behavioral Simulation**
- Flow Navigator → Simulation → Run Simulation
- Check the console for `PASS` / `FAIL` on each test vector

**5. Synthesize for Reports**
- Flow Navigator → Synthesis → Run Synthesis
- Open: Reports → Power Report and Timing Summary

---

## 🛠️ Tools and Technologies

| Tool | Details |
|------|---------|
| HDL | Verilog (IEEE 1364-2001) |
| EDA Tool | Vivado Xilinx |
| Target Platform | FPGA (Artix-7 / Spartan-7) |
| Reference | Pallavi Saxena, VLSI-SATA 2015 |

---

## 📚 References

1. Pallavi Saxena, *"Design of Low Power and High Speed Carry Select Adder Using Brent Kung Adder"*, VLSI-SATA 2015, IEEE.
2. R. P. Brent and H. T. Kung, *"A regular layout for parallel adders"*, IEEE Trans. Comput., vol. C-31, pp. 260–264, 1982.
3. Y. Choi, *"Parallel Prefix Adder Design"*, Proc. 17th IEEE Symposium on Computer Arithmetic, 2005.
4. C. Durgadevi et al., *"Design of High Speed Vedic Multiplier Using Carry Select Adder"*, IJERT, NCIECC-2017.

---


## 📄 License

This project is shared for academic and educational reference.  
Please cite the original reference paper if using this work.
