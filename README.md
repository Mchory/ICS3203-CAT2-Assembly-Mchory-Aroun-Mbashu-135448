# ICS-3203- CAT2- ASSEMLY -MCHORY AROUN MBASHU 135448

# 1. Control Flow and Conditional Logic

##  Number Classification Program (64-bit) **

 Purpose: Classifies input numbers as positive, negative, or zero
 
using various jump instructions for control flow

## Jump Instructions and Their Impact on Program Flow

## 1. Conditional Jumps

### `je` (Jump if Equal)
- Used after comparing input with `'-'` and `'0'` to detect:
  - **Negative numbers**
  - **Zero**
- This creates specific execution paths for these cases.

### `jg` (Jump if Greater)
- Compares input with `'0'` to identify **positive numbers**.
- Ensures proper classification of positive values.

### `jne` (Jump if Not Equal)
- Used in `check_negative` to verify that the input is:
  - Actually **negative** (not just a minus sign).

---

## 2. Unconditional Jumps

### `jmp exit`
- Ensures **proper program termination** after results are printed.
- Prevents fall-through to unintended cases.

### `jmp print_positive`
- Acts as a **default case** when input doesn't match other conditions.
- Guarantees all inputs are classified.

---

## 3. Control Flow Design

### Hierarchical Checking System
1. **Negative Check:** First evaluates if input has a negative sign.
2. **Zero Check:** Then determines if the input is zero.
3. **Positive Check:** Finally classifies positive numbers.
4. **Default Case:** Handles unexpected input scenarios.

---
# Build and Run Instructions
```
# Assemble for 64-bit
nasm -f elf64 number_classifier.asm -o number_classifier.o

# Link for 64-bit
ld -o number_classifier number_classifier.o

# Make executable
chmod +x number_classifier

# Run
./number_classifier"
```
# 2. Array Manipulation with Looping and Reversal 

Array Reversal Program (64-bit)

 Purpose: Accepts 5 integers, reverses them in place, and displays the result

Memory Efficiency: Uses in-place reversal without additional array storage

## MEMORY HANDLING CHALLENGES
 This program handles several memory-related challenges:

 1. Input Storage Challenge:
    - Need to handle ASCII input but store as numbers
    - Solution: Convert ASCII to numeric during input
    - Impact: Requires careful handling of ASCII/numeric conversion

 2. In-Place Reversal Challenge:
    - Must swap values without using additional array
    - Solution: Use registers as temporary storage
    - Impact: Minimizes memory usage but requires careful register management

 3. Array Bounds Challenge:
    - Must track array boundaries during reversal
    - Solution: Use two indices (left/right) moving toward center
    - Impact: Prevents out-of-bounds access and ensures complete reversal

 4. Memory Access Patterns:
    - Direct memory access for array elements
    - Byte-level operations for single-digit numbers
    - Register-based temporary storage for swaps

 5. Memory Efficiency:
    - No additional array allocation
    - Minimal temporary storage
    - Direct manipulation of original array
   ---
  # Build and Run Instructions
```
# Assemble
nasm -f elf64 array_reversal.asm -o array_reversal.o

# Link
ld -o array_reversal array_reversal.o

# Make executable
chmod +x array_reversal

# Run
./array_reversal
```
# 3. Modular Program with Subroutines for Factorial Calculation
Factorial Calculator Program (64-bit)

 Purpose: Calculate factorial using subroutines and stack management
 
 Features: Proper register preservation, modular design, stack usage

## REGISTER MANAGEMENT 
 Register Usage and Preservation Strategy:

 Key Registers:
 rax - Used for system calls and factorial result
 
 rdi - Used for parameter passing to factorial subroutine
 
 rcx - Used as counter in factorial calculation
 
 r10 - Temporary storage during string conversion

 Stack Usage:
 - Push registers before modifying them in subroutines
 - Restore registers in reverse order (LIFO principle)
 - Maintain 16-byte stack alignment for system stability

 Register Preservation Rules:
 1. Caller-saved: rax, rdi (saved before subroutine call)
 2. Callee-saved: rcx, r10 (saved within subroutine)
 3. Stack pointer (rsp) alignment maintained throughout

## STACK MANAGEMENT 
 Stack Operations Details:

 1. Main Program Stack Usage:
    - Preserves input number before factorial calculation
    - Maintains 16-byte alignment for system calls

 2. Factorial Subroutine Stack Frame:
    - Creates standard stack frame with base pointer
    - Preserves RCX for loop counter
    - Preserves RDI containing input number
    - Restores in reverse order (LIFO)

 3. Number Conversion Stack Usage:
    - Temporarily stores digits during conversion
    - Preserves registers for string manipulation
    - Maintains proper alignment throughout

 4. Stack Frame Management:
    - Each subroutine establishes its own frame
    - Properly deallocates all stack space
    - Ensures no stack leaks or corruption
      
# Build and Run Instructions
```
# Assemble
nasm -f elf64 factorial.asm -o factorial.o

# Link
ld -o factorial factorial.o

# Make executable
chmod +x factorial

# Run
./factorial
```
# 4. Data Monitoring and Control Using Port-Based Simulation

## Data Monitoring and Control Using Port-Based Simulation

## Overview
This program simulates a control system for monitoring water levels and managing a motor and alarm based on sensor input. The system reads a simulated "sensor value" from an input, processes the data, and updates the status of the motor and alarm based on defined thresholds.

## Functionality
The program performs the following actions:
1. **Reads a Sensor Value**: Simulates reading a water level value from user input (representing a sensor) and stores it in a specific memory location.
2. **Processes the Input**:
   - If the water level is **too low**: The motor is turned **ON**.
   - If the water level is **too high**: The alarm is **triggered**.
   - If the water level is **moderate**: The motor is **stopped** and the alarm is **off**.
3. **Updates Output**: Based on the status of the motor and alarm, corresponding messages are displayed to the user.

---

## How the Program Works

### **1. Reading the Sensor Value**
The sensor value is simulated through user input:
- Input is read using the `sys_read` system call and stored in a buffer (`input_buffer`).
- The program converts the ASCII input to an integer and stores it in the memory location `sensor_value`.

### **2. Processing the Sensor Data**
The sensor value is compared against predefined thresholds:
- **Low Threshold** (`LOW_THRESHOLD = 30`):
  - If the value is less than or equal to 30, the motor is turned **ON** (`motor_status = 1`), and the alarm is kept **OFF** (`alarm_status = 0`).
- **High Threshold** (`HIGH_THRESHOLD = 80`):
  - If the value is greater than or equal to 80, the alarm is triggered (`alarm_status = 1`), and the motor is turned **OFF** (`motor_status = 0`).
- **Moderate Range** (between 30 and 80):
  - Both the motor and alarm are turned **OFF** (`motor_status = 0`, `alarm_status = 0`).

This logic is implemented in the `process_sensor_data` function.

### **3. Updating Outputs**
Based on the processed data:
- **Motor Status**:
  - If `motor_status = 1`, the message "Motor status: ON" is displayed.
  - If `motor_status = 0`, the message "Motor status: OFF" is displayed.
- **Alarm Status**:
  - If `alarm_status = 1`, the message "ALARM: Water level critical!" is displayed.
  - If `alarm_status = 0`, and the motor is also off, the message "Water level normal" is displayed.

Output messages are managed in the `update_outputs` function using the `sys_write` system call.

---

## Memory and Port Manipulation

The program uses the following memory locations:
- **`sensor_value`**:
  - Stores the sensor reading (water level) in the range 0-99.
- **`motor_status`**:
  - Indicates whether the motor is ON (`1`) or OFF (`0`).
- **`alarm_status`**:
  - Indicates whether the alarm is triggered (`1`) or OFF (`0`).

### Memory Updates
- **Motor Control**: The `motor_status` memory location is updated based on the water level:
  - `1` for ON, `0` for OFF.
- **Alarm Control**: The `alarm_status` memory location reflects the alarm state:
  - `1` for ON, `0` for OFF.

---

## Thresholds
The program uses two defined thresholds:
- `LOW_THRESHOLD = 30`: Below or equal to this level, the motor is turned ON.
- `HIGH_THRESHOLD = 80`: Above or equal to this level, the alarm is triggered.

---
# Build and Run Instructions
```
# Assemble
nasm -f elf64 water_control.asm -o water_control.o

# Link
ld water_control.o -o water_control

# Make executable
chmod +x water_control

# Run
./water_control
```