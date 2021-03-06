# Licensed under the MIT License <http://opensource.org/licenses/MIT>.
# SPDX-License-Identifier: MIT
# Copyright 2020 Igor Santarek

# Permission is hereby granted, free of charge, to any  person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software  without restriction, including without limitation the rights
# to use, copy,   modify, merge,  publish, distribute,  sublicense, and/or sell
# copies  of  the Software,  and  to  permit persons  to  whom the Software  is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY  OF  ANY KIND,  EXPRESS OR
# IMPLIED,  INCLUDING BUT  NOT  LIMITED TO  THE  WARRANTIES OF  MERCHANTABILITY,
# FITNESS FOR  A PARTICULAR PURPOSE AND  NONINFRINGEMENT. IN NO EVENT  SHALL THE
# AUTHORS  OR COPYRIGHT  HOLDERS  BE  LIABLE FOR  ANY  CLAIM,  DAMAGES OR  OTHER
# LIABILITY, WHETHER IN AN ACTION OF  CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE  OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends Node


class LSB_LZWBitUnpacker:
	var chunk_stream: PoolByteArray
	var bit_index: int = 0
	var byte: int
	var byte_index: int = 0

	func _init(_chunk_stream: PoolByteArray):
		chunk_stream = _chunk_stream
		self.get_byte()

	func get_bit(value: int, index: int) -> int:
		return (value >> index) & 1

	func set_bit(value: int, index: int) -> int:
		return value | (1 << index)

	func get_byte():
		byte = chunk_stream[byte_index]
		byte_index += 1
		bit_index = 0

	func read_bits(bits_count: int) -> int:
		var result: int = 0
		var result_bit_index: int = 0

		for _i in range(bits_count):
			if self.get_bit(byte, bit_index) == 1:
				result = self.set_bit(result, result_bit_index)
			result_bit_index += 1
			bit_index += 1

			if bit_index == 8:
				self.get_byte()

		return result

	func remove_bits(bits_count: int) -> void:
		self.read_bits(bits_count)
