--[[
Yet Another Data Serializer - Fast and compact lua serializer
Copyright (C) 2024 Deviatt

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
]]


--> Config
---> Enable null-terminated string.
----> true (slower, compact)
----> false (faster, bulky) NOTE: Adds string length of the dword.
local SZT = true

---> Enable IEEE754 like float.
----> true (slower, compact) NOTE: 4 bytes
----> false (faster, bulky) NOTE: 7 bytes
local IEEE754 = true

---> Float encoding accuracy.
local PRECISION, UNPRECISION = 1e7, 1e-7

--> Types
---> nil, none, null and etc...
local TYPE_NIL = 0
---> Booleans
local TYPE_TRUE = 1
local TYPE_FALSE = 2
---> Numerical types
local TYPE_BYTE = 3
local TYPE_SHORT = 4
local TYPE_INT = 5
local TYPE_LONG = 6
local TYPE_NUM = 7
---> Negative numerical types
local TYPE_NBYTE = 8
local TYPE_NSHORT = 9
local TYPE_NINT = 10
local TYPE_NLONG = 11
local TYPE_NNUM = 12
---> String type
local TYPE_STR = 13
---> Complex types
local TYPE_APART = 14 -- only indices
local TYPE_HPART = 15 -- only keys
local TYPE_TABLE = 16 -- both

---> DO NOT EDIT!!!
local NEGOFFSET = TYPE_NBYTE - TYPE_BYTE

local char, byte = string.char, string.byte
local band, shl, shr
if (bit or bit32) then
	local bit = bit or bit32
	band, shl, shr = bit.band, bit.lshift, bit.rshift
else
	local loadop = function(op) return load(("local x, y = ... return x %s y"):format(op)) end
	band, shl, shr = loadop '&', loadop "<<", loadop ">>"
end

local floor, ceil = math.floor, math.ceil
local serial do
	local buf = {}
	local serials do
		local abs, log = math.abs, math.log
		local f32 do
			if (IEEE754) then
				local frexp do
					if (jit) then
						function frexp(x)
							if (x == 0) then return 0.0, 0.0 end
							local e = floor(log(abs(x), 2))
							x = x / shl(1, e)

							if (abs(x) >= 1) then
								x, e = x * .5, e + 1
							end

							return x, e
						end
					else
						frexp = math.frexp
					end
				end

				function f32(m)
					local e
					m, e = frexp(m)
					m = ceil(m * PRECISION - .5) -- shl(m * PRECISION - .5, 0)
					return char(band(m, 0xFF), band(shr(m, 8), 0xFF), band(shr(m, 16), 0xFF), e)
				end
			else
				function f32(x)
					x, y = floor(x), floor((x % 1) * PRECISION + .5)
					return char(
						band(x, 0xFF), band(shr(x, 8), 0xFF), band(shr(x, 16), 0xFF), band(shr(x, 24), 0xFF),
						band(y, 0xFF), band(shr(y, 8), 0xFF), band(shr(y, 16), 0xFF)
					)
				end
			end
		end

		--> NOTE 1: This method hasn't been thoroughly tested and may produce undefined behavior!!!
		--> NOTE 2: There maybe memory risks, although none have been detected at this time.
		local lookup do
			local function byte(x)
				return char(x)
			end

			local function word(x)
				-- word to bytes
				return char(band(x, 0xFF), shr(x, 8))
			end

			local function dword(x)
				-- dword to bytes
				return char(band(x, 0xFF), band(shr(x, 8), 0xFF), band(shr(x, 16), 0xFF), shr(x, 24))
			end

			local function qword(x)
				-- TODO
				return '\0'
			end

			local lookat = {
				[math.huge] = function() return '' end,
				[-math.huge] = function() return '' end,
				[00] = byte,	[08] = word,	[16] = dword,	[24] = dword,
				[01] = byte,	[09] = word,	[17] = dword,	[25] = dword,
				[02] = byte,	[10] = word,	[18] = dword,	[26] = dword,
				[03] = byte,	[11] = word,	[19] = dword,	[27] = dword,
				[04] = byte,	[12] = word,	[20] = dword,	[28] = dword,
				[05] = byte,	[13] = word,	[21] = dword,	[29] = dword,
				[06] = byte,	[14] = word,	[22] = dword,	[30] = dword,
				[07] = byte,	[15] = word,	[23] = dword,	[31] = dword,
				[32] = qword,	[33] = qword,	[34] = qword,	[35] = qword,
				[36] = qword,	[37] = qword,	[38] = qword,	[39] = qword,
				[40] = qword,	[41] = qword,	[42] = qword,	[43] = qword,
				[44] = qword,	[45] = qword,	[46] = qword,	[47] = qword,
				[48] = qword,	[49] = qword,	[50] = qword,	[51] = qword,
				[52] = qword,	[53] = qword,	[54] = qword,	[55] = qword,
				[56] = qword,	[57] = qword,	[58] = qword,	[59] = qword,
				[60] = qword,	[61] = qword,	[62] = qword,	[63] = qword
			}

			--> Index misses hurt performance!
			lookup = setmetatable({
				[0] = '\0'
			}, {
				__index = function(self, x)
					local y = lookat[floor(log(x, 2))](x)
					self[x] = y
					return y
				end
			})
		end

		local ntypes = {
			[0] = TYPE_NIL,
			[1] = TYPE_BYTE,
			[2] = TYPE_SHORT,
			[4] = TYPE_INT,
			[8] = TYPE_LONG
		}

		local next, type, strfmt = next, type, string.format
		serials = {
			["nil"] = function(x, idx)
				buf[idx] = char(TYPE_NIL)
				return idx + 1
			end,
			["boolean"] = function(x, idx)
				buf[idx] = char(x and TYPE_TRUE or TYPE_FALSE)
				return idx + 1
			end,
			["string"] = SZT and function(x, idx)
				if (byte(x, -1) ~= 0) then
					x = x..'\0'
				end

				buf[idx] = char(TYPE_STR)..x
				return idx + 1
			end or function(x, idx)
				buf[idx] = strfmt("%c%s%s", TYPE_STR, lookup[#x], x)
				return idx + 1
			end,
			["number"] = function(x, idx)
				if (x % 1 == 0) then
					local y = lookup[abs(x)]
					local tt = ntypes[#y]
					if (x < 0) then
						tt = tt + NEGOFFSET
					end

					buf[idx] = char(tt)..y
				else
					buf[idx] = char(x < 0 and TYPE_NNUM or TYPE_NUM)..f32(abs(x))
				end

				return idx + 1
			end,
			["table"] = function(x, idx)
				local len = #x
				local isarr = len ~= 0
				local k, v = next(x, isarr and len or nil)
				if (k and isarr) then
					buf[idx], idx = char(TYPE_TABLE), idx + 1
				end

				if (isarr) then
					buf[idx], idx = char(TYPE_APART), idx + 1
					for i = 1, len do
						local y = x[i]
						local fn = serials[type(y)]
						if (fn and x ~= y) then
							idx = fn(y, idx)
						end
					end

					buf[idx], idx = '\255', idx + 1
				end

				if (k) then
					buf[idx], idx = char(TYPE_HPART), idx + 1

					::retry::
					local fn = serials[type(k)]
					if (fn and x ~= k and x ~= v) then
						idx = fn(k, idx)

						fn = serials[type(v)]
						if (fn) then
							idx = fn(v, idx)
						end
					end

					k, v = next(x, k)
					if (k) then goto retry end

					buf[idx], idx = '\255', idx + 1
				end

				return idx
			end
		}
	end

	local tconcat = table.concat
	function serial(x)
		local idx = 1
		local fn = serials[type(x)]
		if (fn) then
			idx = fn(x, idx)
		end

		return tconcat(buf, '', 1, idx - 1)
	end
end

local deserial do
	local deserials do
		local sub, find = string.sub, string.find

		-- bytes to dword
		local function b2dw(ll, lh, hl, hh)
			return ll + shl(lh, 8) + shl(hl, 16) + shl(hh, 24)
		end

		local ldexp do
			if (jit) then
				function ldexp(m, e)
					return m * shl(1, e)
				end
			else
				ldexp = math.ldexp
			end
		end

		deserials = {
			[TYPE_NIL] = function()
				return nil, 0
			end,
			[TYPE_TRUE] = function()
				return true, 0
			end,
			[TYPE_FALSE] = function()
				return false, 0
			end,
			[TYPE_BYTE] = function(buf, idx)
				return byte(buf, idx), 1
			end,
			[TYPE_SHORT] = function(buf, idx)
				local ll, lh = byte(buf, idx, idx + 1)
				return ll + shl(lh, 8), 2
			end,
			[TYPE_INT] = function(buf, idx)
				local n = b2dw(byte(buf, idx, idx + 3))
				return n < 0 and 0x100000000 + n or n, 4
			end,
			[TYPE_LONG] = function(buf, idx)
				return 0
			end,
			[TYPE_NUM] = IEEE754 and function(buf, idx)
				local ll, m, e = byte(buf, idx, idx + 2)
				m, e = b2dw(ll, m, e, 0), byte(buf, idx + 3, idx + 3)
				return ldexp(m * UNPRECISION, e), 4
			end or function(buf, idx)
				local ll, lh, hl = byte(buf, idx + 4, idx + 6)
				return b2dw(byte(buf, idx, idx + 3)) + (ll + shl(lh, 8) + shl(hl, 16)) * UNPRECISION, 7
			end,
			[TYPE_NBYTE] = function(buf, idx)
				return -byte(buf, idx), 1
			end,
			[TYPE_NSHORT] = function(buf, idx)
				local ll, lh = byte(buf, idx, idx + 1)
				return -(ll + shl(lh, 8)), 2
			end,
			[TYPE_NINT] = function(buf, idx)
				local n = b2dw(byte(buf, idx, idx + 3))
				return -(n < 0 and (0x100000000 + n) or n), 4
			end,
			[TYPE_NLONG] = function(buf, idx)
				return -0
			end,
			[TYPE_NNUM] = IEEE754 and function(buf, idx)
				local ll, m, e = byte(buf, idx, idx + 2)
				m, e = b2dw(ll, m, e, 0), byte(buf, idx + 3, idx + 3)
				return -ldexp(m * UNPRECISION, e), 4
			end or function(buf, idx)
				local ll, lh, hl = byte(buf, idx + 4, idx + 6)
				return -(b2dw(byte(buf, idx, idx + 3)) + (ll + shl(lh, 8) + shl(hl, 16)) * UNPRECISION), 7
			end,
			[TYPE_STR] = SZT and function(buf, idx)
				local nul = find(buf, '\0', idx, true)
				return sub(buf, idx, nul - 1), nul - idx + 1
			end or function(buf, idx)
				local len = b2dw(byte(buf, idx, idx + 3)) + 4
				return sub(buf, idx + 4, idx + len - 1), len
			end,
			[TYPE_APART] = function(buf, idx)
				local st = idx
				local out, l, tt = {}, 1
				::retry::
				tt, idx = byte(buf, idx), idx + 1
				if (tt and tt ~= 255) then
					local fn = deserials[tt]
					if (fn) then
						local dat, len = fn(buf, idx)
						out[l], l = dat, l + 1
						idx = idx + len
					end

					goto retry
				end

				return out, idx - st
			end,
			[TYPE_HPART] = function(buf, idx)
				local st = idx
				local out, tt = {}
				::retry::
				tt, idx = byte(buf, idx), idx + 1
				if (tt and tt ~= 255) then
					local fn = deserials[tt]
					if (fn) then
						local k, len = fn(buf, idx)
						idx = idx + len

						tt = byte(buf, idx)
						fn, idx = deserials[tt], idx + 1
						if (fn) then
							out[k], len = fn(buf, idx)
							idx = idx + len
							goto retry
						end
					end
				end

				return out, idx - st
			end,
			[TYPE_TABLE] = function(buf, idx)
				local st = idx
				local out, tt = {}

				tt, idx = byte(buf, idx), idx + 1
				if (tt == 12) then
					local l = 1
					::retry::
					tt, idx = byte(buf, idx), idx + 1
					if (tt and tt ~= 255) then
						local fn = deserials[tt]
						if (fn) then
							local dat, len = fn(buf, idx)
							out[l], l = dat, l + 1
							idx = idx + len
						end

						goto retry
					end
				end

				tt, idx = byte(buf, idx), idx + 1
				if (tt == 13) then
					::retry::
					tt, idx = byte(buf, idx), idx + 1
					if (tt and tt ~= 255) then
						local fn = deserials[tt]
						if (fn) then
							local k, len = fn(buf, idx)
							idx = idx + len

							tt = byte(buf, idx)
							fn, idx = deserials[tt], idx + 1
							if (fn) then
								out[k], len = fn(buf, idx)
								idx = idx + len
								goto retry
							end
						end
					end
				end

				return out, idx - st
			end
		}
	end

	function deserial(buf)
		local fn = deserials[byte(buf)]
		if (fn) then
			return (fn(buf, 2))
		end
	end
end

return {
	serial = serial,
	deserial = deserial,
	serialize = serial,
	deserialize = deserial,
	encode = serial,
	decode = deserial
}