local g = {}
local uis = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()

function g:CreateBase(parent, title)
	if parent:IsA("Instance") then
		local base = {}
		base.was_locked = false
		base.screen_gui = Instance.new("ScreenGui", parent)
		base.screen_gui.IgnoreGuiInset = true
		base.screen_gui.DisplayOrder = math.huge
		base.screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		base.main = Instance.new("Frame", base.screen_gui)
		base.main.Size = UDim2.fromScale(.4, .4)
		base.main.AnchorPoint = Vector2.new(.5, .5)
		base.main.Position = UDim2.fromScale(.5, .5)
		base.main.BorderSizePixel = 0
		base.main.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
		base.corner = Instance.new("UICorner", base.main)
		base.corner.CornerRadius = UDim.new(0, 8)
		base.title = Instance.new("TextLabel", base.main)
		base.title.BackgroundTransparency = 1
		base.title.Font = 16
		base.title.TextSize = 24
		base.title.Position = UDim2.fromScale(0.02, 0.02)
		base.title.Size = UDim2.fromScale(0.15, 0.07)
		base.title.Text = title or "yiffware"
		base.title.TextXAlignment = Enum.TextXAlignment.Left
		base.title.TextYAlignment = Enum.TextYAlignment.Top
		base.title.TextColor3 = Color3.new(1, 1, 1)
		base.category_holder = Instance.new("Frame", base.main)
		base.category_holder.Size = UDim2.fromScale(0.85, 0.07)
		base.category_holder.Position = UDim2.fromScale(0.15, 0.02)
		base.category_holder.BackgroundTransparency = 1
		base.category_ui_layout = Instance.new("UIListLayout", base.category_holder)
		base.category_ui_layout.FillDirection = Enum.FillDirection.Horizontal
		base.category_ui_layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		base.category_ui_layout.SortOrder = Enum.SortOrder.LayoutOrder
		base.content = Instance.new("Frame", base.main)
		base.content.Size = UDim2.fromScale(1, 0.93)
		base.content.Position = UDim2.fromScale(0, 0.07)
		base.content.BackgroundTransparency = 1
		function base:ChangeCategory(category)
			if type(category) == "table" then
				if category.content.Parent == base.content then
					for i, c in ipairs(base.content:GetChildren()) do
						if c ~= category.content then
							c.Visible = false
						else
							c.Visible = true
						end
					end
					for i, c in ipairs(base.category_holder:GetChildren()) do
						if c ~= category.category_button and c:IsA("TextButton") then
							c.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
						end
					end
				end
			end
		end
		function base:ToggleVisibility()
			base.screen_gui.Enabled = not base.screen_gui.Enabled
			print(uis.MouseBehavior)
			if base.screen_gui.Enabled and Enum.MouseBehavior.LockCenter then
				base.waslocked = true
				uis.MouseBehavior = Enum.MouseBehavior.Default
				game:GetService("UserInputService").MouseIconEnabled = true
			elseif base.waslocked then
				base.waslocked = false
				uis.MouseBehavior = Enum.MouseBehavior.LockCenter
				game:GetService("UserInputService").MouseIconEnabled = false
			end
		end
		uis.InputBegan:Connect(function(_)
			if _.UserInputType == Enum.UserInputType.Keyboard then
				if _.KeyCode == Enum.KeyCode.F1 then
					base:ToggleVisibility()	
				end
			end
		end)
		return base
	end
end

function g:CreateCategory(base, name)
	if type(base) == "table" then
		local category = {}
		category.category_button = Instance.new("TextButton", base.category_holder)
		category.category_button.Size = UDim2.fromScale(0.1, 1)
		category.category_button.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
		category.category_button.BorderSizePixel = 0
		category.category_button.TextColor3 = Color3.new(1, 1, 1)
		category.category_button.Text = name or "untitled"
		category.category_button.TextSize = 16
		category.category_button.Font = 3
		category.category_button.Activated:Connect(function()
			base:ChangeCategory(category)
			category.category_button.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		end)
		category.content = Instance.new("Frame", base.content)
		category.content.Size = UDim2.fromScale(1, 1)
		category.content.BackgroundTransparency = 1
		category.content.Visible = false
		category.ui_layout = Instance.new("UIListLayout", category.content)
		category.ui_layout.SortOrder = Enum.SortOrder.LayoutOrder
		category.ui_layout.FillDirection = Enum.FillDirection.Horizontal
		category.ui_layout.Padding = UDim.new(0.01, 0)
		category.ui_padding = Instance.new("UIPadding", category.content)
		category.ui_padding.PaddingTop = UDim.new(0.05, 0)
		category.ui_padding.PaddingLeft = UDim.new(0.01, 0)
		category.padding = Instance.new("Frame", category.content)
		category.padding.Size = UDim2.fromScale(0, 0.02)
		category.padding.BackgroundTransparency = 1
		return category
	end
end

function g:CreateSection(category, name)
	if type(category) == "table" then
		local section = {}
		section.content = Instance.new("Frame", category.content)
		section.content.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		section.content.Size = UDim2.fromScale(.48, .95)
		section.corner = Instance.new("UICorner", section.content)
		section.corner.CornerRadius = UDim.new(0, 8)
		section.title = Instance.new("TextLabel", section.content)
		section.title.BackgroundTransparency = 1
		section.title.Text = name or "Untitled Section"
		section.title.Font = 18 
		section.title.TextSize = 16
		section.title.TextColor3 = Color3.new(1, 1, 1)
		section.title.TextXAlignment = Enum.TextXAlignment.Center
		section.title.Size = UDim2.fromScale(1, 0.1)
		section.ui_layout = Instance.new("UIListLayout", section.content)
		section.ui_layout.Padding = UDim.new(0.05, 0)
		section.ui_layout.SortOrder = Enum.SortOrder.LayoutOrder
		return section
	end
end

function g:CreateCheckbox(section, name, state)
	if type(section) == "table" then
		local gui = {}
		gui.state = state
		gui.bg = Instance.new("Frame", section.content)
		gui.bg.Size = UDim2.fromScale(1, 0.03)
		gui.bg.BackgroundTransparency = 1
		gui.bg.ZIndex = 2
		gui.box = Instance.new("Frame", gui.bg)
		gui.box.Size = UDim2.fromOffset(16, 16)
		gui.box.AnchorPoint = Vector2.new(0.5, 0.5)
		gui.box.Position = UDim2.fromScale(0.05, 0.5)
		gui.box.BorderSizePixel = 0
		gui.corner = Instance.new("UICorner", gui.box)
		gui.corner.CornerRadius = UDim.new(0, 4)
		gui.text = Instance.new("TextLabel", gui.bg)
		gui.text.Size = UDim2.fromScale(0.8, 1)
		gui.text.Position = UDim2.new(0, 32, .5)
		gui.text.AnchorPoint = Vector2.new(0, 0.5)
		gui.text.BackgroundTransparency = 1
		gui.text.Font = 16
		gui.text.TextSize = 16
		gui.text.TextColor3 = Color3.new(1, 1, 1)
		gui.text.TextXAlignment = Enum.TextXAlignment.Left
		gui.text.Text = name
		gui.btn = Instance.new("TextButton", gui.bg)
		gui.btn.Size = UDim2.new(1, 0, 1, 0)
		gui.btn.BackgroundTransparency = 1
		gui.btn.Text = ""
		print(gui.state)
		function gui:ChangeState(s)
			if s then
				gui.box.BackgroundColor3 = Color3.fromRGB(35, 165, 69)
				gui.state = true
			else
				gui.box.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
				gui.state = false
			end
			print(tostring(s).." "..tostring(gui.state))
		end
		gui:ChangeState(state)
		gui.btn.Activated:Connect(function()
			print("as")
			gui:ChangeState(not gui.state)
		end)
		return gui

	end
end

function g:CreateSlider(category, name, upper_limit, amount)
	if type(category) == "table" then
		local slider = {}
		slider.being_dragged = false
		slider.amount = amount
		slider.bg = Instance.new("Frame", category.content)
		slider.bg.Size = UDim2.new(1, 0, 0, 15)
		slider.bg.BackgroundTransparency = 1
		slider.fg = Instance.new("Frame", slider.bg)
		slider.fg.Size = UDim2.fromScale((amount/upper_limit)/.95, 1)
		slider.fg.BorderSizePixel = 0
		slider.fg.Position = UDim2.fromScale(.025)
		slider.fg.BackgroundColor3 = Color3.fromRGB(30, 205, 110)
		slider.corner = Instance.new("UICorner", slider.fg)
		slider.corner.CornerRadius = UDim.new(0, 8)
		slider.btn = Instance.new("TextButton", slider.bg)
		slider.btn.Size = UDim2.fromScale(.9, 1)
		slider.btn.Position = UDim2.fromScale(.025)
		slider.btn.BackgroundTransparency = 1
		slider.btn.Text = (name.." :" or "untitled: ")..tostring(amount)
		slider.btn.TextColor3 = Color3.new(1, 1, 1)
		slider.btn.Font = 16
		slider.btn.TextSize = 16
		slider.btn.MouseButton1Down:Connect(function()
			slider.being_dragged = true
		end)
		uis.InputEnded:Connect(function(_)
			if _.UserInputType == Enum.UserInputType.MouseButton1 then
				slider.being_dragged = false
			end
		end)
		uis.InputChanged:Connect(function()
			if slider.being_dragged then
				local relpos = Vector2.new(mouse.x, mouse.y) - slider.fg.AbsolutePosition
				if relpos.X <= slider.btn.AbsoluteSize.X and relpos.X >= 0 then
					slider.amount = math.floor(((slider.fg.AbsoluteSize.X / slider.bg.AbsoluteSize.X*(upper_limit+(upper_limit/12.5))))+0.5)
					slider.fg.Size = UDim2.new(0, relpos.X, 1)
					print(relpos.X)
					slider.btn.Text = (name.." :" or "untitled: ")..tostring(slider.amount)
				end
				if relpos.X > slider.btn.AbsoluteSize.X then
					slider.amount = upper_limit
					slider.fg.Size = UDim2.fromScale(.95, 1)
					slider.btn.Text = (name.." :" or "untitled: ")..tostring(slider.amount)
				end
				if relpos.X < 0 then
					slider.amount = 0
					slider.fg.Size = UDim2.fromScale(0, 1)
					slider.btn.Text = (name.." :" or "untitled: ")..tostring(slider.amount)
				end
			end
		end)
		return slider 
	end
end

function g:CreateComboBox(section, name, items, current_item)
	if type(section) == "table" and type(items) == "table" then
		local combo_box = {}
		combo_box.current_item = ""
		combo_box.bg = Instance.new("Frame", section.content)
		combo_box.bg.Size = UDim2.fromScale(1, .05)
		combo_box.bg.BackgroundTransparency = 1
		combo_box.btn = Instance.new("TextButton", combo_box.bg)
		combo_box.btn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		combo_box.btn.Size = UDim2.fromScale(.95, 1)
		combo_box.btn.AnchorPoint = Vector2.new(.5, .5)
		combo_box.btn.Position = UDim2.fromScale(.5, .5)
		combo_box.btn.Text = ""
		combo_box.btn.TextColor3 = Color3.new(1, 1, 1)
		combo_box.btn.BorderSizePixel = 0
		combo_box.corner = Instance.new("UICorner", combo_box.btn)
		combo_box.corner.CornerRadius = UDim.new(0 ,8)
		combo_box.container = Instance.new("ScrollingFrame", combo_box.btn)
		combo_box.container.Size = UDim2.fromScale(1, 10)
		combo_box.container.Position = UDim2.fromScale(0, 1)
		combo_box.container.BackgroundTransparency = 1
		combo_box.container.Visible = false
		combo_box.container.ZIndex = 1
		combo_box.btn.ZIndex = 1
		combo_box.bg.ZIndex = 1
		combo_box.ui_layout = Instance.new("UIListLayout", combo_box.container)
		for i, t in pairs(items) do
			combo_box[t] = Instance.new("TextButton", combo_box.container)
			combo_box[t].BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			combo_box[t].Size = UDim2.fromScale(1, .1)
			combo_box[t].Text = tostring(t)
			combo_box[t].TextColor3 = Color3.new(1, 1, 1)
			combo_box[t].BorderSizePixel = 0
			combo_box[t].ZIndex = 2
			combo_box[t].Activated:Connect(function()
				combo_box:change_item(i)
				combo_box.container.Visible = false
			end)
		end
		function combo_box:change_item(i)
			combo_box.current_item = i
			combo_box.btn.Text = tostring(items[i])
		end
		combo_box:change_item(current_item)
		combo_box.btn.Activated:Connect(function()
			combo_box.container.Visible = not combo_box.container.Visible
		end)
		return combo_box
	end
end

return g
