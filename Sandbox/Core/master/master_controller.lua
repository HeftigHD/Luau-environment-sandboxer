
return function(self: any): {any}
	return {
		run_master = @native function(): ()
			local hook;
			hook = self.hookmetamethod(game, "__namecall", @native function(Self: any, ...): any
				if self.getnamecallmethod() == "PostAsync" then
					print("meh", ...)
					return;
				end;
				return hook(Self, ...);
			end);
			--[[while task.wait(2) do
				if #self.getgc() > 400 then
					print(self.getgc())
					break
				end
			end;]]
		end,
	}
end;
