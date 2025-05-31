-- meow
-- meow
--!strict
--!native
return function(self: any): {any}
	return {
		alternative_methods = {
			RBXScriptSignal = {
				
			},
			RBXScriptConnection = {
				connect = @native function(obj: any, func: (...any) -> (...any)): any
					local debounce: boolean = true;
					local current_lua_state_data: {any} = self.lua_state_data[coroutine.running()];
					self.thread_callstack[coroutine.running()] = func;
					self.insert_gc(func);
					local fake_connector = @native function(...: any): ()
						if debounce then
							local lua_state: thread = coroutine.create(func);
							self.insert_gc(lua_state);
							self.lua_state_data[lua_state] = current_lua_state_data;
							coroutine.resume(lua_state, unpack(self.encode_sandbox({...})));
						end;
					end;
					local rbxscriptconnection: RBXScriptConnection = obj:Connect(fake_connector);
					local weak_reference: any = setmetatable({func}, {__mode = "v"});
					table.insert(self.getconnections(obj), setmetatable({
						Enable = @native function(): ()
							debounce = true;
						end,
						Disable = @native function(): ()
							debounce = false;
						end,
						Fire = @native function(...: any): ()
							local lua_state: thread = coroutine.create(func);
							self.lua_state_data[lua_state] = current_lua_state_data;
							coroutine.resume(lua_state, unpack(self.encode_sandbox({...})));
						end,
					}, {
						__index = @native function(_self: any, index: string): any
							if index == "State" then
								return rbxscriptconnection.Connected;
							elseif index == "Function" then
								return weak_reference[0x01];
							end;
							return;
						end,	
					}));
					obj = nil :: never;
					return rbxscriptconnection;
				end,
			}
		}
	}
end;
