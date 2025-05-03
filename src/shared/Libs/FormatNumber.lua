--[=[
	Version 2.1.0
	This is intended for Roblox ModuleScripts
	BSD 2-Clause Licence
	Copyright ©, 2020 - Blockzez (devforum.roblox.com/u/Blockzez and github.com/Blockzez)
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	1. Redistributions of source code must retain the above copyright notice, this
	   list of conditions and the following disclaimer.
	
	2. Redistributions in binary form must reproduce the above copyright notice,
	   this list of conditions and the following disclaimer in the documentation
	   and/or other materials provided with the distribution.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]=]--
local f = { };

local function to_literal(str)
	return "'" .. str .. "'";
end;

function f.AbbreviationToCLDR(abbreviations)
	local ret = { };
	for _, p in ipairs(abbreviations) do
		for zcount = 1, 3 do
			if p == '' or not p then
				table.insert(ret, '0');
			else
				table.insert(ret, ('0'):rep(zcount) .. p:gsub('¤', "'¤'"):gsub('‰', "'‰'"):gsub("'", "''"):gsub("[.;,#%%]", to_literal));
			end;
		end;
	end;
	return ret;
end;

-- Berezaa's suffix
local defaultCompactPattern = f.AbbreviationToCLDR {
	-- https://minershaven.fandom.com/wiki/Cash_Suffixes
	"k", "M", "B", "T", "qd", "Qn", "sx", "Sp", "O", "N", "de", "Ud", "DD", "tdD",
	"qdD", "QnD", "sxD", "SpD", "OcD", "NvD", "Vgn", "UVg", "DVg", "TVg", "qtV",
	"QnV", "SeV", "SPG", "OVG", "NVG", "TGN", "UTG", "DTG", "tsTG", "qtTG", "QnTG",
	"ssTG", "SpTG", "OcTG", "NoTG", "QdDR", "uQDR", "dQDR", "tQDR", "qdQDR", "QnQDR",
	"sxQDR", "SpQDR", "OQDDr", "NQDDr", "qQGNT", "uQGNT", "dQGNT", "tQGNT", "qdQGNT",
	"QnQGNT", "sxQGNT", "SpQGNT", "OQQGNT", "NQQGNT", "SXGNTL", "USXGNTL", "DSXGNTL",
	"TSXGNTL", "QTSXGNTL", "QNSXGNTL", "SXSXGNTL", "SPSXGNTL", "OSXGNTL", "NVSXGNTL",
	"SPTGNTL", "USPTGNTL", "DSPTGNTL", "TSPTGNTL", "QTSPTGNTL", "QNSPTGNTL", "SXSPTGNTL",
	"SPSPTGNTL", "OSPTGNTL", "NVSPTGNTL", "OTGNTL", "UOTGNTL", "DOTGNTL", "TOTGNTL", "QTOTGNTL",
	"QNOTGNTL", "SXOTGNTL", "SPOTGNTL", "OTOTGNTL", "NVOTGNTL", "NONGNTL", "UNONGNTL", "DNONGNTL",
	"TNONGNTL", "QTNONGNTL", "QNNONGNTL", "SXNONGNTL", "SPNONGNTL", "OTNONGNTL", "NONONGNTL", "CENT",
};

local sym_tables = { '¤', '%', '-', '+', 'E', '', '‰', '*' };
local function generatecompact(ptn)
	local org_ptn = ptn;
	if type(ptn) ~= "string" then
		error("Compact patterns must be a table of string", 4);
	end;
	local ret, size, i0 = { }, 0, 1;
	while i0 do
		local i1 = math.min(ptn:find("[0-9@#.,+%%;*'-]", i0) or #ptn + 1, ptn:find('¤', i0) or #ptn + 1, ptn:find('‰', i0) or #ptn + 1);
		local i2 = i1 + ((ptn:sub(i1, i1 + 1) == '¤' or ptn:sub(i1, i1 + 1) == '‰') and 1 or 0);
		local chr = ptn:sub(i1, i2);
		-- Literal charaters
		if chr == "'" then
			local r = ptn:sub(i0, i1 - 1);
			i0 = ptn:find("'", i1 + 1);
			if i0 == i1 + 1 then
				r = r .. "'";
			elseif i0 then
				r = r .. ptn:sub(i1 + 1, i0 - 1);
			else
				error("'" .. org_ptn .. "' is not a valid pattern", 2);
			end;
			table.insert(ret, r);
			i0 = i0 + 1;
		elseif chr:match('[1-9]') then
			error("The rounding (1-9) pattern isn't supported", 4);
		elseif chr == '¤' or chr == '‰' or chr:match('[%%*+%-]') then
			error("The '" .. chr .. "' pattern isn't supported", 4);
		elseif chr == '0' then
			table.insert(ret, ptn:sub(i0, i1 - 1));
			table.insert(ret, 0);
			
			i0 = ptn:find('[^0]', i1);
			local int = ptn:sub(i1, (i0 or #ptn + 1) - 1);
			
			if (not int:match('^0+$')) or size > 0 then
				error("'" .. org_ptn .. "' is not a valid pattern", 4);
			end;
			
			size = #int;
		else
			table.insert(ret, ptn:sub(i0));
			i0 = nil;
		end;
	end;
	
	return ret, size;
end;

-- From International, modified
local valid_value_property =
{
	groupSymbol = "f/str",
	decimalSymbol = "f/str",
	compactPattern = "f/table",
	
	style = { "decimal", "currency", "percent" },
	useGrouping = { "min2", "always", "never" },
	minimumIntegerDigits = "f/1..",
	maximumIntegerDigits = "f/minimumIntegerDigits..inf",
	minimumFractionDigits = "f/0..",
	maximumFractionDigits = "f/minimumFractionDigits..inf",
	minimumSignificantDigits = "f/1..",
	maximumSignificantDigits = "f/minimumSignificantDigits..inf",
	currency = "f/str",
	rounding = { "halfUp", "halfEven", "halfDown", "up", "down" },
};

local function check_property(tbl_out, tbl_to_check, property, default)
	local check_values = valid_value_property[property];
	if not check_values then
		return;
	end;
	
	local value = rawget(tbl_to_check, property);
	local valid = false;
	if type(check_values) == "table" then
		valid = table.find(check_values, value);
	elseif check_values == 'f/bool' then
		valid = (type(value) == "boolean");
	elseif check_values == 'f/str' then
		valid = (type(value) == "string");
	elseif check_values == 'f/table' then
		valid = (type(value) == "table");
	elseif not check_values then
		valid = true;
	elseif type(value) == "number" and (value % 1 == 0) or (value == math.huge) then
		local min, max = check_values:match("f/(%w*)%.%.(%w*)");
		valid = (value >= (tbl_out[min] or tonumber(min) or 0)) and ((max == '' and value ~= math.huge) or (value <= tonumber(max)));
	end;
	if valid then
		tbl_out[property] = value;
		return;
	elseif value == nil then
		if type(default) == "string" and (default:sub(1, 7) == 'error: ') then
			error(default:sub(8), 4);
		end;
		tbl_out[property] = default;
		return;
	end;
	error(property .. " value is out of range.", 4);
end;
local function check_options(ttype, options)
	local ret = { };
	if type(options) ~= "table" then
		options = { };
	end;
	check_property(ret, options, 'groupSymbol', ',');
	check_property(ret, options, 'decimalSymbol', '.');
	check_property(ret, options, 'useGrouping', ttype == "compact" and "min2" or "always");
	check_property(ret, options, 'style', 'decimal');
	if ttype == "compact" then
		check_property(ret, options, 'compactPattern', defaultCompactPattern);
	end;
	
	if ret.style == "currency" then
		check_property(ret, options, 'currency', 'error: Currency is required with currency style');
	end;
	
	check_property(ret, options, 'rounding', ttype == "compact" and "down" or 'halfEven');
	ret.isSignificant = not not (rawget(options, 'minimumSignificantDigits') or rawget(options, 'maximumSignificantDigits'));
	if ret.isSignificant then
		check_property(ret, options, 'minimumSignificantDigits', 1);
		check_property(ret, options, 'maximumSignificantDigits');
	else
		check_property(ret, options, 'minimumIntegerDigits', 1);
		check_property(ret, options, 'maximumIntegerDigits');
		check_property(ret, options, 'minimumFractionDigits');
		check_property(ret, options, 'maximumFractionDigits');
		
		if not (ret.minimumFractionDigits or ret.maximumFractionDigits) then
			if ret.style == "percent" then
				ret.minimumFractionDigits = 0;
				ret.maximumFractionDigits = 0;
			elseif ttype ~= "compact" then
				ret.minimumFractionDigits = 0;
				ret.maximumFractionDigits = 3;
			end;
		end;
	end;
	return ret;
end;

local function quantize(val, exp, rounding)
	local d, e = ('0' .. val):gsub('%.', ''), (val:find('%.') or (#val + 1)) + 1;
	local pos = e + exp;
	if pos > #d then
		return val:match("^(%d*)%.?(%d*)$");
	end;
	d = d:split('');
	local add = rounding == 'up';
	if rounding ~= "up" and rounding ~= "down" then
		add = d[pos]:match(((rounding == "halfEven" and (d[pos - 1] or '0'):match('[02468]')) or rounding == "halfDown") and '[6-9]' or '[5-9]');
	end;
	for p = pos, #d do
		d[p] = 0
	end;
	if add then
		repeat
			if d[pos] == 10 then
				d[pos] = 0;
			end;
			pos = pos - 1;
			d[pos] = tonumber(d[pos]) + 1;
		until d[pos] ~= 10;
	end;
	return table.concat(d, '', 1, e - 1), table.concat(d, '', e);
end;
local function scale(val, exp)
	val = ('0'):rep(-exp) .. val .. ('0'):rep(exp);
	local unscaled = (val:gsub("[.,]", ''));
	local len = #val;
	local dpos = (val:find("[.,]") or (len + 1)) + exp;
	return unscaled:sub(1, dpos - 1) .. '.' .. unscaled:sub(dpos);
end;
local function compact(val, size)
	val = (val:gsub('%.', ''));
	return val:sub(1, size) .. '.' .. val:sub(size + 1);
end;
local function raw_format(val, minintg, maxintg, minfrac, maxfrac, rounding)
	local intg, frac;
	if maxfrac and maxfrac ~= math.huge then
		intg, frac = quantize(val, maxfrac, rounding);
	else
		intg, frac = val:match("^(%d*)%.?(%d*)$");
	end;
	intg = intg:gsub('^0+', '');
	frac = frac:gsub('0+$', '');
	local intglen = #intg;
	local fraclen = #frac;
	if minintg and (intglen < minintg) then
		intg = ('0'):rep(minintg - intglen) .. intg;
	end;
	if minfrac and (fraclen < minfrac) then
		frac = frac .. ('0'):rep(minfrac - fraclen);
	end;
	if maxintg and (intglen > maxintg) then
		intg = intg:sub(-maxintg);
	end;
	if frac == '' then
		return intg;
	end;
	return intg .. '.' .. frac;
end;
local function raw_format_sig(val, min, max, rounding)
	local intg, frac = val:match("^(%d*)%.?(%d*)$");
	intg, frac = intg:gsub('^0+', ''), frac:gsub('0+$', '');
	intg = intg == '' and '0' or intg;
	if max and max ~= math.huge then
		val = intg .. '.' .. frac;
		intg, frac = quantize(val, max - ((val:find('%.') or (#val + 1)) - 1) + #val:gsub('%.', ''):match("^0*"), rounding);
		intg, frac = intg:gsub('^0+', ''), frac:gsub('0+$', '');
		intg = intg == '' and '0' or intg;
	end;
	if min then
		min = math.max(min - #val:gsub('%.%d*$', ''), 0);
		if #frac < min then
			frac = frac .. ('0'):rep(min - #frac);
		end;
	end;
	if frac == '' then
		return intg;
	end;
	return intg .. '.' .. frac;
end;
local function parse_exp(val)
	if not val:find('[eE]') then
		return val;
	end;
	local negt, val, exp = val:match('^([+%-]?)(%d*%.?%d*)[eE]([+%-]?%d+)$');
	if val then
		exp = tonumber(exp);
		if not exp then
			return nil;
		end;
		if val == '' then
			return nil;
		end;
		return negt .. scale(val, exp);
	end;
	return nil;
end;
local function num_to_str(value)
	local value_type = type(value);
	if value_type == "number" then
		value = (value % 1 == 0 and '%.0f' or '%.17f'):format(value);
	else
		value = tostring(value);
		value = parse_exp(value) or value:lower();
	end;
	return value;
end;

local function format(ttype, value, options)
	-- from International, modified
	local negt, post = value:match("^([+%-]?)(.+)$");
	local tokenized_compact;
	local curr = ((options.currency and (options.currency .. (options.currency:match("%a$") and ' ' or ''))) or '');
	if post:match("^[%d.]*$") and select(2, post:gsub('%.', '')) < 2 then
		if options.style == "percent" then
			post = scale(post, 2);
		end;
		local minfrac, maxfrac = options.minimumFractionDigits, options.maximumFractionDigits;
		if ttype == "compact" then
			post = post:gsub('^0+', '');
			local intlen = #post:gsub('%..*', '') - 3;
			local compact_val = post;
			local pattern_len = #options.compactPattern;
			if (options.compactPattern[math.min(intlen, pattern_len)] or '0') ~= '0' then
				local size;
				tokenized_compact, size = generatecompact(options.compactPattern[math.min(intlen, pattern_len)]);
				compact_val = compact(post, size + math.max(intlen - pattern_len, 0));
			-- The '0' pattern indicates no compact number available
			end;
			if not (minfrac or maxfrac) then
				maxfrac = math.max(2 - ((compact_val:find('%.') or (#compact_val + 1)) - 1) + #compact_val:gsub('%.', ''):match("^0*"), 0);
			end;
			
			local formatted_compact_val;
			if options.isSignificant then
				formatted_compact_val = raw_format_sig(compact_val, options.minimumSignificantDigits, options.maximumSignificantDigits, options.rounding);
			else
				formatted_compact_val = raw_format(compact_val, options.minimumIntegerDigits, options.maximumIntegerDigits, minfrac, maxfrac, options.rounding);
			end;
			
			-- Check if 9's are rounded through 10 via length, remove decimals
			if #formatted_compact_val:gsub("%.%d*$", ''):gsub('^0+', '') == #compact_val:gsub("%.%d*$", '') then
				post = formatted_compact_val;
			else
				intlen = intlen + 1;
				if (options.compactPattern[math.min(intlen, pattern_len)] or '0') ~= '0' then
					local size;
					tokenized_compact, size = generatecompact(options.compactPattern[math.min(intlen, pattern_len)]);
					compact_val = compact(post, size + math.max(intlen - pattern_len, 0) - 1);
				end;
				if options.isSignificant then
					post = raw_format_sig(compact_val, options.minimumSignificantDigits, options.maximumSignificantDigits, options.rounding);
				else
					post = raw_format(compact_val, options.minimumIntegerDigits, options.maximumIntegerDigits, minfrac, maxfrac, options.rounding);
				end;
			end;
		elseif options.isSignificant then
			post = raw_format_sig(post, options.minimumSignificantDigits, options.maximumSignificantDigits, options.rounding);
		else
			post = raw_format(post, options.minimumIntegerDigits, options.maximumIntegerDigits, minfrac, maxfrac, options.rounding);
		end;
	elseif (post == "inf") or (post == "infinity") then
		return curr .. (negt == '-' and '-∞' or '∞') .. (options.style == "percent" and '%' or '');
	else
		return curr .. 'NaN' .. (options.style == "percent" and '%' or '');
	end;
	negt = negt == '-';
	
	local first, intg, frac = post:match("^(%d)(%d*)%.?(%d*)$");
	if (options.useGrouping ~= "never") and (#intg > (options.useGrouping == "min2" and 3 or 2)) then
		intg = intg:reverse():gsub("%d%d%d", "%1" .. options.groupSymbol:reverse()):reverse();
	end;
	local ret = table.concat{ negt and '-' or '', curr, first, intg, frac == '' and '' or (options.decimalSymbol .. frac), (options.style == "percent" and not tokenized_compact) and '%' or '' };
	if tokenized_compact then
		local value_pos = table.find(tokenized_compact, 0);
		if value_pos then
			tokenized_compact[value_pos] = ret;
		end;
		return table.concat(tokenized_compact);
	end;
	return ret;
end;

function f.FormatStandard(...)
	if select('#', ...) == 0 then
		error("missing argument #1", 2);
	end;
	local value, options = ...;
	return format('standard', num_to_str(value), check_options('standard', options));
end;

function f.FormatCompact(...)
	if select('#', ...) == 0 then
		error("missing argument #1", 2);
	end;
	local value, options = ...;
	return format('compact', num_to_str(value), check_options('compact', options));
end;

function f.FormatStandardRange(...)
	local len = select('#', ...);
	if len < 2 then
		error("missing argument #" .. (len + 1), 2);
	end;
	local value0, value1, options = ...;
	options = check_options('standard', options);
	return ("%s–%s"):format(format('standard', num_to_str(value0), options), format('standard', num_to_str(value1), options));
end;

function f.FormatCompactRange(...)
	local len = select('#', ...);
	if len < 2 then
		error("missing argument #" .. (len + 1), 2);
	end;
	local value0, value1, options = ...;
	options = check_options('compact', options);
	return ("%s–%s"):format(format('compact', num_to_str(value0), options), format('compact', num_to_str(value1), options));
end;

return setmetatable({ }, { __metatable = "The metatable is locked", __index = f,
	__newindex = function()
		error("Attempt to modify a readonly table", 2);
	end,
});