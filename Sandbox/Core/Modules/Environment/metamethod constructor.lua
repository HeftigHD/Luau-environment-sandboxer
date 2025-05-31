return @native function(self: any): {any}
	return {
		methods = {},
		construct_method = @native function(obj: any): ()
			local real_methods: {any} = self.real_methods[typeof(obj)] or {};
			self.real_methods[typeof(obj)] = real_methods;
			xpcall(function()
				return obj.___;
			end, function()
				real_methods.__index = debug.info(2, "f");
			end);
			xpcall(function()
				obj.___ = newproxy();
			end, function()
				real_methods.__newindex = debug.info(2, "f");
			end);
			xpcall(function()
				return tostring(game.CoreGui);
			end, function()
				real_methods.__tostring = debug.info(2, "f");
			end);
			xpcall(function()
				return obj:____();	
			end, function()
				real_methods.__namecall = debug.info(2, "f");
			end);
			xpcall(function()
				return obj.."hi";	
			end, function()
				real_methods.__concat = debug.info(2, "f");
			end);
			xpcall(function()
				return -obj;	
			end, function()
				real_methods.__unm = debug.info(2, "f");
			end);
			xpcall(function()
				return obj + 1;	
			end, function()
				real_methods.__add = debug.info(2, "f");
			end);
			xpcall(function()
				return obj - 1;	
			end, function()
				real_methods.__sub = debug.info(2, "f");
			end);
			xpcall(function()
				return obj * 1;	
			end, function()
				real_methods.__mul = debug.info(2, "f");
			end);
			xpcall(function()
				return obj / 1;	
			end, function()
				real_methods.__div = debug.info(2, "f");
			end);
			xpcall(function()
				return obj // 1;	
			end, function()
				real_methods.__idiv = debug.info(2, "f");
			end);
			xpcall(function()
				return obj % 1;	
			end, function()
				real_methods.__mod = debug.info(2, "f");
			end);
			xpcall(function()
				return obj <= 1;	
			end, function()
				real_methods.__le = debug.info(2, "f");
			end);
			xpcall(function()
				return obj < 1;	
			end, function()
				real_methods.__lt = debug.info(2, "f");
			end);
			xpcall(function()
				return #obj;
			end, function()
				real_methods.__len = debug.info(2, "f");
			end);
			xpcall(function()
				return obj();
			end, function()
				real_methods.__call = debug.info(2, "f");
			end);
			xpcall(function()
				for _, v in obj do

				end
			end, function()
				real_methods.__iter = debug.info(2, "f");
			end);
			local illegal_debug_fetch: {[(...any) -> (...any)]: (...any) -> (...any)} = self.illegal_debug_fetch;
			local encode_sandbox: ({any}) -> ({any}) = self.encode_sandbox;
			local decode_sandbox: ({any}) -> ({any}) = self.decode_sandbox;
			local inverse_hookable_funcs: {[(...any) -> (...any)]: (...any) -> (...any)} = self.inverse_hookable_funcs;
			local hookable_funcs: {[(...any) -> (...any)]: (...any) -> (...any)} = self.hookable_funcs;
			local c_func_data: {[(...any) -> (...any)]: {any}} = self.c_func_data;
			local c_functions: {(...any) -> (...any)} = self.c_functions;
			local weak_object_alias: {[any]: Instance} = self.weak_object_alias;
			local alternative_methods: any = self.alternative_methods;
			local insert_gc: (any) -> () = self.insert_gc;
			local weak_object_alias_data: {[any]: string} = self.weak_object_alias_data;
			local getnamecallmethod: () -> (string) = self.getnamecallmethod;
			local new_methods: {any} = {
				__index = @native function(...: any): any
					local result: any = unpack(encode_sandbox({real_methods.__index(unpack(decode_sandbox({...})))}));
					if type(result) == "function" and debug.info(result, "s") == "[C]" then
						local exists_already: ((...any) -> (...any))? = illegal_debug_fetch[result];
						if exists_already then
							return exists_already;
						end;
						local la_func; la_func = @native function(...: any): any
							return unpack(encode_sandbox({inverse_hookable_funcs[la_func](unpack(decode_sandbox({...})))}));
						end;
						hookable_funcs[result] = la_func;
						inverse_hookable_funcs[la_func] = result;
						insert_gc(la_func);
						c_func_data[la_func] = {debug.info(result, "slna")};
						illegal_debug_fetch[result] = la_func;
						table.insert(c_functions, la_func);
						return la_func;
					end;
					return unpack(encode_sandbox({real_methods.__index(unpack(decode_sandbox({...})))}));
				end,
				__newindex = @native function(...: any): ()
					real_methods.__newindex(unpack(decode_sandbox({...})));
				end,
				__namecall = @native function(...: any): (...any)
					local data: {string} = weak_object_alias_data[...];
					if data then
						local alternative_method: {any} = alternative_methods[data[0x01]];
						local alternative_func: ((...any) -> (...any))? = alternative_method and alternative_method[string.lower(getnamecallmethod())];
						local class: string = data[0x02];
						if class == "BindableEvent" or class == "BindableFunction" then
							return real_methods.__namecall(unpack(decode_sandbox({...})));
						end;
						if alternative_func then
							return unpack(encode_sandbox({alternative_func(unpack(decode_sandbox({...})))}))
						end;
					end;
					return unpack(encode_sandbox({real_methods.__namecall(unpack(decode_sandbox({...})))}));
				end,
				__tostring = @native function(...: any): any
					return unpack(encode_sandbox({real_methods.__tostring(unpack(decode_sandbox({...})))}));
				end,
				__concat = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__concat(unpack(decode_sandbox({...})))}));
				end,
				__unm = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__unm(unpack(decode_sandbox({...})))}));
				end,
				__add = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__add(unpack(decode_sandbox({...})))}));
				end,
				__sub = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__sub(unpack(decode_sandbox({...})))}));
				end,
				__mul = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__mul(unpack(decode_sandbox({...})))}));
				end,
				__div = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__div(unpack(decode_sandbox({...})))}));
				end,
				__idiv = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__idiv(unpack(decode_sandbox({...})))}));
				end,
				__mod = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__mod(unpack(decode_sandbox({...})))}));
				end,
				__pow = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__pow(unpack(decode_sandbox({...})))}));
				end,
				__le = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__le(unpack(decode_sandbox({...})))}));
				end,
				__lt = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__lt(unpack(decode_sandbox({...})))}));
				end,
				__call = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__call(unpack(decode_sandbox({...})))}));
				end,
				__len = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__len(unpack(decode_sandbox({...})))}));
				end,
				__iter = @native function(...: any): ()
					return unpack(encode_sandbox({real_methods.__iter(unpack(decode_sandbox({...})))}));
				end,
				__metatable = getmetatable(obj),
			};
			for i: any, v: any in real_methods do
				illegal_debug_fetch[v] = new_methods[i];
				table.insert(self.c_functions, new_methods[i]);
			end;
			self.methods[typeof(obj)] = new_methods;
			return new_methods;
		end,
	}
end;