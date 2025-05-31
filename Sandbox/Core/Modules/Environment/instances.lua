--!nocheck
--!native

return @native @checked function(self: any): {any}
	local weak_object_alias: {[any]: any} = self.weak_object_alias;
	local inverse_weak_object_alias: {[any]: any} = self.inverse_weak_object_alias;
	local weak_object_alias_data: {[any]: {string}} = self.weak_object_alias_data;
	local raw_metatable: {[any]: {[string]: any}} = self.raw_metatable;
	local construct_method: (any) -> (any);
	local insert_gc: (any) -> ();
	coroutine.wrap(function()
		repeat task.wait() until self.insert_gc and self.construct_method;
		insert_gc = self.insert_gc;
		construct_method = self.construct_method;
	end)()
	local methods: {[string]: (...any) -> (...any)} = self.methods;
	local fetch_class = @native function(object: any): (boolean, any)
		return object.ClassName;
	end;
	return {
		create_instance = @native @checked function(object: Instance?): any
			if object then
				local exists_already: any? = inverse_weak_object_alias[object];
				if exists_already then
					return exists_already;
				end;
				local fake_object: any = newproxy(true);
				local fake_metatable: {[string]: ((...any) -> (...any)) | string} = getmetatable(fake_object);
				local type_str: string = typeof(object);
				local class: string = "";
				if type_str == "Instance" then
					local success: boolean, result: string = pcall(fetch_class, object);
					if success then
						class = result;
					end;
				end;
				weak_object_alias[fake_object] = object;
				inverse_weak_object_alias[object] = fake_object;
				weak_object_alias_data[fake_object] = {type_str, class};
				insert_gc(fake_object);
				raw_metatable[fake_object] = fake_metatable;
				for i: string, v: ((...any) -> (...any)) | string in self.methods[type_str] or construct_method(object) do
					fake_metatable[i] = v;	
				end;
				return fake_object;
			end;
			return;
		end;
	}
end;