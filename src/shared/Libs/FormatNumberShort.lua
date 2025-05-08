
local FormatShort = {}

local function FormatShort(n: number): string
	return n >= 1e6 and string.format("%.1fM", n / 1e6)
		or n >= 1e3 and string.format("%.1fK", n / 1e3)
		or tostring(n)
end

return FormatShort