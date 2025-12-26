#pragma once

/**
 * @brief halts the system
 *
 * Architecture-independent abstraction function for halt instructions.
 */
void halt();

/**
 * @brief halts the system (looped)
 *
 * Basically just `halt` but in a for loop.
 */
void halt_loop();
