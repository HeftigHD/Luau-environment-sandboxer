--!nocheck
--!native
local self: {any} = {
	usenewcclosure = false,
	raw_encode = true,
	inverse_weak_object_alias = setmetatable({}, {__mode = "vs"}),
	weak_object_alias = setmetatable({}, {__mode = "ks"}),
	weak_object_alias_data = setmetatable({}, {__mode = "ks"});
	raw_metatable = setmetatable({}, {__mode = "ks"}),
	hookable_funcs = setmetatable({}, {}),
	inverse_hookable_funcs = setmetatable({}, {}),
	lua_state_data = setmetatable({}, {__mode = "ks"}),
	isolated_lua_state = setmetatable({}, {__mode = "kvs"}),
	thread_callstack = setmetatable({}, {__mode = "kvs"});
	script_closures_list = setmetatable({}, {__mode = "vs"}),
	gc = setmetatable({}, {__mode = "kvs"}),
	blacklisted_funcs = {"setfenv", "getfenv", "info", "__namecall"},
	real_methods = {},
	connections = {},
	methods = {},
	illegal_debug_fetch = {},
	sandboxed_ENV = {},
	c_functions = setmetatable({}, {__mode = "ks"}),
	c_func_data = {},
	_G = {},
	shared = {},
	kernel_thread = coroutine.running(),
};
repeat task.wait() until _G.ENV;
for _: number, v: Instance in script:GetDescendants() do
	if v:IsA("ModuleScript") then
		for i: any, x: any in require(v)(self) do
			self[i] = x;
		end; 
	end;
end;
self.alternative_methods.RBXScriptSignal.connect = self.alternative_methods.RBXScriptConnection.connect
task.wait(0.03);
self.construct_sandboxed_env();
self.init_global_replacements();
coroutine.wrap(self.run_master)();
_G.sandbox = @native @checked function(): ()
	local sandbox_script: BaseScript = getfenv(2).script;
	local current_lua_state: thread = coroutine.running();
	local new_sandbox_env: any = setmetatable({script = self.create_instance(sandbox_script), _G = self._G, shared = self.shared}, {__index = self.sandboxed_ENV, __metatable = "The metatable is locked"});
	self.insert_gc(new_sandbox_env);
	self.insert_gc(current_lua_state);
	self.lua_state_data[current_lua_state] = {script = sandbox_script, env = new_sandbox_env};
	self.script_closures_list[sandbox_script] = current_lua_state;
	self.isolated_lua_state[coroutine.running()] = new_sandbox_env;
	setfenv(2, new_sandbox_env);
end;

