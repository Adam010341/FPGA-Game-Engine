# ==============================================================================
# CLOCK
# ==============================================================================
set_location_assignment PIN_P11 -to MAX10_CLK1_50

# ==============================================================================
# BUTTONS (Push-buttons)
# ==============================================================================
set_location_assignment PIN_B8  -to KEY[0]
set_location_assignment PIN_A7  -to KEY[1]

# ==============================================================================
# SWITCHES (Slide Switches)
# ==============================================================================
set_location_assignment PIN_C10 -to SW[0]
set_location_assignment PIN_C11 -to SW[1]
set_location_assignment PIN_D12 -to SW[2]
set_location_assignment PIN_C12 -to SW[3]
set_location_assignment PIN_A12 -to SW[4]
set_location_assignment PIN_B12 -to SW[5]
set_location_assignment PIN_A13 -to SW[6]
set_location_assignment PIN_A14 -to SW[7]
set_location_assignment PIN_B14 -to SW[8]
set_location_assignment PIN_F15 -to SW[9]

# ==============================================================================
# LEDS
# ==============================================================================
set_location_assignment PIN_A8  -to LEDR[0]
set_location_assignment PIN_A9  -to LEDR[1]
set_location_assignment PIN_A10 -to LEDR[2]
set_location_assignment PIN_B10 -to LEDR[3]
set_location_assignment PIN_D13 -to LEDR[4]
set_location_assignment PIN_C13 -to LEDR[5]
set_location_assignment PIN_E14 -to LEDR[6]
set_location_assignment PIN_D14 -to LEDR[7]
set_location_assignment PIN_A11 -to LEDR[8]
set_location_assignment PIN_B11 -to LEDR[9]

# ==============================================================================
# KEYPAD (Rows and Columns)
# ==============================================================================
# Rows
set_location_assignment PIN_AB2 -to keypad_row[0]
set_location_assignment PIN_AB3 -to keypad_row[1]
set_location_assignment PIN_AA5 -to keypad_row[2]
set_location_assignment PIN_AA6 -to keypad_row[3]

# Columns
set_location_assignment PIN_Y5  -to keypad_col[0]
set_location_assignment PIN_Y4  -to keypad_col[1]
set_location_assignment PIN_Y3  -to keypad_col[2]
set_location_assignment PIN_AA2 -to keypad_col[3]

# ==============================================================================
# 7-SEGMENT DISPLAY HEX0 (Digit 0)
# ==============================================================================
set_location_assignment PIN_C14 -to HEX0[0]
set_location_assignment PIN_E15 -to HEX0[1]
set_location_assignment PIN_C15 -to HEX0[2]
set_location_assignment PIN_C16 -to HEX0[3]
set_location_assignment PIN_E16 -to HEX0[4]
set_location_assignment PIN_D17 -to HEX0[5]
set_location_assignment PIN_C17 -to HEX0[6]

# ==============================================================================
# 7-SEGMENT DISPLAY HEX1 (Digit 1)
# ==============================================================================
set_location_assignment PIN_C18 -to HEX1[0]
set_location_assignment PIN_D18 -to HEX1[1]
set_location_assignment PIN_E18 -to HEX1[2]
set_location_assignment PIN_B16 -to HEX1[3]
set_location_assignment PIN_A17 -to HEX1[4]
set_location_assignment PIN_A18 -to HEX1[5]
set_location_assignment PIN_B17 -to HEX1[6]

# ==============================================================================
# 7-SEGMENT DISPLAY HEX2 (Digit 2)
# ==============================================================================
set_location_assignment PIN_B20 -to HEX2[0]
set_location_assignment PIN_A20 -to HEX2[1]
set_location_assignment PIN_B19 -to HEX2[2]
set_location_assignment PIN_A21 -to HEX2[3]
set_location_assignment PIN_B21 -to HEX2[4]
set_location_assignment PIN_C22 -to HEX2[5]
set_location_assignment PIN_B22 -to HEX2[6]

# ==============================================================================
# 7-SEGMENT DISPLAY HEX3 (Digit 3)
# ==============================================================================
set_location_assignment PIN_F21 -to HEX3[0]
set_location_assignment PIN_E22 -to HEX3[1]
set_location_assignment PIN_E21 -to HEX3[2]
set_location_assignment PIN_C19 -to HEX3[3]
set_location_assignment PIN_C20 -to HEX3[4]
set_location_assignment PIN_D19 -to HEX3[5]
set_location_assignment PIN_E17 -to HEX3[6]

# ==============================================================================
# 7-SEGMENT DISPLAY HEX4 (Digit 4)
# ==============================================================================
set_location_assignment PIN_F18 -to HEX4[0]
set_location_assignment PIN_E20 -to HEX4[1]
set_location_assignment PIN_E19 -to HEX4[2]
set_location_assignment PIN_J18 -to HEX4[3]
set_location_assignment PIN_H19 -to HEX4[4]
set_location_assignment PIN_F19 -to HEX4[5]
set_location_assignment PIN_F20 -to HEX4[6]

# ==============================================================================
# 7-SEGMENT DISPLAY HEX5 (Digit 5)
# ==============================================================================
set_location_assignment PIN_J20 -to HEX5[0]
set_location_assignment PIN_K20 -to HEX5[1]
set_location_assignment PIN_L18 -to HEX5[2]
set_location_assignment PIN_N18 -to HEX5[3]
set_location_assignment PIN_M20 -to HEX5[4]
set_location_assignment PIN_N19 -to HEX5[5]
set_location_assignment PIN_N20 -to HEX5[6]

# ==============================================================================
# DOT MATRIX - ROWS
# ==============================================================================
set_location_assignment PIN_AA8  -to matrix_row_sel[0]
set_location_assignment PIN_AA10 -to matrix_row_sel[1]
set_location_assignment PIN_W10  -to matrix_row_sel[2]
set_location_assignment PIN_Y8   -to matrix_row_sel[3]
set_location_assignment PIN_V7   -to matrix_row_sel[4]
set_location_assignment PIN_W9   -to matrix_row_sel[5]
set_location_assignment PIN_V8   -to matrix_row_sel[6]
set_location_assignment PIN_W7   -to matrix_row_sel[7]

# ==============================================================================
# DOT MATRIX - COLUMNS (GROUP 0)
# ==============================================================================
set_location_assignment PIN_AB13 -to matrix_col_data[0]
set_location_assignment PIN_AA14 -to matrix_col_data[1]
set_location_assignment PIN_W5   -to matrix_col_data[2]
set_location_assignment PIN_Y11  -to matrix_col_data[3]
set_location_assignment PIN_W6   -to matrix_col_data[4]
set_location_assignment PIN_AB12 -to matrix_col_data[5]
set_location_assignment PIN_W12  -to matrix_col_data[6]
set_location_assignment PIN_W13  -to matrix_col_data[7]

# ==============================================================================
# DOT MATRIX - COLUMNS (GROUP 1)
# ==============================================================================
set_location_assignment PIN_AB10 -to matrix_col_data[8]
set_location_assignment PIN_AA15 -to matrix_col_data[9]
set_location_assignment PIN_V5   -to matrix_col_data[10]
set_location_assignment PIN_Y7   -to matrix_col_data[11]
set_location_assignment PIN_W8   -to matrix_col_data[12]
set_location_assignment PIN_AA9  -to matrix_col_data[13]
set_location_assignment PIN_AB11 -to matrix_col_data[14]
set_location_assignment PIN_W11  -to matrix_col_data[15]


