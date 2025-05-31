return @native @checked function(self: any): {any}
	return {
		init_global_replacements = @native function(): ()
			local hook; hook = self.hookfunction(getfenv, @native function(param1: number? | ((...any) -> (...any))?): {any}
				if not self.checkcaller() then
					if type(param1) == "number" then
						if param1 == 0 then
							return self.isolated_lua_state[coroutine.running()];
						else
							param1 += 3;
						end;
					elseif not param1 then
						param1 = 4;
					end;
					local env: {any} = hook(param1);
					if rawget(env, "_G") == _G then
						local is_it_safe: {any} = hook(4);
						if rawget(is_it_safe, "_G") == _G then
							return self.isolated_lua_state[coroutine.running()]; -- this is an issue, for potential detection
						end
						return is_it_safe;
					end;
					return env;
				end;
				return hook(param1);
			end);

			local hook; hook = self.hookfunction(setfenv, @native function(param1: number? | ((...any) -> (...any))?, param2: any): any
				if not self.checkcaller() then
					local type_str: string = type(param1);
					if type_str == "number" then
						if param1 == 0 and type(param2) == "table" then
							self.isolated_lua_state[coroutine.running()] = param2;
							return param2;
						else
							param1 += 3;
						end;
					end;
					if type_str == "function" and type(param2) == "table" and table.find(self.c_functions, param1) then
						return hook(typeof, {});
					end;
					return hook(param1, param2);
				end;
				return hook(param1, param2);
			end);
			local hook; hook = self.hookfunction(require, @native function(param1: any): (...any)
				print("hooked require", param1)
				return;
			end)
			local hook; hook = self.hookfunction(debug.info, @native function(param1: any, param2: any, param3: any): (...any)
				if not self.checkcaller() then
					if type(param1) == "number" and param1 ~= 0 then
						param1 += 3;
					end;
					if type(param2) == "number" and param2 ~= 0 then
						param2 += 3;
					end;
					local result: {any} = {hook(param1, param2, param3)};
					if type(param2) ~= "string" then
						param2 = param3;
					end;
					if type(param2) == "string" then
						if table.find(self.c_functions, param1) then
							local exists: {any} = self.c_func_data[param1];
							local source: number? = string.find(param2, "s");
							if source then
								result[source] = (exists and exists[0x01]) or "[C]";
							end;
							local line: number? = string.find(param2, "l");
							if line then
								result[line] = (exists and exists[0x02]) or -1;
							end;
							local name: number? = string.find(param2, "n");
							if name then
								result[name] = (exists and exists[0x03]) or "";
							end;
							local numps: number? = string.find(param2, "a");
							if numps then
								result[numps] = (exists and exists[0x04]) or 0;
								result[numps + 1] = (exists and exists[0x05]) or true;
							end;
						end;
						local func_pos: number? = string.find(param2, "f");
						local func: ((...any) -> (...any))? = func_pos and result[func_pos];
						if func and self.illegal_debug_fetch[func] then
							result[func_pos :: number] = self.illegal_debug_fetch[func];
						end;
					end;
					return unpack(result);
				end;
				return hook(param1, param2, param3);
			end);
			
			local hook; hook = self.hookfunction(coroutine.wrap, @native function(param1: any): (...any)
				if not self.checkcaller() and type(param1) == "function" then
					local new_lua_state: thread = coroutine.create(param1);
					self.lua_state_data[new_lua_state] = self.lua_state_data[coroutine.running()];
					self.isolated_lua_state[new_lua_state] = self.isolated_lua_state[coroutine.running()];
					local new_c_func = @native function(...: any): any
						return coroutine.resume(new_lua_state);
					end;
					table.insert(self.c_functions, new_c_func);
					self.insert_gc(new_c_func);
					self.insert_gc(new_lua_state);
					return new_c_func;
				end;
				return hook(param1);
			end);
			
			local hook; hook = self.hookfunction(coroutine.create, @native function(param1: any): (...any)
				if not self.checkcaller() and type(param1) == "function" then
					local new_lua_state: thread = coroutine.create(param1);
					self.lua_state_data[new_lua_state] = self.lua_state_data[coroutine.running()];
					self.isolated_lua_state[new_lua_state] = self.isolated_lua_state[coroutine.running()];
					self.insert_gc(new_lua_state);
					return new_lua_state;
				end;
				return hook(param1);
			end);
			
			local hook; hook = self.hookfunction(task.spawn, @native function(param1: any): (...any)
				if not self.checkcaller() and type(param1) == "function" then
					local new_lua_state: thread = coroutine.create(param1);
					self.lua_state_data[new_lua_state] = self.lua_state_data[coroutine.running()];
					self.isolated_lua_state[new_lua_state] = self.isolated_lua_state[coroutine.running()];
					self.insert_gc(new_lua_state);
					return task.spawn(new_lua_state);
				end;
				return hook(param1);
			end);
			
			local hook; hook = self.hookfunction(task.delay, @native function(param1: any, param2: any): (...any)
				if not self.checkcaller() and type(param1) == "number" and type(param2) == "function" then
					local new_lua_state: thread = coroutine.create(param2);
					self.lua_state_data[new_lua_state] = self.lua_state_data[coroutine.running()];
					self.isolated_lua_state[new_lua_state] = self.isolated_lua_state[coroutine.running()];
					self.insert_gc(new_lua_state);
					return task.delay(param1, new_lua_state);
				end;
				return hook(param1);
			end);
			
			local spawn_replacement = @native function(param1: any): ()
				if not self.checkcaller() and (type(param1) == "function" or type(param1) == "table" or typeof(param1) == "userdata") then
					local la_func = (type(param1) == "function" and param1) or (self.getrawmetatable(param1) and self.getrawmetatable(param1).__call);
					if la_func then
						local new_lua_state: thread = coroutine.create(la_func);
						self.lua_state_data[new_lua_state] = self.lua_state_data[coroutine.running()];
						self.isolated_lua_state[new_lua_state] = self.isolated_lua_state[coroutine.running()];
						self.insert_gc(new_lua_state);
						task.spawn(new_lua_state);
					end;
				end;
				return spawn(param1);
			end;
			
			local delay_replacement = @native function(param1: any, param2: any): ()
				if not self.checkcaller() and type(param1) == "number" and (type(param1) == "function" or type(param1) == "table" or typeof(param1) == "userdata") then
					local la_func = (type(param1) == "function" and param1) or (self.getrawmetatable(param1) and self.getrawmetatable(param1).__call);
					if la_func then
						local new_lua_state: thread = coroutine.create(la_func);
						self.lua_state_data[new_lua_state] = self.lua_state_data[coroutine.running()];
						self.isolated_lua_state[new_lua_state] = self.isolated_lua_state[coroutine.running()];
						self.insert_gc(new_lua_state);
						task.delay(param1, new_lua_state);
					end;
				end;
				return delay(param1, param2);
			end;
			
			self.hookfunction(spawn, spawn_replacement);
			self.hookfunction(Spawn, spawn_replacement);
			self.hookfunction(delay, delay_replacement);
			self.hookfunction(Delay, delay_replacement);
			
			local hook; hook = self.hookfunction(setmetatable, @native function(param1: any, param2: any): (...any)
				if not self.checkcaller() then
					local resultus: any = hook(param1, param2);
					self.raw_metatable[param1] = param2;
					return resultus;
				end;
				return hook(param1, param2);
			end);
			
			local hook; hook = self.hookfunction(newproxy, @native function(param1: any): (...any)
				if not self.checkcaller() and param1 then
					local resultus: any = hook(param1);
					self.raw_metatable[resultus] = getmetatable(resultus);
					self.insert_gc(self.raw_metatable[resultus]);
					self.insert_gc(resultus);
					return resultus;
				end;
				return hook(param1);
			end);
		end;
	}
end;