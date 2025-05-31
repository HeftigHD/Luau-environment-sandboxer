return function(self: any): {any}
	local el_types: {string} = {"function", "table", "Instance", "RBXScriptConnection", "RBXScriptSignal", "thread", "buffer", "SharedTable"};
	local keys: any = setmetatable({}, {__mode = "k"});
	local gc: {any} = self.gc;
	local weak_object_alias: {[any]: any} = self.weak_object_alias;
	return {
		insert_gc = @native function(obj: any): ()
			obj = weak_object_alias[obj] or obj;
			if not keys[obj] and table.find(el_types, typeof(obj)) then
				keys[obj] = 1;
				table.insert(gc, obj);
			end;
		end,
	}
end
