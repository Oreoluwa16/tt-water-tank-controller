<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The Water Tank Level Controller is a finite state machine (FSM) with four states: Empty, Filling, Full, and Draining.
Two sensors feed into the system — a high-level sensor (s1_high) and a low-level sensor (s0_low).
These form a 2-bit sensor bus where 00 means empty, 01 means partially filled, 11 means full, and 10 is an impossible state.
The pump turns on automatically when the tank is empty or filling, and turns off when the tank is full.
If the sensors report an impossible reading (high sensor wet but low sensor dry), the error flag is raised and the pump is forced off for safety.

## How to test

Apply a clock signal and hold rst_n low briefly to reset the controller to the Empty state.
Set ui_in[0] (s1_high) and ui_in[1] (s0_low) to simulate different water levels.
Monitor uo_out[0] for the pump output and uo_out[1] for the error flag.
Walk through the states by setting: 00 (empty, pump on) then 01 (filling, pump on) then 11 (full, pump off) then 01 (draining, pump off) then 00 (back to empty).
Test the error condition by setting ui_in to 10 and confirming the error flag goes high and the pump turns off.
