local nop = function()end

local gc = collectgarbage
local clock = os.clock
local function benchmark(name, func, times, rep)
	local res, sum = {}, 0

	gc "stop"
	for i = 1, rep do
		local start = clock()

		for i = 1, times do
			func(i)
		end

		local t = clock() - start
		res[i], sum = t, sum + t
		gc()
	end
	gc "restart"

	local med = rep % 2 == 0 and (res[rep * .5] + res[(rep * .5) + 1]) * .5 or res[math.ceil(rep * .5)]
	print(("%s:\n\tsum: %f\n\tavg: %f\n\tmed: %f\n"):format(name, sum, sum / rep, med))
end

local times, reps = 1e5, 1e1
local tab = {1, -1, 512, -512, 2 ^ 32 - 1, -(2 ^ 32 - 1), 1.63, -1.63, true, false, "Hello world!", {1, 2, 3}, {["2"] = 3, ["3"] = 4}}

local out

local yads = require "yads"
benchmark("yads serial", function(i)
	out = yads.serial(tab)
end, times, reps)

print("Output size:", #out)

benchmark("yads de/serial", function(i)
	out = yads.deserial(yads.serial(tab))
end, times, reps)

local von = require "von.von"
benchmark("von serial", function()
	out = von.serialize(tab)
end, times, reps)

print("Output size:", #out)

benchmark("von de/serial", function()
	out = von.deserialize(von.serialize(tab))
end, times, reps)

local json = require "json.json"
benchmark("json serial", function()
	out = json.encode(tab)
end, times, reps)

print("Output size:", #out)

benchmark("json de/serial", function()
	out = json.decode(json.encode(tab))
end, times, reps)

local pon = require "pon"
benchmark("pon serial", function()
	out = pon.encode(tab)
end, times, reps)

print("Output size:", #out)

benchmark("pon de/serial", function()
	out = pon.decode(pon.encode(tab))
end, times, reps)