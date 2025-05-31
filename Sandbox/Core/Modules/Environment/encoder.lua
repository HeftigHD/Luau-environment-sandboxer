--!native
--!strict
return function(self: any): {any}
	local weak_object_alias: {any} = self.weak_object_alias;
	local insert_gc: (any) -> ();
	local create_instance: (any) -> (any);
	local raw_encode: boolean = self.raw_encode;
	local raw_metatable: {[any]: {any}} = self.raw_metatable;
	local getrawmetatable: (any) -> (any);  
	coroutine.wrap(function()
		repeat task.wait() until self.insert_gc;
		insert_gc = self.insert_gc;
		getrawmetatable = self.getrawmetatable;
		create_instance = self.create_instance;
	end)()
	return {
		encode_sandbox = @native function(original: {any}): {any}
			local queue: {any} = {original};
			local queue_count: number = 1;
			while queue_count > 0 do
				local element: any = table.remove(queue, 1);
				queue_count -= 1;
				for i: number, v: any in pairs(element) do
					insert_gc(v);
					local type_str: string = type(v);
					if type_str == "userdata" and typeof(v) ~= "userdata" then
						if raw_encode then
							element[i] = create_instance(v);
						else
							rawset(element, i, create_instance(v));
						end;
					elseif type_str == "table" then
						queue_count += 1;
						queue[queue_count] = v;
					end;
				end;
			end;
			return original;
		end,
		decode_sandbox = @native function(original: {any}): {any}
			local metatable_queue: {{any}} = {};
			local metatable_queue_count: number = 0;
			local lookup: any = {};
			local root_copy: any = {};
			lookup[original] = root_copy;
			local queue: {[number]: {any}} = {
				{original, root_copy}
			};
			local queue_count: number = 1;
			while queue_count > 0 do
				local element: {[number]: {any}} = table.remove(queue, 1) :: {[number]: {any}};
				queue_count -= 1;
				local destination: {any} = element[2];
				local source: {any} = element[1];
				for i: any, v: any in pairs(source) do
					local type_str: string = type(i);
					insert_gc(i);
					if type_str == "table" then
						local looked_up: any = lookup[i];
						if not looked_up then
							local empty_table: {} = {};
							local metadata: {any}? = raw_metatable[i];
							if metadata then
								metatable_queue_count += 1;
								metatable_queue[metatable_queue_count] = {empty_table, metadata};
							end;
							looked_up = empty_table;
							lookup[i] = empty_table;
							queue_count += 1;
							queue[queue_count] = {i, empty_table};
						end;
						i = looked_up;
					else
						local real_object: any = type_str == "userdata" and typeof(v) == "userdata" and weak_object_alias[i];
						if real_object then
							i = real_object;
						end;
					end;
					local type_str: string = type(v);
					insert_gc(v);
					if type_str == "table" then
						local looked_up: any = lookup[v];
						if not looked_up then
							local empty_table: {} = {};
							local metadata: {any}? = raw_metatable[v];
							if metadata then
								metatable_queue_count += 1;
								metatable_queue[metatable_queue_count] = {empty_table, metadata};
							end;
							looked_up = empty_table;
							lookup[v] = empty_table;
							queue_count += 1;
							queue[queue_count] = {v, empty_table};
						end;
						v = looked_up;
					else
						local real_object: any = type_str == "userdata" and typeof(v) == "userdata" and weak_object_alias[v];
						if real_object then
							v = real_object;
						end;
					end;
					destination[i] = v;
				end;
			end;
			while metatable_queue_count > 0 do
				local data: {{any}} = metatable_queue[metatable_queue_count];
				setmetatable(data[0x01], data[0x02]);
				metatable_queue_count -= 1;
			end;
			return root_copy;
		end,
	}
end;
