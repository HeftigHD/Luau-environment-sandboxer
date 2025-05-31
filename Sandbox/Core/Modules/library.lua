--!native
--!strict
return function(self: any): any
	local game: DataModel = game;
	local namecall_leax = @native function(object: any): any
		local _: boolean, namecall: any = xpcall(@native function(): ()
			(object :: any):__namecall();
		end, @native function()
			return debug.info(2, "f");
		end);
		return namecall;
	end;
	local first: any = namecall_leax(OverlapParams.new());
	local second: any = namecall_leax(Color3.new());
	namecall_leax = nil :: never;
	return {
		getinstancefromstate = @native function(lua_state: thread): Instance?
			return self.lua_state_data[lua_state] and self.lua_state_data[lua_state].script;
		end,
		getstates = @native function(): {thread}
			local states: {thread} = {};
			local count: number = 0;
			for i: thread in self.lua_state_data do
				count += 1;
				states[count] = i;
			end;
			return states;
		end,
		getstateenv = @native function(lua_state: thread): {any}
			return self.lua_state_data[lua_state].script;
		end,
		getscripts = @native function(): {Instance}
			local instances: {Instance} = {};
			local count: number = 0;
			for v: any in self.inverse_weak_object_alias do
				if typeof(v) == "Instance" and v.IsA(v, "BaseScript") then
					count += 1;
					instances[count] = v :: Instance;
				end;
			end;
			return instances;
		end,
		getinstances = @native function(): {Instance}
			local instances: {Instance} = {};
			local count: number = 0;
			for v: Instance in self.inverse_weak_object_alias do
				if typeof(v) == "Instance" then
					count += 1;
					instances[count] = v;
				end;
			end;
			return instances;
		end,
		getnilinstances = @native function(): {Instance}
			local instances: {Instance} = {};
			local count: number = 0;
			for v: Instance in self.inverse_weak_object_alias do
				if typeof(v) == "Instance" and not v.Parent then
					count += 1;
					instances[count] = v;
				end;
			end;
			return instances;
		end,
		firesignal = @native function(connection: RBXScriptConnection): ()
			for _: number, v: any in self.getconnections(connection) do
				v.Fire(v);
			end;
		end,
		getconnections = @native function(connection: RBXScriptConnection): {any}
			for i: RBXScriptConnection, v: any in self.connections do
				if i == connection then
					return v;
				end;
			end;
			local new_table: {any} = {};
			self.connections[connection] = new_table;
			return new_table;
		end,
		isreferenced = @native function(object: any): boolean
			return table.find(self.gc, object) ~= nil;
		end,
		getgc = @native function(smt: boolean): {any}
			return self.gc;
		end,
		getrawmetatable = @native function(obj: any): any
			local type_str: string = typeof(obj);
			return (type_str == "Instance" and self.methods[type_str]) or self.raw_metatable[obj];
		end,
		setrawmetatable = @native function(obj: any, newsilly: {any}): ()
			local raw_metatable: any = self.getrawmetatable(obj);
			for i: any, v: any in newsilly do
				raw_metatable[i] = v;
			end;
			return raw_metatable;
		end,
		getrenv = @native function(): {any}
			return self.sandboxed_ENV;
		end,
		getsenv = @native function(obj: Instance): {any}?
			local state_data: any? = self.lua_state_data[self.script_closures_list[obj]];
			return state_data and state_data.env;
		end,
		getscriptclosure = @native function(obj: Instance): any
			return self.script_closures_list[obj];
		end,
		hookfunction = @native function(func: (...any) -> (...any), callback: (...any) -> (...any)): ((...any) -> (...any))?
			local real_func: ((...any) -> (...any))? = self.hookable_funcs[func];
			local hook: ((...any) -> (...any))? = self.inverse_hookable_funcs[real_func];
			if hook then
				self.inverse_hookable_funcs[real_func] = callback;
			end;
			return func;
		end,
		hookmetamethod = @native function(obj: Instance, method: string, callback: (...any) -> (...any)): any
			local type_str: string = typeof(obj);
			local old_func: (...any) -> (...any) = (self.methods[type_str] and self.methods[type_str][method]);
			self.methods[type_str][method] = @native function(...: any): (...any)
				local args: any = self.decode_sandbox({...});
				if obj == args[0x01] or args[0x01].IsDescendantOf(args[0x01], obj) then
					return callback(unpack(args));
				end;
				return old_func(...);
			end;
			return old_func;
		end,
		getnamecallmethod = @native function(): string
			local success: boolean, error_message: string = pcall(first);
			local namecall_method: string? | boolean? = not success and string.match(error_message, "^(.+) is not a valid member of %w+$");
			if not namecall_method then
				local success: boolean, error_message: string = pcall(second);
				namecall_method = not success and string.match(error_message, "^(.+) is not a valid member of %w+$");
			end;
			return namecall_method :: string? or "";
		end,
		newcclosure = @native function(func: any): (...any) -> (...any)
			return coroutine.wrap(@native function(...: any): (...any)
				local params: any = {...};
				while 1 do
					local results: {any} = {pcall(func, unpack(params))};
					params = nil :: never;
					if not results[0x01] then
						-- well the error kills the coroutine, which is bad
						params = {coroutine.wrap(error)(results[0x02], 0)};
					else
						params = {coroutine.yield(select(2, unpack(results)))};
					end;
				end;
			end);
		end,
		isreadonly = table.isfrozen;
		setreadonly = @native function(guh: {any}, leax: boolean): ()
			if leax then
				table.freeze(guh);
			else
				warn("no supporte for unfreezing table sad day");
			end;
		end,
		islclosure = @native function(func: (...any) -> (...any)): ()
			return debug.info(func, "s") ~= "[C]";
		end,
		iscclosure = @native function(func: (...any) -> (...any)): ()
			return debug.info(func, "s") == "[C]";
		end,
		getthreadidentity = @native function(): ()
			return 2;
		end,
		checkcaller = @native function(): ()
			return self.kernel_thread == coroutine.running();
		end,
		getcallingscript = @native function(): any
			return self.lua_state_data[coroutine.running()].script;
		end,
	}
end;