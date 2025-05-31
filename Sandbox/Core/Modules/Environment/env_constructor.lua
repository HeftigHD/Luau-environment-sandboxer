return @native @checked function(self)
	local el_globals: {[string]: number} = {["DockWidgetPluginGuiInfo"] = 1, ["warn"] = 2, ["tostring"] = 3, ["gcinfo"] = 4, ["os"] = 5, ["tick"] = 6, ["task"] = 7, ["getfenv"] = 8, ["debug"] = 9, ["NumberSequence"] = 10, ["assert"] = 11, ["rawlen"] = 12, ["tonumber"] = 13, ["CommandData"] = 14, ["Color3"] = 15, ["Enum"] = 16, ["Delay"] = 17, ["OverlapParams"] = 18, ["Path2DControlPoint"] = 19, ["SecurityCapabilities"] = 20, ["AdReward"] = 21, ["vector"] = 22, ["ypcall"] = 23, ["coroutine"] = 24, ["DateTime"] = 25, ["NumberRange"] = 26, ["buffer"] = 27, ["PhysicalProperties"] = 28, ["elapsedTime"] = 29, ["version"] = 30, ["PluginManager"] = 31, ["Stats"] = 32, ["stats"] = 33, ["Ray"] = 34, ["NumberSequenceKeypoint"] = 35, ["Version"] = 36, ["Vector2"] = 37, ["UserSettings"] = 38, ["Game"] = 39, ["Content"] = 40, ["spawn"] = 41, ["settings"] = 42, ["string"] = 43, ["xpcall"] = 44, ["loadstring"] = 45, ["printidentity"] = 46, ["FloatCurveKey"] = 47, ["print"] = 48, ["delay"] = 49, ["Wait"] = 50, ["wait"] = 51, ["RaycastParams"] = 52, ["unpack"] = 53, ["TweenInfo"] = 54, ["ElapsedTime"] = 55, ["require"] = 56, ["Vector3"] = 57, ["time"] = 58, ["Vector3int16"] = 59, ["setmetatable"] = 60, ["next"] = 61, ["Workspace"] = 62, ["UDim2"] = 63, ["RotationCurveKey"] = 64, ["ipairs"] = 65, ["Font"] = 66, ["CatalogSearchParams"] = 67, ["rawequal"] = 68, ["Region3int16"] = 69, ["collectgarbage"] = 70, ["game"] = 71, ["getmetatable"] = 72, ["Spawn"] = 73, ["PluginDrag"] = 74, ["Region3"] = 75, ["utf8"] = 76, ["Random"] = 77, ["CellId"] = 78, ["rawset"] = 79, ["PathWaypoint"] = 80, ["CFrame"] = 81, ["_VERSION"] = 82, ["UDim"] = 83, ["workspace"] = 84, ["table"] = 85, ["math"] = 86, ["bit32"] = 87, ["pcall"] = 88, ["pairs"] = 89, ["ColorSequenceKeypoint"] = 90, ["type"] = 91, ["typeof"] = 92, ["SharedTable"] = 93, ["select"] = 94, ["Vector2int16"] = 95, ["ColorSequence"] = 96, ["rawget"] = 97, ["newproxy"] = 98, ["Rect"] = 99, ["BrickColor"] = 100, ["setfenv"] = 101, ["Instance"] = 102, ["Axes"] = 103, ["error"] = 104, ["Faces"] = 105};
	return {
		construct_sandboxed_env = @native function(): ()
			local new_env: any = self.sandboxed_ENV;
			local inverse_hookable_funcs: {[(...any) -> (...any)]: (...any) -> (...any)} = self.inverse_hookable_funcs;
			local encode_sandbox: ({any}) -> ({any}) = self.encode_sandbox;
			local weak_object_alias: {[any]: any} = self.weak_object_alias;
			local wrap_globals; wrap_globals = @native function(elements: any, write_into: {any}, read_from: {any}): ()
				local to_freeze: {any} = {};
				for i: any in elements do
					local real_element: any = read_from[i];
					local type_str: string = type(real_element);
					if type_str == "function" then
						local func; func = @native function(...: any): (...any)
							local args: {any} = {...};
							for i: any, v: any in args do
								args[i] = weak_object_alias[v] or v;
							end;
							local result: {any} = {pcall(inverse_hookable_funcs[func], unpack(args))};
							if not result[0x01] then
								return error(result[0x02], 2);
							end;
							return select(2, unpack(encode_sandbox(result)));
						end;
						write_into[i] = func;
						if not table.find(self.blacklisted_funcs, i) and debug.info(real_element, "s") == "[C]" then
							write_into[i] = (self.usenewcclosure and self.newcclosure(func)) or func;
							func = write_into[i];
						end;
						self.hookable_funcs[real_element] = func;
						self.inverse_hookable_funcs[func] = real_element;
						self.c_func_data[func] = {debug.info(real_element, "slna")};
						table.insert(self.c_functions, func);
						self.illegal_debug_fetch[real_element] = func;
					elseif type_str == "table" then
						local new_table: {any} = {}; 
						if table.isfrozen(real_element) then
							table.insert(to_freeze, new_table);
						end;
						write_into[i] = new_table;
						wrap_globals(real_element, new_table, real_element);
					elseif type_str == "userdata" then
						write_into[i] = self.create_instance(real_element);
					else
						write_into[i] = real_element;
					end;
				end;
				for _: number, v: any in to_freeze do
					table.freeze(v);
				end;
			end;
			wrap_globals(el_globals, new_env, _G.ENV);
		end,
	}
end;
