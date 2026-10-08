# AI Edge Anomaly Detection Accelerator

> **RTL-based Edge-AI accelerator for real-time sensor anomaly detection using fixed-point arithmetic, squared Euclidean distance, score scaling, and hardware threshold classification.**

---

## 📌 Project Overview

The **AI Edge Anomaly Detection Accelerator** is a digital hardware implementation of a lightweight anomaly-detection algorithm designed for **edge devices and real-time sensor monitoring**.

Instead of performing the complete anomaly-detection computation on a CPU or software processor, the core mathematical operations are implemented directly in **Verilog RTL**.

The accelerator accepts multiple sensor measurements, compares them with a reference normal pattern, calculates a squared Euclidean distance, converts the distance into an anomaly score, and produces a final:

- **NORMAL**
- **ANOMALY**

classification.

The project combines:

**Artificial Intelligence + RTL Design + Digital VLSI + Hardware Acceleration + Verification**

---

# 🎯 Objectives

The main objectives of this project are:

- Implement a lightweight AI inference algorithm in RTL.
- Perform sensor-feature processing directly in hardware.
- Implement squared Euclidean distance using hardware arithmetic.
- Generate a hardware-friendly anomaly score.
- Perform threshold-based AI classification.
- Design an FSM-based inference controller.
- Measure inference latency in clock cycles.
- Develop a Python golden reference model.
- Generate automated normal/anomalous test data.
- Verify RTL behavior using self-checking testbenches.
- Prepare the design for FPGA/synthesis analysis.

---

# 🧠 AI Algorithm

The accelerator uses a simple distance-based anomaly detection algorithm.

A normal/reference feature vector is stored in the system.

For four features:

```text
Reference = [r0, r1, r2, r3]

Input = [x0, x1, x2, x3]
```

The squared Euclidean distance is calculated as:

```text
D = (x0-r0)²
  + (x1-r1)²
  + (x2-r2)²
  + (x3-r3)²
```

The calculated distance is then converted into an anomaly score:

```text
Score = Distance / SCALE
```

The final classification is:

```text
if Score >= Threshold
    ANOMALY
else
    NORMAL
```

This algorithm is computationally simple but useful for demonstrating how an AI mathematical model can be mapped into digital hardware.

---

# 🏗️ System Architecture

```text
                    SENSOR INPUT
                         │
                         ▼
              ┌────────────────────┐
              │ Feature Extractor  │
              └─────────┬──────────┘
                        │
                        ▼
              ┌────────────────────┐
              │  Distance Engine   │
              │                    │
              │ (Feature-Reference)│
              │       Squared      │
              └─────────┬──────────┘
                        │
                        ▼
              ┌────────────────────┐
              │   Anomaly Score    │
              │   Scaling Unit     │
              └─────────┬──────────┘
                        │
                        ▼
              ┌────────────────────┐
              │ Threshold          │
              │ Classifier         │
              └─────────┬──────────┘
                        │
                 ┌──────┴──────┐
                 │             │
                 ▼             ▼
              NORMAL        ANOMALY


                    CONTROL PATH
                         │
                         ▼
              ┌────────────────────┐
              │  Controller FSM    │
              └────────────────────┘

                         │
                         ▼
              ┌────────────────────┐
              │ Performance Monitor│
              │                    │
              │ Inference Latency  │
              └────────────────────┘
```

---

# 🔄 Inference Flow

The complete inference sequence is:

```text
START
  │
  ▼
FEATURE EXTRACTION
  │
  ▼
DISTANCE CALCULATION
  │
  ▼
ANOMALY SCORE
  │
  ▼
THRESHOLD CLASSIFICATION
  │
  ▼
NORMAL / ANOMALY
  │
  ▼
DONE
```

The controller FSM coordinates each stage.

---

# 🔢 Example

## Normal Reference

```text
Reference:
[100, 200, 300, 400]
```

## Normal Sensor Input

```text
Input:
[102, 201, 299, 405]
```

Differences:

```text
[2, 1, -1, 5]
```

Squared differences:

```text
[4, 1, 1, 25]
```

Distance:

```text
D = 4 + 1 + 1 + 25
D = 31
```

With:

```text
SCALE = 1024
```

the hardware score becomes:

```text
Score = 31 / 1024
```

Therefore:

```text
Score < Threshold
```

Classification:

```text
NORMAL
```

---

## Anomalous Sensor Input

```text
Input:
[500, 20, 800, 100]
```

The difference from the normal reference is much larger.

Therefore:

```text
Distance ↑
     │
     ▼
Score ↑
     │
     ▼
Threshold exceeded
     │
     ▼
ANOMALY
```

---

# 💻 RTL Modules

| File | Description |
|---|---|
| `feature_extractor.v` | Converts sensor inputs into wider internal features |
| `distance_engine.v` | Calculates squared Euclidean distance |
| `anomaly_score.v` | Converts distance into a scaled anomaly score |
| `threshold_classifier.v` | Performs NORMAL/ANOMALY classification |
| `anomaly_controller.v` | FSM controlling the inference sequence |
| `performance_monitor.v` | Measures inference latency |
| `ai_anomaly_accelerator.v` | Top-level AI accelerator |

---

# 🧪 Verification

Verification is performed using both **Verilog simulation** and a **Python golden reference model**.

## Verification Architecture

```text
                 Test Data
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
   Python Reference       Verilog RTL
       Model              Accelerator
          │                     │
          ▼                     ▼
    Expected Result        Actual Result
          │                     │
          └──────────┬──────────┘
                     ▼
                  Compare
                     │
                     ▼
              PASS / FAIL
```

---

# 🐍 Python Reference Model

The project includes:

```text
python/reference_model.py
```

The Python model implements the same mathematical algorithm used by the RTL:

```text
Distance
    ↓
Score
    ↓
Classification
```

This acts as the **golden reference** for hardware verification.

---

# 📊 Automated Test Data

The project includes:

```text
python/generate_test_data.py
```

This script generates:

- Normal sensor samples
- Anomalous sensor samples

Example:

```text
normal_samples.csv
anomaly_samples.csv
```

The generated data can be used for large-scale functional verification.

---

# 📈 Verification Report

The project includes:

```text
python/verify_model.py
python/verification_report.py
```

These scripts calculate:

- Number of test samples
- Correct classifications
- Normal-data accuracy
- Anomaly-data accuracy
- Overall verification accuracy

---

# 🧪 RTL Testbench

The main RTL testbench is:

```text
tb/ai_anomaly_accelerator_tb.v
```

The testbench verifies:

- Reset operation
- Start operation
- Feature extraction
- Distance calculation
- Score generation
- Normal classification
- Anomaly classification
- Controller operation
- Completion signal
- Inference latency

The testbench is self-checking and uses `$fatal` when an expected result is incorrect.

---

# 📈 Performance Monitoring

A dedicated performance-monitoring block measures inference latency.

The accelerator provides:

```text
inference_latency
latency_valid
```

The latency is measured in clock cycles.

For an accelerator requiring `N` cycles:

```text
Latency = N cycles
```

If the design operates at a clock frequency `F`:

```text
Inference Time = N / F
```

Throughput can then be calculated as:

```text
Throughput = F / N
```

Actual performance numbers should be obtained from simulation and synthesis rather than assumed values.

---

# ⚙️ Design Parameters

The RTL is parameterized to allow future modification.

| Parameter | Current Value |
|---|---:|
| Sensor Data Width | 16 bits |
| Feature Width | 32 bits |
| Distance Width | 64 bits |
| Score Width | 32 bits |
| Number of Features | 4 |
| Score Scale | 1024 |
| Classification Threshold | 100 |

These parameters can be modified for different hardware requirements.

---

# 🧩 Hardware Design Concepts

This project demonstrates several important digital/VLSI concepts:

### RTL Design

The complete AI datapath and controller are written in Verilog HDL.

### Datapath

The datapath performs:

```text
Subtraction
     ↓
Multiplication
     ↓
Addition
     ↓
Scaling
     ↓
Comparison
```

### Control Path

An FSM controls the sequence:

```text
IDLE
 ↓
FEATURE
 ↓
DISTANCE
 ↓
SCORE
 ↓
CLASSIFY
 ↓
DONE
```

### Signed Arithmetic

The design supports signed sensor/feature values and intermediate arithmetic.

### Hardware Multiplication

Squared-distance calculation requires multiplication:

```text
difference × difference
```

### Hardware Classification

The final decision is performed directly using a hardware comparator.

---

# 🚀 Applications

The architecture can be adapted for:

- Industrial machine monitoring
- Predictive maintenance
- IoT sensor monitoring
- Smart manufacturing
- Edge-AI systems
- Embedded anomaly detection
- Equipment fault detection
- Real-time sensor analytics

---

# 🔬 Future Improvements

The current design provides a foundation for a more advanced accelerator.

Future improvements include:

### 1. Configurable Feature Count

Support:

```text
4 → 8 → 16 → 32+
```

features.

### 2. Pipelined Arithmetic

Pipeline the subtract, multiply, and accumulate operations to increase clock frequency.

### 3. Parallel Distance Engine

Calculate multiple squared differences simultaneously.

```text
Feature 0 ──► MAC ──┐
Feature 1 ──► MAC ──┤
Feature 2 ──► MAC ──┼──► Accumulator
Feature 3 ──► MAC ──┘
```

### 4. BRAM-Based Storage

Store reference vectors and sensor data using FPGA Block RAM.

### 5. AXI Interface

Add:

```text
AXI4-Lite
```

for configuration and control.

### 6. AXI-Stream

Add streaming sensor-data input.

### 7. FPGA Implementation

Target the design to an FPGA and measure:

- LUT utilization
- Flip-Flops
- BRAM
- DSP utilization
- Maximum clock frequency

### 8. Power Optimization

Explore:

- Clock gating
- Operand isolation
- Reduced precision
- Data-path optimization

### 9. More Advanced AI Model

The distance-based detector can later be replaced with:

- Linear classifier
- Small neural network
- Decision tree
- TinyML model
- Autoencoder-based anomaly detection

---

# 🛠️ Tools and Technologies

## Hardware

- Verilog HDL
- RTL Design
- Digital Logic
- FSM
- Fixed-Point Arithmetic
- Hardware Acceleration

## AI / Software

- Python
- NumPy
- Golden Reference Model
- Automated Test Data Generation

## Simulation

- Icarus Verilog
- Verilator
- GTKWave

## Version Control

- Git
- GitHub

## Future FPGA Tools

The design can be adapted for:

- AMD/Xilinx Vivado
- Intel Quartus

---

# 📁 Repository Structure

```text
ai-edge-anomaly-detection-accelerator/
│
├── rtl/
│   ├── feature_extractor.v
│   ├── distance_engine.v
│   ├── anomaly_score.v
│   ├── threshold_classifier.v
│   ├── anomaly_controller.v
│   ├── performance_monitor.v
│   └── ai_anomaly_accelerator.v
│
├── tb/
│   └── ai_anomaly_accelerator_tb.v
│
├── python/
│   ├── reference_model.py
│   ├── generate_test_data.py
│   ├── verify_model.py
│   └── verification_report.py
│
├── docs/
│
└── README.md
```

---

# ▶️ Simulation

Example simulation flow using Icarus Verilog:

```bash
iverilog -o ai_sim \
rtl/feature_extractor.v \
rtl/distance_engine.v \
rtl/anomaly_score.v \
rtl/threshold_classifier.v \
rtl/anomaly_controller.v \
rtl/performance_monitor.v \
rtl/ai_anomaly_accelerator.v \
tb/ai_anomaly_accelerator_tb.v
```

Run:

```bash
vvp ai_sim
```

A waveform file is generated:

```text
ai_anomaly_accelerator.vcd
```

The waveform can be inspected using GTKWave.

---

# 🐍 Python Verification

Generate test data:

```bash
python python/generate_test_data.py
```

Run the reference model:

```bash
python python/reference_model.py
```

Run model verification:

```bash
python python/verify_model.py
```

Generate the verification report:

```bash
python python/verification_report.py
```

---

# 📊 Project Metrics

Actual measurements should be filled after simulation/synthesis.

| Metric | Value |
|---|---|
| Sensor Input Width | 16-bit |
| Feature Width | 32-bit |
| Distance Width | 64-bit |
| Score Width | 32-bit |
| Feature Count | 4 |
| Threshold | 100 |
| Inference Latency | TBD |
| Maximum Frequency | TBD |
| LUT Utilization | TBD |
| Flip-Flop Utilization | TBD |
| DSP Utilization | TBD |
| BRAM Utilization | TBD |
| Power | TBD |

---

# 🎓 Learning Outcomes

Through this project, the following concepts are demonstrated:

- Understanding AI algorithms at hardware level
- Mapping mathematical operations into RTL
- Designing synchronous digital circuits
- FSM-based control design
- Signed arithmetic
- Hardware multiplication
- Hardware accumulation
- Comparator-based classification
- Parameterized RTL
- Self-checking testbenches
- Python golden-model verification
- Automated test-data generation
- Latency measurement
- Hardware/software verification methodology
- Preparation for FPGA implementation

---

# 💼 Resume Description

### AI Edge Anomaly Detection Accelerator | Verilog, RTL, Python

> Designed a parameterized RTL-based Edge-AI anomaly detection accelerator implementing feature extraction, squared Euclidean distance, score scaling, threshold classification, FSM control, and inference-latency monitoring; developed a Python golden reference model and automated test-data generation for hardware verification.

---

# 🎤 Interview Explanation

### What is this project?

> This project implements a lightweight anomaly-detection algorithm directly in Verilog RTL for edge-AI applications. Sensor features are compared with a reference normal pattern using squared Euclidean distance. The resulting score is compared against a threshold to classify the input as normal or anomalous.

### Why hardware implementation?

> Hardware implementation can provide deterministic low-latency inference and can reduce the need for a processor to perform the core arithmetic operations.

### What AI algorithm did you use?

> I used a distance-based anomaly detection algorithm based on squared Euclidean distance between the incoming sensor feature vector and a reference normal vector.

### How did you verify it?

> I created a Python golden reference model that implements the same algorithm and used Verilog self-checking testbenches to verify the RTL implementation.

### What VLSI concepts did you learn?

> I worked with RTL datapath design, FSM control, signed arithmetic, hardware multiplication, parameterized modules, simulation, self-checking verification, and inference-latency measurement.

---

# ⭐ Key Features

```text
✓ Edge-AI inference
✓ Verilog RTL implementation
✓ Sensor feature processing
✓ Squared Euclidean distance
✓ Fixed-width arithmetic
✓ Hardware anomaly scoring
✓ Threshold classification
✓ FSM controller
✓ Performance monitoring
✓ Python golden model
✓ Automated test-data generation
✓ Self-checking verification
✓ FPGA-ready architecture
```

---

# 📌 Project Status

**Current Status:** RTL architecture and functional verification development

**Completed:**

- [x] Feature extractor
- [x] Distance engine
- [x] Anomaly score unit
- [x] Threshold classifier
- [x] Controller FSM
- [x] Top-level integration
- [x] Performance monitor
- [x] RTL testbench
- [x] Python reference model
- [x] Automated test-data generation
- [x] Verification scripts
- [x] Project documentation

**Planned:**

- [ ] RTL synthesis
- [ ] FPGA resource analysis
- [ ] Timing analysis
- [ ] Power estimation
- [ ] Pipelined datapath
- [ ] Configurable feature count
- [ ] AXI interface
- [ ] FPGA implementation

---

## 👩‍💻 Author

**ECE / VLSI Engineering Student**

**Areas of Interest:**

```text
VLSI Design
RTL Design
Digital IC Design
Verilog / SystemVerilog
Edge AI
Hardware Acceleration
FPGA
Embedded Systems
```


