--[[
    		Fatality-Dark Interface

    Author: 4lpaca
    Modder: 04q3
    License: MIT
    Github: https://github.com/4lpaca-pin/Fatality
--]]

-- Export Types --
export type Window = {
	Name: string,
	Keybind: string | Enum.KeyCode,
	Scale: UDim2,
	Expire: string
}

export type Loader = {
	Name: string,
	Duration: number,
	Scale: number
}

export type Menu = {
	Name: string,
	Icon: string,
	AutoFill: boolean
}

export type Tab = {
	Name: string,
}

export type Section = {
	Name: string,
	Position: string,
	Height: number,
}

export type Listbox = {
	Name: string,
	Option: boolean,
	Multi: boolean,
	Position: string,
	Flag: string | nil,
	Height: number,
	Default: ValueBase,
	Values: {ValueBase},
	Callback: (values: {ValueBase}) -> any
}

export type Preview = {
	Name: string,
	Height: number?,
	Flag: string | nil,
	Elevate: ((() -> any) -> any)?,
	Provider: (() -> any)?,
}

export type Elements = {
	AddToggle: (self,Config: Toggle) -> {
		Option: Elements	
	},
	AddSlider: (self,Config: Slider) -> {
		Option: Elements	
	},
	AddButton: (self,Config: Button) -> {},
	AddColorPicker: (self,Config: ColorPicker) -> {
		Option: Elements	
	},
	AddDropdown: (self,Config: Dropdown) -> {
		Option: Elements	
	},
	AddKeybind: (self,Config: Keybind) -> {
		Option: Elements	
	},
	AddIntInput: (self,Config: IntInput) -> {
		Option: Elements	
	},
	AddTextInput: (self,Config: TextInput) -> {
		Option: Elements	
	},
	AddLabel: (self,Config: Label) -> {},
	AddPreview: (self,Config: Preview) -> {},
}

export type IntInput = {
	Name: string,
	Default: number,
	Min: number?,
	Max: number?,
	Placeholder: (string | number)?,
	Callback: (number) -> any,
	Risky: boolean?,
	Option: boolean?,
	Flag: string | nil,
}

export type TextInput = {
	Name: string,
	Default: string,
	Placeholder: (string)?,
	MaxLength: number?,
	Callback: (string) -> any,
	Risky: boolean?,
	Option: boolean?,
	Flag: string | nil,
}

export type Label = {
	Text: string,
	Name: string?,
	Size: number?,
	Color: Color3?,
	Flag: string | nil,
}

export type Preview = {
	Position: string,
	Height: number
}

export type Toggle = {
	Name: string,
	Default: boolean,
	Callback: (boolean) -> any,
	Risky: boolean,
	Option: boolean,
	Flag: string | nil,
}

export type Slider = {
	Name: string,
	Default: number,
	Min: number,
	Max: number,
	Round: number,
	Type: string,
	Callback: (number) -> any,
	Risky: boolean,
	Flag: string | nil,
	Option: boolean
}

export type Button = {
	Name: string,
	Callback: (number) -> any,
	Risky: boolean,
}

export type ColorPicker = {
	Name: string,
	Default: Color3,
	Transparency: number,
	Callback: (number) -> any,
	Flag: string | nil,
	Option: boolean
}

export type Dropdown = {
	Name: string,
	Default: string | {string},
	Values: {string},
	Callback: (string | {string}) -> any,
	Option: boolean,
	Multi: boolean,
	Flag: string | nil,
	AutoUpdate: boolean
}

export type Keybind = {
	Name: string,
	Default: string | Enum.KeyCode,
	Callback: (string) -> any,
	Flag: string | nil,
	Option: boolean,
}

export type Notify = {
	Title: string,
	Content: string,
	Duration: number,
	Flag: string | nil,
	Icon: string
}

export type Notifier = {
	Notify: (self, Config: Notify) -> nil
}

-- Exploit Environments --
cloneref = cloneref or function(i) return i; end;
clonefunction = clonefunction or function(...) return ...; end;
hookfunction = hookfunction or function(a,b) return a; end;
getgenv = getgenv or getfenv;
protect_gui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;
getgenv().LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(f) return f end;

-- Every service handle goes through cloneref (cached, guarded).
local _svcCache = {};
local function svc(name)
	if _svcCache[name] ~= nil then return _svcCache[name]; end;
	local inst = nil;
	pcall(function() inst = game:GetService(name); end);
	if inst ~= nil then
		pcall(function()
			local c = cloneref(inst);
			if c ~= nil then inst = c; end;
		end);
	end;
	if inst ~= nil then _svcCache[name] = inst; end;
	return inst;
end;

if svc('RunService') and svc('RunService'):IsStudio() then
	local BaseWorkspace = Instance.new('Folder',svc("ReplicatedFirst"));

	BaseWorkspace.Name = "WORKSPACE";

	local __get_path_c = function(path)
		return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
	end

	local __get_path = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			block = block[v];
		end;

		return block;
	end;

	getgenv().readfile = function(path)
		local path : StringValue = __get_path(path);

		return path.Value;
	end;

	getgenv().isfile = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and not message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().isfolder = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().writefile = function(path,content)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('StringValue',block);

				c.Name = tostring(v);
				c.Value = content;
			else
				if item:IsA('StringValue') and tostring(item) == v then
					item.Name = tostring(v);
					item.Value = content;
				end;

				block = item;
			end;
		end;
	end;

	getgenv().listfiles = function(path)
		local fold = __get_path(path);
		local pa = {};

		for i,v in next , fold:GetChildren() do
			if v:IsA('StringValue') then
				table.insert(pa,path..'/'..tostring(v));
			end;
		end;

		return pa;
	end;

	getgenv().makefolder = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('Folder',block);

				c.Name = tostring(v);
			else
				block = item;
			end;
		end;
	end;

	getgenv().delfile = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if item and item:IsA('StringValue') then
				item:Destroy();
			else
				block = item;
			end;
		end;
	end;
end;

-- Services --
local TextService = svc('TextService');
local TweenService = svc('TweenService');
local RunService = svc('RunService');
local Players = svc('Players');
local UserInputService = svc('UserInputService');
local Workspace = svc('Workspace');
local Client = Players and Players.LocalPlayer;
-- Mouse position in VIEWPORT space (what AbsolutePosition uses, since every
-- lib ScreenGui sets IgnoreGuiInset). GetMouseLocation() includes the topbar
-- inset (~36px) while AbsolutePosition excludes it — comparing them raw
-- shifts every hit-test down, so bottom rows of popups read as "outside"
-- and Option panels close on click. Subtract the inset to align the spaces.
-- No GetMouse() object and no executor function anywhere on this path.
local function MousePosition()
	local ok, pos = pcall(function()
		return UserInputService:GetMouseLocation();
	end);
	if ok and typeof(pos) == "Vector2" then
		local okI, inset = pcall(function()
			return svc("GuiService"):GetGuiInset();
		end);
		if okI and typeof(inset) == "Vector2" then
			return pos - inset;
		end;
		return pos;
	end;
	return Vector2.zero;
end;
local CurrentCamera = Workspace and Workspace.CurrentCamera;
-- UI parents STRICTLY to gethui(). No CoreGui / RobloxGui / PlayerGui
-- fallbacks: anything else is visible to game-side scans.
local CoreGui = nil;
pcall(function()
	if type(gethui) == "function" then CoreGui = gethui(); end;
end);

-- Fatality --
local Fatality = {};

Fatality.Ascii = "qwertyuiopasdfghjklzxcvbnmQWRTYUIOPASDFGHJKLZXCVBNM";
Fatality.GLOBAL_ENVIRONMENT = {};
Fatality.Windows = {};
Fatality.FontSemiBold = Font.new('rbxasset://fonts/families/GothamSSm.json',Enum.FontWeight.SemiBold,Enum.FontStyle.Normal);
Fatality.Flags = {};
Fatality.Colors = {
	Black = Color3.fromRGB(16, 16, 16),
	Main = Color3.fromRGB(255, 106, 133)
};
Fatality.DragBlacklist = {};
Fatality.Version = '1.6';

local IconFetchSuccess, IconsModule = pcall(function()
	local success, response = pcall(request, {
		Url = "https://gitlab.com/upio/lucide-roblox-direct/-/raw/main/source.lua",
		Method = "GET",
	})
	assert(success and response.StatusCode >= 200 and response.StatusCode < 300)
	return loadstring(response.Body)()
end)

Fatality.WindowFlags = {};

function Fatality:IsMobile() : boolean
	return UserInputService.TouchEnabled;	
end;

function Fatality:RandomString() : string
	return string.char(math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102));	
end;

function Fatality:GetTextSize(Text : TextLabel,CustomFont: Enum.Font) : Vector2
	return TextService:GetTextSize(Text.Text,Text.TextSize,(Text.Font ~= Enum.Font.Unknown and Text.Font) or (CustomFont or Enum.Font.GothamMedium),Vector2.new(math.huge,math.huge));
end;

function Fatality:IsMouseOverFrame(Frame : Frame) : boolean
	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;
	local MPos: Vector2 = MousePosition();

	if MPos.X >= AbsPos.X and MPos.X <= AbsPos.X + AbsSize.X and MPos.Y >= AbsPos.Y and MPos.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function Fatality:GetCalculatePosition(planePos: number, planeNormal: Vector3, rayOrigin: number, rayDirection: Vector3) : number
	local n: Vector3 = planeNormal;
	local d: Vector3 = rayDirection;
	local v: Vector3 = rayOrigin - planePos;

	local num: number = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den: number = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a: number = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function Fatality:CreateHover(Element : Frame,Callback : (boolean) -> any)
	Element.MouseEnter:Connect(function()
		Callback(true);
	end);

	Element.MouseLeave:Connect(function()
		Callback(false);
	end);
end;

function Fatality:GetIcon(name : string)
	if not IconFetchSuccess then return end
	local s, Icon = pcall(IconsModule.GetAsset, name)
	if not s then return end
	return Icon
end;

function Fatality:SetIcon(imageInstance : ImageLabel, name : string)
	local Icon = self:GetIcon(name)
	if not Icon then return end
	imageInstance.Image = Icon.Url
	imageInstance.ImageRectOffset = Icon.ImageRectOffset
	imageInstance.ImageRectSize = Icon.ImageRectSize
end;

function Fatality:Rounding(num: number, numDecimalPlaces: number) : number
	local mult: number = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;

function Fatality:CreateAnimation(Instance: Instance , Time: number , Style : Enum.EasingStyle , Property : {[string] : any}) : Tween
	if not Property then
		if typeof(Style) == 'table' then
			Property = Style;
			Style = nil;
		end;
	end;

	local Tween: Tween = TweenService:Create(Instance,TweenInfo.new(Time or 1 , Style or Enum.EasingStyle.Quint),Property);

	Tween:Play();

	return Tween;
end;

function Fatality:NewInput(Frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;

	if Callback then
		Button.MouseButton1Click:Connect(Callback);
	end;

	return Button;
end;

function Fatality:Drag(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;

	local function updateInput(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		Fatality:CreateAnimation(MoveFrame,Speed,nil,{
			Position = position
		});
	end;

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #Fatality.DragBlacklist <= 0 then 
			dragToggle = true
			dragStart = input.Position
			startPos = MoveFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch and #Fatality.DragBlacklist <= 0 then
			if dragToggle then
				updateInput(input)
			end
		else
			if #Fatality.DragBlacklist > 0 then
				dragToggle = false
			end
		end
	end);
end;

function Fatality:ScrollSignal(Scroll: ScrollingFrame,UIListLayout: UIListLayout,Type:string)
	if Type == 'X' then
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X,0)
		end)
	else
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
		end)
	end;
end;

function Fatality:CreateResponse(args: {[string] : (any) -> any})
	local main = {};

	for i,v in next , args do
		if typeof(v) == 'function' then
			main[i] = function(self , ...)
				return v(...);
			end;
		else
			main[i] = v;
		end;
	end;

	return main;
end;

function Fatality:GetWindowFromElement(Element: GuiObject)
	for i,v in next , Fatality.Windows do
		if Element:IsDescendantOf(v) then
			return v;
		end;
	end;
end;

function Fatality:CreateOption(OptionButton: ImageButton): Elements
	Fatality:CreateHover(OptionButton,function(bool)
		if bool then
			Fatality:CreateAnimation(OptionButton,0.5,{
				ImageTransparency = 0.3
			})
		else
			Fatality:CreateAnimation(OptionButton,0.5,{
				ImageTransparency = 0.600
			})
		end;
	end);

	local Bindable = Instance.new('BindableEvent');
	local OwnWindow = Fatality:GetWindowFromElement(OptionButton);
	local ExtElementFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SpaceBox = Instance.new("Frame")

	Fatality:ScrollSignal(ScrollingFrame,UIListLayout,'Y');

	ExtElementFrame.Active = true;
	ExtElementFrame.Name = Fatality:RandomString()
	ExtElementFrame.Parent = OwnWindow
	ExtElementFrame.AnchorPoint = Vector2.new(0.5, 0)
	ExtElementFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ExtElementFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExtElementFrame.BorderSizePixel = 0
	ExtElementFrame.ClipsDescendants = true
	ExtElementFrame.Position = UDim2.new(2, 0, 2, 0)
	ExtElementFrame.Size = UDim2.new(0, 200, 0, 0)
	ExtElementFrame.ZIndex = 100

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ExtElementFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ExtElementFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = ExtElementFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = ExtElementFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = true
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, 0, 1, -5)
	ScrollingFrame.ZIndex = 109
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	SpaceBox.Name = Fatality:RandomString()
	SpaceBox.Parent = ScrollingFrame
	SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpaceBox.BorderSizePixel = 0
	SpaceBox.Size = UDim2.new(0, 0, 0, 3)

	local SPAWN_THREAD;

	local extOpened = false;

	local ToggleExt = function(bool)
		extOpened = (bool == true);
		if bool then
			Bindable:SetAttribute('V',true);
			Bindable:Fire(true);

			local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,320)

			ExtElementFrame.Position = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2))

			Fatality:CreateAnimation(ExtElementFrame,0.45,{
				Size = UDim2.new(0, 200, 0, size)
			})

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 0.750
			})

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 0
			})

			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait(0.1)
					local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,320)
					local ud = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2));

					Fatality:CreateAnimation(ExtElementFrame,0.35,{
						Position = ud,
						Size = UDim2.new(0, 200, 0, size)
					});
				end;
			end)
		else
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			Bindable:SetAttribute('V',false);
			Bindable:Fire(false);

			Fatality:CreateAnimation(ExtElementFrame,0.45,{
				Size = UDim2.new(0, 200, 0, 0)
			})

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 1
			})
		end;
	end;

	Bindable:SetAttribute('V',false);

	ToggleExt(false);

	OptionButton.MouseButton1Click:Connect(function()
		ToggleExt(true);
	end);

	UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Guard: closed option panels used to run hit-tests + Fire(false)
			-- (cascading into child tweens) + 3 tweens on EVERY global click.
			if extOpened and not Fatality:IsMouseOverFrame(ExtElementFrame) and not Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER then
				ToggleExt(false);
			end;
		end;
	end);

	local UIElements: Elements = Fatality:CreateElements(ScrollingFrame,ScrollingFrame.ZIndex,Bindable);

	return UIElements;
end;

function Fatality:CreateColorPicker(ColorBox: Frame,Transparency, Callback)
	Transparency = Transparency or 0;
	Callback = Callback or function() end;

	local OwnWindow = Fatality:GetWindowFromElement(ColorBox);
	local ColorPickerFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ColorPickBox = Instance.new("ImageLabel")
	local MouseMovement = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorRedGreenBlue = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local ColorRGBSlide = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local ColorOpc = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local ColorOptSlide = Instance.new("Frame")
	local UIStroke_4 = Instance.new("UIStroke")
	local UIGradient_2 = Instance.new("UIGradient")
	local UIStroke_5 = Instance.new("UIStroke")
	local ColorOpt = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local PasteButton = Instance.new("ImageButton")
	local CopyButton = Instance.new("ImageButton")
	local hexCode = Instance.new("Frame")
	local UICorner_6 = Instance.new("UICorner")
	local HexCodeText = Instance.new("TextLabel")

	local OldCode = 0;
	local CodeH,CodeV = 1, 1;
	local IsPressM1 = false;
	local UI_SPAWN_THREAD;
	local pickerOpen = false;

	local updateColor = function()
		local H , S , V = ColorBox.BackgroundColor3:ToHSV();

		OldCode = H;
		CodeH = S;
		CodeV = V;
	end;

	local VisibleToggle = function(value)
		pickerOpen = (value == true);
		if value then
			ColorPickBox.BackgroundColor3 = Color3.fromHSV(OldCode,1,1);
			ColorOpc.BackgroundColor3 = ColorBox.BackgroundColor3;

			HexCodeText.Text = "#" .. tostring(ColorPickBox.BackgroundColor3:ToHex())

			ColorPickerFrame.Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);

			updateColor();

			if UI_SPAWN_THREAD then
				task.cancel(UI_SPAWN_THREAD);
				UI_SPAWN_THREAD = nil;
			end;

			UI_SPAWN_THREAD = task.spawn(function()
				while true do task.wait()
					Fatality:CreateAnimation(ColorPickerFrame,0.35,{
						Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);
					});
				end;
			end);

			Fatality:CreateAnimation(ColorRGBSlide,0.35,{
				Position = UDim2.new(0.5, 0, OldCode, 0)
			});

			Fatality:CreateAnimation(MouseMovement,0.35,{
				Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
			})

			Fatality:CreateAnimation(ColorOptSlide,0.35,{
				Position = UDim2.new(1- Transparency, 0, 0.5, 0)
			})

			Fatality:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 195),
			});

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 0
			});

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 0.75
			});

			Fatality:CreateAnimation(ColorPickBox,0.45,{
				ImageTransparency = 0,
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(MouseMovement,0.45,{
				ImageTransparency = 0,
			});

			Fatality:CreateAnimation(UIStroke_2,0.45,{
				Transparency = 0
			});

			Fatality:CreateAnimation(ColorRedGreenBlue,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(ColorRGBSlide,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(UIStroke_3,0.45,{
				Transparency = 0.75
			});

			Fatality:CreateAnimation(ColorOpc,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(ColorOptSlide,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(UIStroke_4,0.45,{
				Transparency = 0.75
			});

			Fatality:CreateAnimation(UIStroke_5,0.45,{
				Transparency = 0
			});

			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.45
			});

			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.45
			});

			Fatality:CreateAnimation(hexCode,0.45,{
				BackgroundTransparency = 0.4
			});

			Fatality:CreateAnimation(HexCodeText,0.45,{
				TextTransparency = 0.45
			});
		else
			if UI_SPAWN_THREAD then
				task.cancel(UI_SPAWN_THREAD);
				UI_SPAWN_THREAD = nil;
			end;

			Fatality:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 0)
			});

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 1
			});

			Fatality:CreateAnimation(ColorPickBox,0.45,{
				ImageTransparency = 1,
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(MouseMovement,0.45,{
				ImageTransparency = 1,
			});

			Fatality:CreateAnimation(UIStroke_2,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(ColorRedGreenBlue,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(ColorRGBSlide,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(UIStroke_3,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(ColorOpc,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(ColorOptSlide,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(UIStroke_4,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(UIStroke_5,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 1
			});

			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 1
			});

			Fatality:CreateAnimation(hexCode,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(HexCodeText,0.45,{
				TextTransparency = 1
			});
		end;
	end;

	ColorPickerFrame.Active = true;
	ColorPickerFrame.Name = Fatality:RandomString()
	ColorPickerFrame.Parent = OwnWindow
	ColorPickerFrame.AnchorPoint = Vector2.new(0.5, 0)
	ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	ColorPickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerFrame.BorderSizePixel = 0
	ColorPickerFrame.ClipsDescendants = true
	ColorPickerFrame.Position = UDim2.new(4,0,4,0)
	ColorPickerFrame.Size = UDim2.new(0, 175, 0, 195)
	ColorPickerFrame.ZIndex = 200
	Fatality:AddDragBlacklist(ColorPickerFrame);

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ColorPickerFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ColorPickerFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = ColorPickerFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 199
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ColorPickBox.Name = Fatality:RandomString()
	ColorPickBox.Parent = ColorPickerFrame
	ColorPickBox.BackgroundColor3 = Color3.fromRGB(39, 255, 35)
	ColorPickBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickBox.BorderSizePixel = 0
	ColorPickBox.Position = UDim2.new(0, 7, 0, 7)
	ColorPickBox.Size = UDim2.new(0, 135, 0, 135)
	ColorPickBox.ZIndex = 201
	ColorPickBox.Image = "http://www.roblox.com/asset/?id=112554223509763"

	MouseMovement.Name = Fatality:RandomString()
	MouseMovement.Parent = ColorPickBox
	MouseMovement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MouseMovement.BackgroundTransparency = 1.000
	MouseMovement.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MouseMovement.BorderSizePixel = 0
	MouseMovement.Position = UDim2.new(0.822222233, 0, 0.0592592582, 0)
	MouseMovement.Size = UDim2.new(0, 12, 0, 12)
	MouseMovement.ZIndex = 205
	MouseMovement.Image = "rbxassetid://4805639000"
	MouseMovement.AnchorPoint = Vector2.new(0.5,0.5)

	UICorner_2.CornerRadius = UDim.new(0, 2)
	UICorner_2.Parent = ColorPickBox

	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_2.Parent = ColorPickBox

	ColorRedGreenBlue.Name = Fatality:RandomString()
	ColorRedGreenBlue.Parent = ColorPickerFrame
	ColorRedGreenBlue.AnchorPoint = Vector2.new(1, 0)
	ColorRedGreenBlue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRedGreenBlue.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRedGreenBlue.BorderSizePixel = 0
	ColorRedGreenBlue.Position = UDim2.new(1, -7, 0, 7)
	ColorRedGreenBlue.Size = UDim2.new(0, 20, 0, 135)
	ColorRedGreenBlue.ZIndex = 206

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Rotation = 90
	UIGradient.Parent = ColorRedGreenBlue

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = ColorRedGreenBlue

	ColorRGBSlide.Name = Fatality:RandomString()
	ColorRGBSlide.Parent = ColorRedGreenBlue
	ColorRGBSlide.AnchorPoint = Vector2.new(0.5, 0)
	ColorRGBSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRGBSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRGBSlide.BorderSizePixel = 0
	ColorRGBSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorRGBSlide.Size = UDim2.new(1, 5, 0, 2)
	ColorRGBSlide.ZIndex = 207

	UIStroke_3.Transparency = 0.750
	UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_3.Parent = ColorRGBSlide

	ColorOpc.Name = Fatality:RandomString()
	ColorOpc.Parent = ColorPickerFrame
	ColorOpc.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpc.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpc.BorderSizePixel = 0
	ColorOpc.Position = UDim2.new(0.5, 0, 0, 149)
	ColorOpc.Size = UDim2.new(1, -15, 0, 12)
	ColorOpc.ZIndex = 206

	UICorner_4.CornerRadius = UDim.new(0, 2)
	UICorner_4.Parent = ColorOpc

	ColorOptSlide.Name = Fatality:RandomString()
	ColorOptSlide.Parent = ColorOpc
	ColorOptSlide.AnchorPoint = Vector2.new(0, 0.5)
	ColorOptSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorOptSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOptSlide.BorderSizePixel = 0
	ColorOptSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorOptSlide.Size = UDim2.new(0, 2, 1, 5)
	ColorOptSlide.ZIndex = 207

	UIStroke_4.Transparency = 0.750
	UIStroke_4.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_4.Parent = ColorOptSlide

	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient_2.Parent = ColorOpc

	UIStroke_5.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_5.Parent = ColorOpc

	ColorOpt.Name = Fatality:RandomString()
	ColorOpt.Parent = ColorPickerFrame
	ColorOpt.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpt.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpt.BackgroundTransparency = 1.000
	ColorOpt.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpt.BorderSizePixel = 0
	ColorOpt.Position = UDim2.new(0.5, 0, 0, 169)
	ColorOpt.Size = UDim2.new(1, -15, 0, 18)
	ColorOpt.ZIndex = 206

	UICorner_5.CornerRadius = UDim.new(0, 2)
	UICorner_5.Parent = ColorOpt

	PasteButton.Name = Fatality:RandomString()
	PasteButton.Parent = ColorOpt
	PasteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PasteButton.BackgroundTransparency = 1.000
	PasteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PasteButton.BorderSizePixel = 0
	PasteButton.Size = UDim2.new(1, 0, 1, 0)
	PasteButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	PasteButton.ZIndex = 209
	Fatality:SetIcon(PasteButton, "clipboard")
	PasteButton.ImageTransparency = 0.450

	CopyButton.Name = Fatality:RandomString()
	CopyButton.Parent = ColorOpt
	CopyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CopyButton.BackgroundTransparency = 1.000
	CopyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CopyButton.BorderSizePixel = 0
	CopyButton.Position = UDim2.new(0, 20, 0, 0)
	CopyButton.Size = UDim2.new(1, 0, 1, 0)
	CopyButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	CopyButton.ZIndex = 209
	Fatality:SetIcon(CopyButton, "clipboard-pen")
	CopyButton.ImageTransparency = 0.450

	hexCode.Name = Fatality:RandomString()
	hexCode.Parent = ColorOpt
	hexCode.BackgroundColor3 = Fatality.Colors.Black
	hexCode.BackgroundTransparency = 0.400
	hexCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
	hexCode.BorderSizePixel = 0
	hexCode.Position = UDim2.new(0, 43, 0, 0)
	hexCode.Size = UDim2.new(1, -43, 1, 0)
	hexCode.ZIndex = 209

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = hexCode

	HexCodeText.Name = Fatality:RandomString()
	HexCodeText.Parent = hexCode
	HexCodeText.AnchorPoint = Vector2.new(0, 0.5)
	HexCodeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HexCodeText.BackgroundTransparency = 1.000
	HexCodeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HexCodeText.BorderSizePixel = 0
	HexCodeText.Position = UDim2.new(0, 3, 0.5, 0)
	HexCodeText.Size = UDim2.new(1, 0, 0.800000012, 0)
	HexCodeText.ZIndex = 209
	HexCodeText.FontFace = Fatality.FontSemiBold
	HexCodeText.Text = "#fff"
	HexCodeText.TextColor3 = Color3.fromRGB(255, 255, 255)
	HexCodeText.TextSize = 13.000
	HexCodeText.TextTransparency = 0.450
	HexCodeText.TextXAlignment = Enum.TextXAlignment.Left;

	Fatality:CreateHover(CopyButton,function(bool)
		if bool then
			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.1
			})
		else
			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.45
			})
		end
	end)	

	Fatality:CreateHover(PasteButton,function(bool)
		if bool then
			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.1
			})
		else
			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.45
			})
		end
	end)

	PasteButton.MouseButton1Click:Connect(function()
		if Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY then
			local h,s,v = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHSV();

			Transparency = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.OPC;

			OldCode = h;
			CodeH = s;
			CodeV = v;

			HexCodeText.Text = "#" .. tostring(Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHex());

			Fatality:CreateAnimation(ColorRGBSlide,0.35,{
				Position = UDim2.new(0.5, 0, OldCode, 0)
			});

			Fatality:CreateAnimation(MouseMovement,0.35,{
				Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
			})

			Fatality:CreateAnimation(ColorOptSlide,0.35,{
				Position = UDim2.new(1- Transparency, 0, 0.5, 0)
			})

			Fatality:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 195),
			});

			ColorPickBox.BackgroundColor3 = Color3.fromHSV(h,1,1);

			ColorOpc.BackgroundColor3 = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB;

			Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency);
		end;
	end);

	CopyButton.MouseButton1Click:Connect(function()
		Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY = {
			RGB = Color3.fromHSV(OldCode,CodeH,CodeV),
			OPC = Transparency,
		};
	end)

	VisibleToggle(false);

	Fatality:NewInput(ColorBox,function()
		VisibleToggle(true);
	end);

	do
		local SPAWN_THREAD;
		ColorPickerFrame.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = true;

				if SPAWN_THREAD then
					task.cancel(SPAWN_THREAD);
					SPAWN_THREAD = nil;
				end;

				SPAWN_THREAD = task.spawn(function()
					while IsPressM1 do task.wait(0)
						Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency);
					end;
				end);
			end;
		end)

		ColorPickerFrame.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = false;
				Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = false;

				if SPAWN_THREAD then
					task.cancel(SPAWN_THREAD);
					SPAWN_THREAD = nil;
				end;
			end;
		end)

		UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				-- Guard: closed pickers used to run a hit-test + ~10 close
				-- tweens on EVERY global click (hundreds per click across a
				-- big menu, even with the menu closed / in-game).
				if not pickerOpen then
					return;
				end;
				if not Fatality:IsMouseOverFrame(ColorPickerFrame) then
					VisibleToggle(false);
				end;
			end;
		end)

		ColorRedGreenBlue.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local ColorY = ColorRedGreenBlue.AbsolutePosition.Y
					local ColorYM = ColorY + ColorRedGreenBlue.AbsoluteSize.Y;
					local Value = math.clamp(MousePosition().Y, ColorY, ColorYM)
					local Code = ((Value - ColorY) / (ColorYM - ColorY));

					local Color = Color3.fromHSV(Code, CodeH, CodeV);

					Fatality:CreateAnimation(ColorRGBSlide,0.35,{
						Position = UDim2.new(0.5, 0, Code, 0)
					});

					Fatality:CreateAnimation(ColorBox,0.5,{
						BackgroundColor3 = Color
					});

					Fatality:CreateAnimation(ColorOpc,0.35,{
						BackgroundColor3 = Color
					});

					Fatality:CreateAnimation(ColorPickBox,0.5,{
						BackgroundColor3 = Color3.fromHSV(Code, 1, 1)
					});

					HexCodeText.Text = "#" .. tostring(Color:ToHex())

					OldCode = Code;
				end;
			end;
		end);

		ColorOpc.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local transparency = math.clamp((((MousePosition().X) - ColorOpc.AbsolutePosition.X) / ColorOpc.AbsoluteSize.X), 0, 1);

					Fatality:CreateAnimation(ColorOptSlide,0.35,{
						Position = UDim2.new(transparency, 0, 0.5, 0)
					});

					HexCodeText.Text = "#" .. tostring(ColorBox.BackgroundColor3:ToHex())

					Transparency = (1 - transparency);
				end;
			end;
		end);

		ColorPickBox.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait();
					local MPos = MousePosition();
					local PosX = ColorPickBox.AbsolutePosition.X
					local ScaleX = PosX + ColorPickBox.AbsoluteSize.X
					local Value, PosY = math.clamp(MPos.X, PosX, ScaleX), ColorPickBox.AbsolutePosition.Y
					local ScaleY = PosY + ColorPickBox.AbsoluteSize.Y
					local Vals = math.clamp(MPos.Y, PosY, ScaleY)

					CodeH = (Value - PosX) / (ScaleX - PosX);
					CodeV = (1 - ((Vals - PosY) / (ScaleY - PosY)));

					Fatality:CreateAnimation(ColorBox,0.5,{
						BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV)
					});

					Fatality:CreateAnimation(ColorOpc,0.35,{
						BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV)
					});

					HexCodeText.Text = "#" .. tostring(Color3.fromHSV(OldCode, CodeH, CodeV):ToHex())

					Fatality:CreateAnimation(MouseMovement,0.2,nil,{
						Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
					})
				end
			end
		end)
	end;

	return {
		set_opc = function(v)
			Transparency = v;
		end,
	}
end;

function Fatality:RandomStr(len: number): string
	local main = "";

	for i = 1 , len do
		local max = #Fatality.Ascii;
		local rand = math.random(1,max);

		main = main .. Fatality.Ascii:sub(rand,rand);
	end;

	return main;
end;

function Fatality:AddDragBlacklist(Frame: Frame)
	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseMovement then
			local finder = table.find(Fatality.DragBlacklist , Frame);

			if not finder then
				table.insert(Fatality.DragBlacklist , Frame);
			end;
		end;
	end);

	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseMovement then
			local finder = table.find(Fatality.DragBlacklist , Frame);

			if finder then
				table.remove(Fatality.DragBlacklist , finder);
			end;
		end;
	end);
end;

function Fatality:ProtectText(Label: TextLabel,Text: string)
	Label.RichText = true;

	local MainText = string.gsub(Text,'.',function(t)
		if not string.find(t,"[<>()\"']") then
			return string.format('<font %s="%s">%s</font>',Fatality:RandomStr(5),Fatality:RandomStr(5),t)
		end;
		return t;
	end);

	Label.Text = MainText;
end;

function Fatality:CreateDropdown(Parent: Frame, Default: string | {[string]: boolean}, Multiplier: boolean, AutoUpdate: boolean,Callback: (data: any) -> any)
	local Window = Fatality:GetWindowFromElement(Parent);
	local Data = {};
	local Selected = (Multiplier and {}) or nil;

	local DropdownItemFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SPAWN_THREAD;
	local opened = false;

	Fatality:AddDragBlacklist(DropdownItemFrame);

	local Toggle = function(value)
		if value then
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait()
					local baseSize = UIListLayout.AbsoluteContentSize.Y + 10;

					DropdownItemFrame.Position = UDim2.fromOffset(Parent.AbsolutePosition.X,Parent.AbsolutePosition.Y + (Parent.AbsoluteSize.Y * 5))

					Fatality:CreateAnimation(DropdownItemFrame,0.35,{
						Size = UDim2.new(0, 175, 0, math.clamp(baseSize,0,200))
					})
				end;
			end)

			Fatality:CreateAnimation(UIStroke,0.35,{
				Transparency = 0
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 0.75
			})
		else
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			Fatality:CreateAnimation(DropdownItemFrame,0.35,{
				Size = UDim2.new(0, 175, 0, 0)
			})

			Fatality:CreateAnimation(UIStroke,0.35,{
				Transparency = 1
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 1
			})
		end;
	end;

	Toggle(false);

	DropdownItemFrame.Name = Fatality:RandomString()
	DropdownItemFrame.Parent = Window
	DropdownItemFrame.AnchorPoint = Vector2.new(0, 0)
	DropdownItemFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	DropdownItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownItemFrame.BorderSizePixel = 0
	DropdownItemFrame.ClipsDescendants = true
	DropdownItemFrame.Position = UDim2.new(4,0,4,0)
	DropdownItemFrame.Size = UDim2.new(0, 175, 0, 100)
	DropdownItemFrame.ZIndex = 500

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = DropdownItemFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = DropdownItemFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = DropdownItemFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = DropdownItemFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = false
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
	ScrollingFrame.ZIndex = 509
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 4)
	end)

	local new_button = function()
		local db_selected = Instance.new("TextButton")

		db_selected.Name = Fatality:RandomString()
		db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		db_selected.BackgroundTransparency = 1.000
		db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
		db_selected.BorderSizePixel = 0
		db_selected.Size = UDim2.new(1, 0, 0, 10)
		db_selected.ZIndex = 510
		db_selected.FontFace = Fatality.FontSemiBold
		db_selected.TextColor3 = Fatality.Colors.Main
		db_selected.TextSize = 12.000
		db_selected.TextXAlignment = Enum.TextXAlignment.Left

		return db_selected;
	end;

	local func;
	local res = Fatality:CreateResponse({
		set_data = function(v)
			Data = v;
		end,
		on_toggle = function(cb)
			func = cb;
		end,
		change_default = function(v)
			Default = v;
		end,
		update_visuals = function()
			for i, v in next, ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					if Multiplier then
						if (typeof(Default) == 'table' and (Default[v.Text] or table.find(Default,v.Text))) or Default == v.Text then
							v.TextColor3 = Fatality.Colors.Main;
							Selected[v.Text] = true
						else
							v.TextColor3 = Color3.fromRGB(255, 255, 255);
							Selected[v.Text] = false
						end
					else
						if v.Text == Default then
							v.TextColor3 = Fatality.Colors.Main;
							Selected = v.Text;
						else
							v.TextColor3 = Color3.fromRGB(255, 255, 255);
						end;
					end
				end
			end
		end,
		refresh = function()
			for i,v in next , ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					v:Destroy();
				end;
			end;

			local selectedmem;

			for i,v in next , Data do
				local bth = new_button();

				bth.Text = tostring(v);

				bth.Parent = ScrollingFrame;

				if Multiplier then
					if (typeof(Default) == 'table' and (Default[v] or table.find(Default,v))) or Default == v then
						Selected[v] = true
						bth.TextColor3 = Fatality.Colors.Main;
					else
						bth.TextColor3 = Color3.fromRGB(255, 255, 255);
						Selected[v] = false
					end

					bth.MouseButton1Click:Connect(function()
						Selected[v] = not Selected[v];

						if Selected[v] then
							bth.TextColor3 = Fatality.Colors.Main;
						else
							bth.TextColor3 = Color3.fromRGB(255, 255, 255);
						end;

						Callback(Selected);
					end)
				else
					if v == Default then
						selectedmem = bth;
						Selected = v;

						bth.TextColor3 = Fatality.Colors.Main;
					else
						bth.TextColor3 = Color3.fromRGB(255, 255, 255);
					end;

					bth.MouseButton1Click:Connect(function()
						if selectedmem then
							selectedmem.TextColor3 = Color3.fromRGB(255, 255, 255);
						end;

						bth.TextColor3 = Fatality.Colors.Main;
						selectedmem = bth;
						Selected = v;

						Callback(v);
						opened = false;
						func(false);
						Toggle(false);
					end)
				end;
			end;

			Callback(Selected);
		end,
	});

	Fatality:NewInput(Parent,function()
		if opened then
			opened = false;
			func(false);
			Toggle(false);
			return;
		end;
		if AutoUpdate then
			res:refresh();
		end;

		opened = true;
		func(true);
		Toggle(true);
	end);

	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			-- Guard: closed dropdowns used to run 2 hit-tests + 5 tweens on
			-- EVERY global click (including in-game shots with the menu
			-- closed) — ~125 tweens per click across the whole menu.
			if not opened then
				return;
			end;
			if not Fatality:IsMouseOverFrame(DropdownItemFrame) and not Fatality:IsMouseOverFrame(Parent) then
				opened = false;
				func(false);
				Toggle(false);
			end;
		end;
	end);

	return res;
end;

function Fatality:CreateElements(Parent : Frame , ZIndex : number , Event : BindableEvent,SearchAPI: {Path: string,Memory : (name:string) -> any}) : Elements
	local elements = {};
	local FatalWindow = Fatality:GetWindowFromElement(Parent);

	function elements:AddToggle(Config: Toggle)
		Config = Config or {};
		Config.Name = Config.Name or "Toggle";
		Config.Default = Config.Default or false;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(bool) end;
		Config.Flag = Config.Flag or nil;

		local Toggle = Instance.new("Frame")
		local Toggle_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ValueIcon = Instance.new("ImageLabel")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Toggle.Name = Fatality:RandomString()
		Toggle.Parent = Parent
		Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Toggle.BackgroundTransparency = 1.000
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(1, -25, 0, 17)
		Toggle.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Toggle);

		Toggle_Name.Name = Fatality:RandomString()
		Toggle_Name.Parent = Toggle
		Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
		Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Toggle_Name.BackgroundTransparency = 1.000
		Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle_Name.BorderSizePixel = 0
		Toggle_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Toggle_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Toggle_Name.ZIndex = ZIndex + 2
		Toggle_Name.FontFace = Fatality.FontSemiBold;
		Toggle_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Toggle_Name.TextSize = 13.000
		Toggle_Name.TextTransparency = 1
		Toggle_Name.TextXAlignment = Enum.TextXAlignment.Left;

		Fatality:ProtectText(Toggle_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Toggle
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		ValueFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
		ValueFrame.ZIndex = ZIndex + 2
		ValueFrame.BackgroundTransparency = 1;

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		ValueIcon.Name = Fatality:RandomString()
		ValueIcon.Parent = ValueFrame
		ValueIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueIcon.BackgroundTransparency = 1.000
		ValueIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueIcon.BorderSizePixel = 0
		ValueIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueIcon.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
		ValueIcon.ZIndex = ZIndex + 2
		Fatality:SetIcon(ValueIcon, "check")
		ValueIcon.ImageTransparency = 1;

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = Toggle
		OptionButton.AnchorPoint = Vector2.new(1, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(1, -25, 0.5, 0)
		OptionButton.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 1
		OptionButton.ZIndex = ZIndex + 4
		OptionButton.Visible = Config.Option;

		local toggleImg = function(value)
			if value then
				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 0,
					ImageColor3 = Fatality.Colors.Main,
					Size = UDim2.new(0.8, 0, 0.8, 0),
					Rotation = 0,
				})
			else
				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0.699999988, 0, 0.699999988, 0),
					Rotation = 15
				})
			end;
		end;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.600) or 1
				})

				toggleImg(Config.Default)

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0,
				})

				Fatality:CreateAnimation(Toggle_Name,0.45,{
					TextTransparency = 0.200
				})
			else
				Fatality:CreateAnimation(Toggle_Name,0.45,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1,
				})

				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
				})

				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))

		toggleImg(Config.Default);

		Fatality:CreateHover(ValueFrame,function(b)
			if not Config.Default then
				if b then
					Fatality:CreateAnimation(ValueIcon,0.45,{
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(0.7, 0, 0.7, 0),
						Rotation = 0
					})
				else
					Fatality:CreateAnimation(ValueIcon,0.45,{
						ImageTransparency = 1,
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(0.699999988, 0, 0.699999988, 0),
						Rotation = 15
					})
				end;
			end;
		end)

		Fatality:NewInput(ValueFrame,function()
			Config.Default = not Config.Default;
			toggleImg(Config.Default);
			Config.Callback(Config.Default)
		end);

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Toggle_Name.Text = new_name;
				Fatality:ProtectText(Toggle_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v)
				local IsSame = v == Config.Default;

				Config.Default = v;

				toggleImg(Config.Default);

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and (Config.Flag.."Toggle"),
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			Frame = Toggle,
			Destroy = function()
				pcall(function()
					Toggle:Destroy();
				end);
			end,
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Toggle"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddSlider(Config: Slider)
		Config = Config or {};
		Config.Name = Config.Name or "Slider";
		Config.Type = Config.Type or "";
		if Config.Default == nil then
			Config.Default = 50;
		end;
		Config.Min = Config.Min or 0;
		Config.Max = Config.Max or 100;
		Config.Round = Config.Round or 0;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(number) end;
		Config.Flag = Config.Flag or nil;

		local Slider = Instance.new("Frame")
		local Slider_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local boxli = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Slider.Name = Fatality:RandomString()
		Slider.Parent = Parent
		Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.Size = UDim2.new(1, -25, 0, 17)
		Slider.ZIndex = ZIndex + 1

		Fatality:AddDragBlacklist(Slider);

		Slider_Name.Name = Fatality:RandomString()
		Slider_Name.Parent = Slider
		Slider_Name.AnchorPoint = Vector2.new(0, 0.5)
		Slider_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Slider_Name.BackgroundTransparency = 1.000
		Slider_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider_Name.BorderSizePixel = 0
		Slider_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Slider_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Slider_Name.ZIndex = ZIndex + 2
		Slider_Name.FontFace = Fatality.FontSemiBold
		Slider_Name.Text = Config.Name
		Slider_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Slider_Name.TextSize = 13.000
		Slider_Name.TextTransparency = 0.200
		Slider_Name.TextXAlignment = Enum.TextXAlignment.Left

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 85, 0.600000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option;
		OptionButton.ZIndex = ZIndex + 1;

		boxli.Name = Fatality:RandomString()
		boxli.Parent = ValueFrame
		boxli.BackgroundColor3 = Fatality.Colors.Main
		boxli.BorderColor3 = Color3.fromRGB(0, 0, 0)
		boxli.BorderSizePixel = 0
		boxli.Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
		boxli.ZIndex = ZIndex + 3

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = boxli

		ValueText.Name = Fatality:RandomString()
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 4
		ValueText.FontFace = Fatality.FontSemiBold
		ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));
		ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850;
		ValueText.TextTransparency = 0;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(boxli,0.45,{
					BackgroundTransparency = 0,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.600) or 1
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0,
				})

				Fatality:CreateAnimation(Slider_Name,0.45,{
					TextTransparency = 0.200
				})

				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0;
				})
			else
				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1;
				})

				Fatality:CreateAnimation(Slider_Name,0.45,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1,
				})

				Fatality:CreateAnimation(boxli,0.45,{
					BackgroundTransparency = 1,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))

		local IsHold = false;

		local function update(Input)
			local SizeScale = math.clamp((((Input.Position.X) - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X), 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = Fatality:Rounding(Main,Config.Round);
			local PositionX = UDim2.fromScale(SizeScale, 1);
			local normalized = (Value - Config.Min) / (Config.Max - Config.Min);

			TweenService:Create(boxli , TweenInfo.new(0.2),{
				Size = UDim2.new(normalized, 0, 1, 0)
			}):Play();

			Config.Default = Value;
			ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));

			Config.Callback(Value)
		end;

		do
			ValueFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					update(Input)
				end
			end)

			ValueFrame.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not Fatality:IsMouseOverFrame(ValueFrame) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not Fatality:IsMouseOverFrame(ValueFrame) then
								IsHold = false
							else
								update(Input)
							end;
						else
							update(Input)
						end;
					end;
				end;
			end);
		end;

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Slider_Name.Text = new_name
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v)
				local IsSame = v == Config.Default;

				Config.Default = v;

				TweenService:Create(boxli , TweenInfo.new(0.2),{
					Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
				}):Play();

				Config.Default = v;
				ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));

				if not IsSame then
					Config.Callback(v);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."Slider",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			Frame = Slider,
			Destroy = function()
				pcall(function()
					Slider:Destroy();
				end);
			end,
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Slider"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddButton(Config: Button)
		Config = Config or {};
		Config.Name = Config.Name or "Slider";
		Config.Risky = Config.Risky or false;
		Config.Callback = Config.Callback or function() end;

		local Button = Instance.new("Frame")
		local Button_Name = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Button.Name = Fatality:RandomString()
		Button.Parent = Parent
		Button.BackgroundColor3 = Fatality.Colors.Black
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Size = UDim2.new(1, -25, 0, 25)
		Button.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Button);

		Button_Name.Name = Fatality:RandomString()
		Button_Name.Parent = Button
		Button_Name.AnchorPoint = Vector2.new(0, 0.5)
		Button_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Button_Name.BackgroundTransparency = 1.000
		Button_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button_Name.BorderSizePixel = 0
		Button_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Button_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Button_Name.ZIndex = ZIndex + 2
		Button_Name.FontFace = Fatality.FontSemiBold
		Button_Name.Text = Config.Name
		Button_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Button_Name.TextSize = 12.000
		Button_Name.TextTransparency = 0.400
		Fatality:ProtectText(Button_Name,Config.Name);

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = Button;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Button_Name,0.45,{
					TextTransparency = 0.4,
				})

				Fatality:CreateAnimation(Button,0.45,{
					BackgroundTransparency = 0,
				})
			else
				Fatality:CreateAnimation(Button_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(Button,0.45,{
					BackgroundTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		Fatality:CreateHover(Button,function(value)
			if value then
				Fatality:CreateAnimation(Button,0.45,{
					BackgroundColor3 = Color3.fromRGB(14, 14, 14)
				})
			else
				Fatality:CreateAnimation(Button,0.45,{
					BackgroundColor3 = Fatality.Colors.Black
				})
			end;
		end)

		Fatality:NewInput(Button,function()
			Config.Callback();
		end)

		return Fatality:CreateResponse({
			Rename = function(new_name)
				Button_Name.Text = new_name
				Fatality:ProtectText(Button_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			Fire = Config.Callback,
			Frame = Button,
			Destroy = function()
				pcall(function()
					Button:Destroy();
				end);
			end,
		})
	end;

	function elements:AddColorPicker(Config: ColorPicker)
		Config = Config or {};
		Config.Name = Config.Name or "Color Picker";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or Color3.fromRGB(255, 255, 255);
		Config.Callback = Config.Callback or function(number) end;
		Config.Transparency = Config.Transparency or 0;
		Config.Flag = Config.Flag or nil;

		local ColorPicker = Instance.new("Frame")
		local ColorPicker_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		ColorPicker.Name = Fatality:RandomString()
		ColorPicker.Parent = Parent
		ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker.BackgroundTransparency = 1.000
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.Size = UDim2.new(1, -25, 0, 17)
		ColorPicker.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(ColorPicker);

		ColorPicker_Name.Name = Fatality:RandomString()
		ColorPicker_Name.Parent = ColorPicker
		ColorPicker_Name.AnchorPoint = Vector2.new(0, 0.5)
		ColorPicker_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker_Name.BackgroundTransparency = 1.000
		ColorPicker_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker_Name.BorderSizePixel = 0
		ColorPicker_Name.Position = UDim2.new(0, 0, 0.5, 0)
		ColorPicker_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		ColorPicker_Name.ZIndex = ZIndex + 2
		ColorPicker_Name.FontFace = Fatality.FontSemiBold
		ColorPicker_Name.Text = Config.Name
		ColorPicker_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker_Name.TextSize = 13.000
		ColorPicker_Name.TextTransparency = 0.200
		ColorPicker_Name.TextXAlignment = Enum.TextXAlignment.Left
		ColorPicker_Name.ZIndex = ZIndex + 2

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = ColorPicker
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Config.Default
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 35, 0.699999988, 0)
		ValueFrame.ZIndex = ZIndex + 3

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 7;

		local res = Fatality:CreateColorPicker(ValueFrame,Config.Transparency,function(rgb,opc)
			ValueFrame.BackgroundColor3 = rgb;
			ValueFrame.BackgroundTransparency = opc;

			task.spawn(Config.Callback,rgb,opc)
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(ColorPicker_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					Size = UDim2.new(0, 35, 0.7, 0)
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				Fatality:CreateAnimation(ColorPicker_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					Size = UDim2.new(0, 35, 0, 0)
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				ColorPicker.Text = new_name
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(rgb,opc)
				local IsSame = ValueFrame.BackgroundColor3 == rgb or ValueFrame.BackgroundTransparency == opc;

				ValueFrame.BackgroundColor3 = rgb; 
				ValueFrame.BackgroundTransparency = opc;
				res.set_opc(opc);

				if not IsSame then
					task.spawn(Config.Callback,rgb,opc)
				end;
			end,
			GetValue = function()
				return {
					Color = ValueFrame.BackgroundColor3,
					Transparency = ValueFrame.BackgroundTransparency
				};
			end,
			Flag = Config.Flag and Config.Flag.."ColorPicker",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			Frame = ColorPicker,
			Destroy = function()
				pcall(function()
					ColorPicker:Destroy();
				end);
			end,
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."ColorPicker"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddDropdown(Config: Dropdown)
		Config = Config or {};
		Config.Name = Config.Name or "Dropdown";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;
		Config.Values = Config.Values or {};
		Config.Multi = Config.Multi or false;

		local DataParser = function(value)
			if not value then return 'None'; end;

			local Out;

			if typeof(value) == 'table' then
				if #value > 0 then
					local x = {};

					for i,v in next , value do
						table.insert(x , tostring(v))
					end;

					Out = table.concat(x,' , ');
				else
					local x = {};

					for i,v in next , value do
						if v == true then
							table.insert(x , tostring(i));
						end			
					end;

					Out = table.concat(x,' , ');
				end;
			else
				Out = tostring(value);
			end;

			return Out;
		end;

		local Dropdown = Instance.new("Frame")
		local Dropdown_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local icon = Instance.new("ImageLabel")
		local Value_Text = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Dropdown.Name = Fatality:RandomString()
		Dropdown.Parent = Parent
		Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown.BackgroundTransparency = 1.000
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.Size = UDim2.new(1, -25, 0, 17)
		Dropdown.ZIndex = ZIndex + 3
		Fatality:AddDragBlacklist(Dropdown);

		Dropdown_Name.Name = Fatality:RandomString()
		Dropdown_Name.Parent = Dropdown
		Dropdown_Name.AnchorPoint = Vector2.new(0, 0.5)
		Dropdown_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown_Name.BackgroundTransparency = 1.000
		Dropdown_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown_Name.BorderSizePixel = 0
		Dropdown_Name.Position = UDim2.new(0, 0, 0, 8)
		Dropdown_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Dropdown_Name.ZIndex = 7
		Dropdown_Name.FontFace = Fatality.FontSemiBold
		Dropdown_Name.Text = Config.Name
		Dropdown_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown_Name.TextSize = 13.000
		Dropdown_Name.TextTransparency = 0.200
		Dropdown_Name.TextXAlignment = Enum.TextXAlignment.Left
		Dropdown_Name.ZIndex = ZIndex + 4
		Fatality:ProtectText(Dropdown_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Dropdown
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.925000012, 0)
		ValueFrame.ZIndex = ZIndex + 4

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0, 7)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 8
		OptionButton.Visible = Config.Option;

		icon.Name = Fatality:RandomString()
		icon.Parent = ValueFrame
		icon.AnchorPoint = Vector2.new(1, 0)
		icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		icon.BackgroundTransparency = 1.000
		icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		icon.BorderSizePixel = 0
		icon.Position = UDim2.new(1, 0, 0, 0)
		icon.Size = UDim2.new(0,15,0,15)
		icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		icon.ZIndex = ZIndex + 5
		Fatality:SetIcon(icon, "chevron-down")

		Value_Text.Name = Fatality:RandomString()
		Value_Text.Parent = ValueFrame
		Value_Text.AnchorPoint = Vector2.new(0, 0.5)
		Value_Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Value_Text.BackgroundTransparency = 1.000
		Value_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value_Text.BorderSizePixel = 0
		Value_Text.Position = UDim2.new(0, 3, 0.5, 0)
		Value_Text.Size = UDim2.new(1, -18, 0.800000012, 0)
		Value_Text.ZIndex = ZIndex + 5
		Value_Text.FontFace = Fatality.FontSemiBold
		Value_Text.Text = DataParser(Config.Default)
		Value_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
		Value_Text.TextSize = 10.000
		Value_Text.TextTransparency = 0.500
		Value_Text.TextXAlignment = Enum.TextXAlignment.Left
		Value_Text.TextYAlignment = Enum.TextYAlignment.Top
		Value_Text.TextWrapped = true
		Value_Text.TextTruncate = Enum.TextTruncate.SplitWord

		local res;
		res = Fatality:CreateDropdown(ValueFrame,Config.Default,Config.Multi,Config.AutoUpdate,function(args)
			Config.Default = args;
			Value_Text.Text = DataParser(Config.Default);

			res:change_default(Config.Default);

			Config.Callback(args);
		end);

		res:set_data(Config.Values);
		res:refresh();

		res:on_toggle(function(b)
			if b then
				Fatality:CreateAnimation(icon,0.35,{
					Rotation = -180,
					ImageColor3 = Fatality.Colors.Main
				})
			else
				Fatality:CreateAnimation(icon,0.35,{
					Rotation = 0,
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				})
			end;
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Dropdown_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(icon,0.45,{
					ImageTransparency = 0
				})

				Fatality:CreateAnimation(Value_Text,0.45,{
					TextTransparency = 0.5
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				Fatality:CreateAnimation(Dropdown_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(icon,0.45,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(Value_Text,0.45,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Dropdown_Name.Text = new_name
				Fatality:ProtectText(Dropdown_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)

				Config.Default = def;
				Value_Text.Text = DataParser(Config.Default);
				res:change_default(Config.Default);
				res:update_visuals();

				Config.Callback(def);
			end,
			SetData = function(def)
				Config.Values = def;

				res:set_data(Config.Values);

				if not Config.AutoUpdate then
					res:refresh();
				end
			end,
			Flag = Config.Flag and Config.Flag.."Dropdown",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			Frame = Dropdown,
			Destroy = function()
				pcall(function()
					Dropdown:Destroy();
				end);
			end,
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Dropdown"] = Respons;
		end;

		return Respons;
	end;
	
	function elements:AddKeybind(Config: Keybind)
		Config = Config or {};
		Config.Name = Config.Name or "Keybind";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;

		local Keys = {
			One = '1',
			Two = '2',
			Three = '3',
			Four = '4',
			Five = '5',
			Six = '6',
			Seven = '7',
			Eight = '8',
			Nine = '9',
			Zero = '0',
			['Minus'] = "-",
			['Plus'] = "+",
			BackSlash = "\\",
			Slash = "/",
			Period = '.',
			Semicolon = ';',
			Colon = ":",
			LeftControl = "LCtrl",
			RightControl = "RCtrl",
			LeftShift = "LShift",
			RightShift = "RShift",
			Return = "Enter",
			LeftBracket = "[",
			RightBracket = "]",
			Quote = "'",
			Comma = ",",
			Equals = "=",
			LeftSuper = "Super",
			RightSuper = "Super"
		};

		local GetItem = function(item)
			if item then
				if typeof(item) == 'EnumItem' then
					return Keys[item.Name] or item.Name;
				else
					return Keys[tostring(item)] or tostring(item);
				end;
			else
				return 'None';
			end;
		end;

		local Keybind = Instance.new("Frame")
		local Keybind_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Keybind.Name = Fatality:RandomString()
		Keybind.Parent = Parent
		Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Keybind.BackgroundTransparency = 1.000
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.Size = UDim2.new(1, -25, 0, 17)
		Keybind.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Keybind);

		Keybind_Name.Name = Fatality:RandomString()
		Keybind_Name.Parent = Keybind
		Keybind_Name.AnchorPoint = Vector2.new(0, 0.5)
		Keybind_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Keybind_Name.BackgroundTransparency = 1.000
		Keybind_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind_Name.BorderSizePixel = 0
		Keybind_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Keybind_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Keybind_Name.ZIndex = ZIndex + 2
		Keybind_Name.FontFace = Fatality.FontSemiBold
		Keybind_Name.Text = Config.Name
		Keybind_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		Keybind_Name.TextSize = 13.000
		Keybind_Name.TextTransparency = 0.200
		Keybind_Name.TextXAlignment = Enum.TextXAlignment.Left
		Fatality:ProtectText(Keybind_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Keybind
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.850000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option or false;

		ValueText.Name = Fatality:RandomString()
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 3
		ValueText.FontFace = Fatality.FontSemiBold
		ValueText.Text = GetItem(Config.Default)
		ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850
		ValueText.TextTransparency = 0.400

		local IsBinding = false;
		Fatality:NewInput(ValueFrame,function()
			if IsBinding then
				return;
			end;

			ValueText.Text = "...";

			local Selected = nil;
			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 then
						Selected = "MouseLeft";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then
						Selected = "MouseRight";
					end;
				end;
			end;

			Config.Default = Selected;

			ValueText.Text = GetItem(Selected);

			IsBinding = false;

			Config.Callback(typeof(Selected) == "string" and Selected or Selected.Name);
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Keybind_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0.400
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				Fatality:CreateAnimation(Keybind_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Keybind_Name.Text = new_name
				Fatality:ProtectText(Keybind_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)
				local IsSame = Config.Default == def;

				Config.Default = def;
				ValueText.Text = GetItem(Config.Default);

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."Keybind",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			Frame = Keybind,
			Destroy = function()
				pcall(function()
					Keybind:Destroy();
				end);
			end,
		});

		if Config.Flag then

			Fatality.WindowFlags[FatalWindow][Config.Flag.."Keybind"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddIntInput(Config: IntInput)
		Config = Config or {};
		Config.Name = Config.Name or "IntInput";
		Config.Default = Config.Default or 0;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(val) end;
		Config.Flag = Config.Flag or nil;

		local function sanitize(val)
			local n = tonumber(val);
			if not n then return Config.Default; end;
			n = math.round(n);
			if Config.Min and n < Config.Min then n = Config.Min; end;
			if Config.Max and n > Config.Max then n = Config.Max; end;
			return n;
		end;

		Config.Default = sanitize(Config.Default);

		local IntInput = Instance.new("Frame")
		local IntInput_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local TextBox = Instance.new("TextBox")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		IntInput.Name = Fatality:RandomString()
		IntInput.Parent = Parent
		IntInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		IntInput.BackgroundTransparency = 1.000
		IntInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		IntInput.BorderSizePixel = 0
		IntInput.Size = UDim2.new(1, -25, 0, 17)
		IntInput.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(IntInput);

		IntInput_Name.Name = Fatality:RandomString()
		IntInput_Name.Parent = IntInput
		IntInput_Name.AnchorPoint = Vector2.new(0, 0.5)
		IntInput_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		IntInput_Name.BackgroundTransparency = 1.000
		IntInput_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		IntInput_Name.BorderSizePixel = 0
		IntInput_Name.Position = UDim2.new(0, 0, 0.5, 0)
		IntInput_Name.Size = UDim2.new(1, (Config.Option and -95) or -75, 0.800000012, 0)
		IntInput_Name.ZIndex = ZIndex + 2
		IntInput_Name.FontFace = Fatality.FontSemiBold
		IntInput_Name.Text = Config.Name
		IntInput_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		IntInput_Name.TextSize = 13.000
		IntInput_Name.TextTransparency = 0.200
		IntInput_Name.TextXAlignment = Enum.TextXAlignment.Left
		IntInput_Name.TextTruncate = Enum.TextTruncate.AtEnd
		Fatality:ProtectText(IntInput_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = IntInput
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.ClipsDescendants = true
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.850000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option or false;
		OptionButton.ZIndex = ZIndex + 1;

		TextBox.Name = Fatality:RandomString()
		TextBox.Parent = ValueFrame
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -6, 1, 0)
		TextBox.ZIndex = ZIndex + 3
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = Fatality.FontSemiBold
		TextBox.PlaceholderText = tostring(Config.Placeholder or Config.Default)
		TextBox.Text = tostring(Config.Default)
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 10.000
		TextBox.TextStrokeTransparency = 0.850
		TextBox.TextTransparency = 0.200
		TextBox.TextXAlignment = Enum.TextXAlignment.Center

		TextBox:GetPropertyChangedSignal("Text"):Connect(function()
			local txt = TextBox.Text;
			if txt == "" or txt == "-" then return; end;
			local filtered = txt:gsub("[^%-%d]", "");
			if filtered:sub(1, 1) == "-" then
				filtered = "-" .. filtered:sub(2):gsub("%-", "");
			else
				filtered = filtered:gsub("%-", "");
			end;
			if filtered ~= txt then
				TextBox.Text = filtered;
			end;
		end);

		TextBox.FocusLost:Connect(function()
			local val = sanitize(TextBox.Text);
			local isSame = Config.Default == val;
			Config.Default = val;
			TextBox.Text = tostring(val);
			if not isSame then
				Config.Callback(val);
			end;
		end);

		local OpcToggle = function(value)
			if value then
				TextBox.Visible = true
				Fatality:CreateAnimation(IntInput_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(TextBox,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0.200
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				TextBox.Visible = false
				Fatality:CreateAnimation(IntInput_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(TextBox,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				IntInput_Name.Text = new_name
				Fatality:ProtectText(IntInput_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)
				local val = sanitize(def);
				local IsSame = Config.Default == val;

				Config.Default = val;
				TextBox.Text = tostring(val);

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."IntInput",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil,
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."IntInput"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddTextInput(Config: TextInput)
		Config = Config or {};
		Config.Name = Config.Name or "TextInput";
		Config.Default = (type(Config.Default) == "string" and Config.Default) or "";
		Config.Placeholder = Config.Placeholder or Config.Default;
		Config.MaxLength = Config.MaxLength or 32;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(val) end;
		Config.Flag = Config.Flag or nil;

		local function sanitize(val)
			local s = tostring(val or "");
			if #s > Config.MaxLength then s = s:sub(1, Config.MaxLength); end;
			return s;
		end;

		Config.Default = sanitize(Config.Default);

		local TextInput = Instance.new("Frame")
		local TextInput_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local TextBox = Instance.new("TextBox")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		TextInput.Name = Fatality:RandomString()
		TextInput.Parent = Parent
		TextInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextInput.BackgroundTransparency = 1.000
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.Size = UDim2.new(1, -25, 0, 17)
		TextInput.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(TextInput);

		TextInput_Name.Name = Fatality:RandomString()
		TextInput_Name.Parent = TextInput
		TextInput_Name.AnchorPoint = Vector2.new(0, 0.5)
		TextInput_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextInput_Name.BackgroundTransparency = 1.000
		TextInput_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput_Name.BorderSizePixel = 0
		TextInput_Name.Position = UDim2.new(0, 0, 0.5, 0)
		TextInput_Name.Size = UDim2.new(1, (Config.Option and -95) or -75, 0.800000012, 0)
		TextInput_Name.ZIndex = ZIndex + 2
		TextInput_Name.FontFace = Fatality.FontSemiBold
		TextInput_Name.Text = Config.Name
		TextInput_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		TextInput_Name.TextSize = 13.000
		TextInput_Name.TextTransparency = 0.200
		TextInput_Name.TextXAlignment = Enum.TextXAlignment.Left
		TextInput_Name.TextTruncate = Enum.TextTruncate.AtEnd
		Fatality:ProtectText(TextInput_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = TextInput
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.ClipsDescendants = true
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.850000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option or false;
		OptionButton.ZIndex = ZIndex + 1;

		TextBox.Name = Fatality:RandomString()
		TextBox.Parent = ValueFrame
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -6, 1, 0)
		TextBox.ZIndex = ZIndex + 3
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = Fatality.FontSemiBold
		TextBox.PlaceholderText = tostring(Config.Placeholder or Config.Default)
		TextBox.Text = tostring(Config.Default)
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 10.000
		TextBox.TextStrokeTransparency = 0.850
		TextBox.TextTransparency = 0.200
		TextBox.TextXAlignment = Enum.TextXAlignment.Center

		TextBox:GetPropertyChangedSignal("Text"):Connect(function()
			local txt = TextBox.Text;
			if #txt > Config.MaxLength then
				TextBox.Text = txt:sub(1, Config.MaxLength);
			end;
		end);

		local function commit()
			local val = sanitize(TextBox.Text);
			if val == "" then
				TextBox.Text = tostring(Config.Default);
				return;
			end;
			local isSame = Config.Default == val;
			Config.Default = val;
			TextBox.Text = val;
			if not isSame then
				Config.Callback(val);
			end;
		end;

		TextBox.FocusLost:Connect(function()
			commit();
		end);

		local OpcToggle = function(value)
			if value then
				TextBox.Visible = true
				Fatality:CreateAnimation(TextInput_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(TextBox,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0.200
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				TextBox.Visible = false
				Fatality:CreateAnimation(TextInput_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(TextBox,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				TextInput_Name.Text = new_name
				Fatality:ProtectText(TextInput_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)
				local val = sanitize(def);
				if val == "" then return; end;
				local IsSame = Config.Default == val;

				Config.Default = val;
				TextBox.Text = val;

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."TextInput",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil,
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."TextInput"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddLabel(Config: Label)
		Config = Config or {};
		Config.Text = Config.Text or Config.Name or "Label";
		Config.Size = Config.Size or 12;
		Config.Color = Config.Color or Color3.fromRGB(255, 255, 255);
		Config.Flag = Config.Flag or nil;

		local Label = Instance.new("Frame")
		local Label_Text = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(tostring(Config.Text):sub(1, 24));
		end;

		Label.Name = Fatality:RandomString()
		Label.Parent = Parent
		Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Label.BackgroundTransparency = 1.000
		Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label.BorderSizePixel = 0
		Label.Size = UDim2.new(1, -25, 0, 15)
		Label.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Label);

		Label_Text.Name = Fatality:RandomString()
		Label_Text.Parent = Label
		Label_Text.AnchorPoint = Vector2.new(0, 0.5)
		Label_Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Label_Text.BackgroundTransparency = 1.000
		Label_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label_Text.BorderSizePixel = 0
		Label_Text.Position = UDim2.new(0, 0, 0.5, 0)
		Label_Text.Size = UDim2.new(1, 0, 1, 0)
		Label_Text.ZIndex = ZIndex + 2
		Label_Text.FontFace = Fatality.FontSemiBold
		Label_Text.TextColor3 = Config.Color
		Label_Text.TextSize = Config.Size
		Label_Text.TextTransparency = 0.200
		Label_Text.TextXAlignment = Enum.TextXAlignment.Left
		Label_Text.TextTruncate = Enum.TextTruncate.AtEnd
		Fatality:ProtectText(Label_Text,Config.Text);

		local OpcToggle = function(value)
			if value then
				Label_Text.Visible = true
				Fatality:CreateAnimation(Label_Text,0.45,{
					TextTransparency = 0.2,
				})
			else
				Label_Text.Visible = false
				Fatality:CreateAnimation(Label_Text,0.45,{
					TextTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			SetText = function(txt)
				Config.Text = tostring(txt);
				Label_Text.Text = tostring(txt);
				Fatality:ProtectText(Label_Text,tostring(txt));
			end,
			GetValue = function()
				return Config.Text;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			Flag = Config.Flag and Config.Flag.."Label",
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Label"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddPreview(Config: Preview)
		Config = Config or {};
		Config.Name = Config.Name or "Preview";
		Config.Height = Config.Height or 240;
		Config.Flag = Config.Flag or nil;
		Config.Provider = Config.Provider or function()
			return {};
		end;
		local runElevated = Config.Elevate;
		if type(runElevated) ~= "function" then
			runElevated = function(fn)
				return pcall(fn);
			end;
		end;

		local Box = Instance.new("Frame")
		local BoxCorner = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local View = Instance.new("ViewportFrame")
		local Placeholder = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Box.Name = Fatality:RandomString()
		Box.Parent = Parent
		Box.BackgroundColor3 = Fatality.Colors.Black
		Box.BackgroundTransparency = 0.300
		Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Box.BorderSizePixel = 0
		Box.Size = UDim2.new(1, -4, 0, Config.Height)
		Box.ZIndex = ZIndex + 1
		Box.ClipsDescendants = true
		Fatality:AddDragBlacklist(Box);

		BoxCorner.CornerRadius = UDim.new(0, 3)
		BoxCorner.Parent = Box

		Title.Name = Fatality:RandomString()
		Title.Parent = Box
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0, 8, 0, 2)
		Title.Size = UDim2.new(1, -16, 0, 14)
		Title.ZIndex = ZIndex + 4
		Title.FontFace = Fatality.FontSemiBold
		Title.Text = Config.Name
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 12.000
		Title.TextTransparency = 0.400
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Fatality:ProtectText(Title,Config.Name);

		View.Name = Fatality:RandomString()
		View.Parent = Box
		View.BackgroundTransparency = 1.000
		View.BorderSizePixel = 0
		View.Position = UDim2.new(0, 1, 0, 20)
		View.Size = UDim2.new(1, -2, 1, -26)
		View.ZIndex = ZIndex + 2

		local World = Instance.new("WorldModel")
		World.Parent = View

		Placeholder.Name = Fatality:RandomString()
		Placeholder.Parent = View
		Placeholder.AnchorPoint = Vector2.new(0.5, 0.5)
		Placeholder.BackgroundTransparency = 1.000
		Placeholder.Position = UDim2.new(0.5, 0, 0.5, 0)
		Placeholder.Size = UDim2.new(1, -20, 0, 16)
		Placeholder.ZIndex = ZIndex + 4
		Placeholder.FontFace = Fatality.FontSemiBold
		Placeholder.Text = "No character"
		Placeholder.TextColor3 = Color3.fromRGB(255, 255, 255)
		Placeholder.TextSize = 12.000
		Placeholder.TextTransparency = 0.500
		Placeholder.Visible = false

		local vCam = Instance.new("Camera")
		vCam.FieldOfView = 60
		vCam.CFrame = CFrame.new(Vector3.new(0, 2.5, 10.5), Vector3.new(0, 0, 0))
		pcall(function()
			vCam.Parent = View
		end)
		View.CurrentCamera = vCam

		local characterClone = nil;
		local charAddedConn = nil;
		local wantRotate = true;
		local rotConn = nil;
		local previewData = {};
		local lastTheta = 0;
		-- Draw at 30Hz (camera orbit stays 60Hz): halves the ~400 projection
		-- allocs per frame in this menu widget, invisible at 0.9 rad/s.
		local drawAlt = false;
		-- Perf: clone hierarchy never changes after cloning, so scan it once
		-- (instead of GetDescendants() every frame). Bone refs + label text
		-- are cached the same way; frameSize avoids an AbsoluteSize read per
		-- projected corner.
		local cloneParts = nil;
		local cloneBones = {};
		local frameSize = Vector2.new(0, 0);
		local lastTxt = setmetatable({}, { __mode = "k" });

		local function updateViewport(char)
			if not char then
				if characterClone then
					pcall(function()
						characterClone:Destroy()
					end)
				end;
				characterClone = nil;
				cloneParts = nil;
				cloneBones = {};
				Placeholder.Visible = true;
				return;
			end;
			if characterClone then
				pcall(function()
					characterClone:Destroy()
				end)
				characterClone = nil;
			end;
			cloneParts = nil;
			cloneBones = {};
			pcall(function()
				char:WaitForChild("HumanoidRootPart", 5)
			end);
			pcall(function()
				char.Archivable = true
			end);
			local ok, clone = pcall(function()
				return char:Clone()
			end);
			if not ok or not clone then
				Placeholder.Visible = true;
				return;
			end;
			pcall(function()
				clone.Parent = World
			end);
			if clone.Parent ~= World then
				pcall(function()
					clone:Destroy()
				end);
				Placeholder.Visible = true;
				return;
			end;
			characterClone = clone;
			-- One-time hierarchy scan: box projection + skeleton reuse this.
			pcall(function()
				local acc = {};
				for _, d in ipairs(clone:GetDescendants()) do
					local okP = false;
					pcall(function() okP = d:IsA("BasePart") end);
					if okP then
						local inAcc = false;
						pcall(function() inAcc = d:FindFirstAncestorOfClass("Accessory") ~= nil end);
						if not inAcc then
							table.insert(acc, d);
						end;
					end;
				end;
				cloneParts = acc;
			end);
			local hrp = characterClone:FindFirstChild("HumanoidRootPart")
			if hrp then
				pcall(function()
					hrp.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0)
				end);
				pcall(function()
					vCam.CFrame = CFrame.new(Vector3.new(0, 2.5, 10.5), hrp.Position)
				end);
				Placeholder.Visible = false;
			else
				Placeholder.Visible = true;
			end;
		end;

		local function mkEdge()
			local f = Instance.new("Frame")
			f.BorderSizePixel = 0
			f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			f.Visible = false
			f.ZIndex = ZIndex + 4
			f.Parent = View
			return f
		end;

		local edgeT, edgeB, edgeL, edgeR = mkEdge(), mkEdge(), mkEdge(), mkEdge();
		local outT, outB, outL, outR = mkEdge(), mkEdge(), mkEdge(), mkEdge();
		outT.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		outB.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		outL.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		outR.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		local function mkGrad(parent, rotation)
			local gr = Instance.new("UIGradient")
			gr.Rotation = rotation or 0
			gr.Enabled = false
			gr.Parent = parent
			return gr
		end;
		local gradL, gradR = mkGrad(edgeL, 90), mkGrad(edgeR, 90);
		local hbBg, hbFill = mkEdge(), mkEdge();
		hbBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
		local gradH = mkGrad(hbFill, 90);
		local ammoBg, ammoFill = mkEdge(), mkEdge();
		ammoBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
		local gradA = mkGrad(ammoFill, 0);

		local function mkTopLabel(h, ts)
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1.000
			l.AnchorPoint = Vector2.new(0.5, 1)
			l.Size = UDim2.new(1, -10, 0, h)
			l.ZIndex = ZIndex + 4
			l.Font = Enum.Font.GothamBold
			l.TextColor3 = Color3.fromRGB(255, 255, 255)
			l.TextSize = ts or 13.000
			l.TextStrokeTransparency = 0.500
			l.Visible = false
			l.Parent = View
			return l
		end;

		local function mkBottomLabel(h, ts)
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1.000
			l.AnchorPoint = Vector2.new(0.5, 0)
			l.Size = UDim2.new(1, -10, 0, h)
			l.ZIndex = ZIndex + 4
			l.Font = Enum.Font.GothamBold
			l.TextColor3 = Color3.fromRGB(255, 255, 255)
			l.TextSize = ts or 12.000
			l.TextStrokeTransparency = 0.500
			l.Visible = false
			l.Parent = View
			return l
		end;

		local nameL, subL = mkTopLabel(14, 13), mkTopLabel(13, 12);
		local itemL = mkBottomLabel(13, 12);

		-- === ESP-PREVIEW-SYNC: skeleton / arrow demo elements.
		-- Bone list mirrors H.Skeleton.BONES in ArchHook.lua; glyphs arrive
		-- via data.arrowGlyph (mirrors H.Arrow.GLYPHS). Provider fields come
		-- from the ESP preview data (search ESP-PREVIEW-SYNC in ArchHook.lua).
		local SKEL_BONES = {
			{ "Head", "UpperTorso" },
			{ "UpperTorso", "LowerTorso" },
			{ "UpperTorso", "LeftUpperArm" },
			{ "LeftUpperArm", "LeftLowerArm" },
			{ "LeftLowerArm", "LeftHand" },
			{ "UpperTorso", "RightUpperArm" },
			{ "RightUpperArm", "RightLowerArm" },
			{ "RightLowerArm", "RightHand" },
			{ "LowerTorso", "LeftUpperLeg" },
			{ "LeftUpperLeg", "LeftLowerLeg" },
			{ "LeftLowerLeg", "LeftFoot" },
			{ "LowerTorso", "RightUpperLeg" },
			{ "RightUpperLeg", "RightLowerLeg" },
			{ "RightLowerLeg", "RightFoot" },
		};
		local skelLines = {};
		for i = 1, #SKEL_BONES do
			skelLines[i] = mkEdge();
		end;
		local arrowL = Instance.new("TextLabel")
		arrowL.BackgroundTransparency = 1.000
		arrowL.AnchorPoint = Vector2.new(0.5, 0.5)
		arrowL.Size = UDim2.new(0, 60, 0, 60)
		arrowL.ZIndex = ZIndex + 4
		arrowL.Font = Enum.Font.GothamBlack
		arrowL.TextSize = 28.000
		arrowL.TextStrokeTransparency = 0.500
		arrowL.Visible = false
		arrowL.Parent = View
		local arrowDistL = Instance.new("TextLabel")
		arrowDistL.BackgroundTransparency = 1.000
		arrowDistL.AnchorPoint = Vector2.new(0.5, 0)
		arrowDistL.Size = UDim2.new(0, 80, 0, 14)
		arrowDistL.ZIndex = ZIndex + 4
		arrowDistL.Font = Enum.Font.GothamBold
		arrowDistL.TextSize = 12.000
		arrowDistL.TextStrokeTransparency = 0.500
		arrowDistL.Visible = false
		arrowDistL.Parent = View

		local infoLs = {};
		for i = 1, 7 do
			local fl = Instance.new("TextLabel")
			fl.BackgroundTransparency = 1.000
			fl.AnchorPoint = Vector2.new(0, 0)
			fl.Size = UDim2.fromOffset(160, 13)
			fl.ZIndex = ZIndex + 4
			fl.Font = Enum.Font.GothamBold
			fl.TextColor3 = Color3.fromRGB(255, 255, 255)
			fl.TextSize = 12.000
			fl.TextStrokeTransparency = 0.500
			fl.TextXAlignment = Enum.TextXAlignment.Left
			fl.Visible = false
			fl.Parent = View
			infoLs[i] = fl;
		end;

		local function hideOverlay()
			edgeT.Visible = false;
			edgeB.Visible = false;
			edgeL.Visible = false;
			edgeR.Visible = false;
			outT.Visible = false;
			outB.Visible = false;
			outL.Visible = false;
			outR.Visible = false;
			hbBg.Visible = false;
			hbFill.Visible = false;
			nameL.Visible = false;
			subL.Visible = false;
			itemL.Visible = false;
			ammoBg.Visible = false;
			ammoFill.Visible = false;
			for i = 1, 7 do
				infoLs[i].Visible = false;
			end;
			for i = 1, #skelLines do
				skelLines[i].Visible = false;
			end;
			arrowL.Visible = false;
			arrowDistL.Visible = false;
		end;

		local function colOf(v, fallback)
			if typeof(v) == "Color3" then
				return v;
			end;
			return fallback;
		end;

		-- === ESP-PREVIEW-SYNC: ViewportFrame has no engine projection for its
		-- camera, so project clone parts manually (vCam CFrame + FOV against
		-- the cached per-frame viewport size). Returns nil when behind camera.
		local function projectToView(worldPos)
			local ok, rel = pcall(function()
				return vCam.CFrame:PointToObjectSpace(worldPos)
			end);
			if not ok or not rel or rel.Z >= -0.01 then
				return nil;
			end;
			if frameSize.Y < 1 then
				return nil;
			end;
			local f = (frameSize.Y / 2) / math.tan(math.rad(vCam.FieldOfView) / 2);
			local inv = 1 / -rel.Z;
			return Vector2.new(frameSize.X / 2 + rel.X * inv * f, frameSize.Y / 2 - rel.Y * inv * f);
		end;

		local function setLine(f, ax, ay, bx, by, thick, color)
			local dx, dy = bx - ax, by - ay;
			local len = math.sqrt(dx * dx + dy * dy);
			if len < 0.5 then
				f.Visible = false;
				return;
			end;
			f.AnchorPoint = Vector2.new(0.5, 0.5);
			f.Position = UDim2.fromOffset((ax + bx) / 2, (ay + by) / 2);
			f.Size = UDim2.fromOffset(len, thick);
			f.Rotation = math.deg(math.atan2(dy, dx));
			f.BackgroundColor3 = color;
			f.Visible = true;
		end;

		local function getBone(idx, name)
			local rec = cloneBones[idx];
			if rec and rec.clone == characterClone then
				local rp = rec.part;
				local okR = false;
				pcall(function() okR = rp ~= nil and rp.Parent ~= nil end);
				if okR then
					return rp;
				end;
			end;
			local p = nil;
			pcall(function()
				if characterClone then
					p = characterClone:FindFirstChild(name);
				end;
			end);
			local okP = false;
			pcall(function() okP = p ~= nil and p:IsA("BasePart") end);
			if okP then
				cloneBones[idx] = { clone = characterClone, part = p };
				return p;
			end;
			cloneBones[idx] = nil;
			return nil;
		end;

		local function setTxt(l, txt, col)
			local k = lastTxt[l];
			if k == nil then
				k = {};
				lastTxt[l] = k;
			end;
			if k.t ~= txt then
				l.Text = txt;
				k.t = txt;
			end;
			if col ~= nil and k.c ~= col then
				l.TextColor3 = col;
				k.c = col;
			end;
		end;

		local function drawOverlay(hrp)
			local data = previewData or {};
			if data.showESP == false then
				hideOverlay();
				return;
			end;
			local vs = View.AbsoluteSize;
			if vs.X < 10 or vs.Y < 10 then
				hideOverlay();
				return;
			end;
			frameSize = vs;
			-- === ESP-PREVIEW-SYNC: box bounds mirror live H.ESP.GetBodyBounds
			-- exactly. Every non-accessory BasePart corner is projected through
			-- projectToView (the ViewportFrame equivalent of
			-- cam:WorldToViewportPoint), then the SAME pad/floor/clamp math as
			-- live runs (pad 2, min 4px, clamp to viewport). No fake width: as
			-- the clone rotates the box breathes exactly like the in-game box.
			local x0, y0, x1, y1 = nil, nil, nil, nil;
			-- Cached part list (built once in updateViewport): same parts a
			-- live scan would yield, without the per-frame hierarchy walk.
			local parts = cloneParts;
			if type(parts) ~= "table" or #parts == 0 then
				hideOverlay();
				return;
			end;
			for i = 1, #parts do
				local d = parts[i];
				local cf, hx, hy, hz = nil, nil, nil, nil;
				pcall(function()
					cf = d.CFrame;
					local s = d.Size;
					hx, hy, hz = s.X * 0.5, s.Y * 0.5, s.Z * 0.5;
				end);
				if cf and hx then
					for ax = -1, 1, 2 do
						for ay = -1, 1, 2 do
							for az = -1, 1, 2 do
								local wp = nil;
								pcall(function()
									wp = cf * Vector3.new(hx * ax, hy * ay, hz * az);
								end);
								if wp then
									local sp = projectToView(wp);
									if sp then
										if x0 == nil or sp.X < x0 then
											x0 = sp.X;
										end;
										if x1 == nil or sp.X > x1 then
											x1 = sp.X;
										end;
										if y0 == nil or sp.Y < y0 then
											y0 = sp.Y;
										end;
										if y1 == nil or sp.Y > y1 then
											y1 = sp.Y;
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
			if x0 == nil then
				hideOverlay();
				return;
			end;
			local pad = 2;
			local h = math.floor((y1 - y0) + pad * 2);
			if h < 4 then
				h = 4;
			end;
			local w = math.floor((x1 - x0) + pad * 2);
			if w < 4 then
				w = 4;
			end;
			if h > vs.Y then
				h = math.floor(vs.Y);
			end;
			if w > vs.X then
				w = math.floor(vs.X);
			end;
			local cx = (x0 + x1) / 2;
			local left = math.floor(cx - w / 2);
			local top = math.floor(y0 - pad);
			if data.showBox ~= false then
				local bt = 2
				outT.Position = UDim2.fromOffset(left - 1, top - 1);
				outT.Size = UDim2.fromOffset(w + 2, 1);
				outT.Visible = true;
				outB.Position = UDim2.fromOffset(left - 1, top + h);
				outB.Size = UDim2.fromOffset(w + 2, 1);
				outB.Visible = true;
				outL.Position = UDim2.fromOffset(left - 1, top - 1);
				outL.Size = UDim2.fromOffset(1, h + 2);
				outL.Visible = true;
				outR.Position = UDim2.fromOffset(left + w, top - 1);
				outR.Size = UDim2.fromOffset(1, h + 2);
				outR.Visible = true;
				edgeT.Position = UDim2.fromOffset(left, top);
				edgeT.Size = UDim2.fromOffset(w, bt);
				edgeT.Visible = true;
				edgeB.Position = UDim2.fromOffset(left, top + h - bt);
				edgeB.Size = UDim2.fromOffset(w, bt);
				edgeB.Visible = true;
				edgeL.Position = UDim2.fromOffset(left, top + bt);
				edgeL.Size = UDim2.fromOffset(bt, h - bt * 2);
				edgeL.Visible = true;
				edgeR.Position = UDim2.fromOffset(left + w - bt, top + bt);
				edgeR.Size = UDim2.fromOffset(bt, h - bt * 2);
				edgeR.Visible = true;
				local cT, cB;
				if data.boxStyle == "Gradient" then
					cT = colOf(data.boxTop, Color3.fromRGB(255, 60, 80));
					cB = colOf(data.boxBottom, Color3.fromRGB(255, 60, 80));
					local seq = ColorSequence.new({
						ColorSequenceKeypoint.new(0, cT),
						ColorSequenceKeypoint.new(1, cB),
					});
					gradL.Enabled = true;
					gradL.Color = seq;
					gradR.Enabled = true;
					gradR.Color = seq;
					edgeL.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					edgeR.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				else
					cT = colOf(data.boxColor, Color3.fromRGB(255, 60, 80));
					cB = cT;
					gradL.Enabled = false;
					gradR.Enabled = false;
					edgeL.BackgroundColor3 = cT;
					edgeR.BackgroundColor3 = cT;
				end;
				edgeT.BackgroundColor3 = cT;
				edgeB.BackgroundColor3 = cB;
			else
				edgeT.Visible = false;
				edgeB.Visible = false;
				edgeL.Visible = false;
				edgeR.Visible = false;
				outT.Visible = false;
				outB.Visible = false;
				outL.Visible = false;
				outR.Visible = false;
			end;
			-- Animated bars: ping-pong full -> empty -> full (4s each way).
			-- Health and ammo run 4s out of phase so both extremes are visible
			-- at once. Bar DRAWING below matches live H.StartESP exactly; only
			-- the pct source differs (live = Humanoid.Health / ammo count).
			local animH, animA = nil, nil;
			if data.animateBars ~= false then
				local function ping(offset)
					local c = (tick() + (offset or 0)) % 8;
					if c < 4 then
						return 1 - c / 4;
					end;
					return (c - 4) / 4;
				end;
				animH = ping(0);
				animA = ping(4);
			end;
			local pct = animH or tonumber(data.healthPct);
			if pct == nil then
				pct = 1;
			end;
			if pct < 0 then
				pct = 0;
			end;
			if pct > 1 then
				pct = 1;
			end;
			if data.showHealth ~= false then
				local hFull = colOf(data.healthFull, Color3.fromRGB(0, 255, 0));
				local hEmpty = colOf(data.healthEmpty, Color3.fromRGB(255, 0, 0));
				hbBg.Position = UDim2.fromOffset(left - 6, top);
				hbBg.Size = UDim2.fromOffset(3, h);
				hbBg.Visible = true;
				hbFill.Position = UDim2.fromOffset(left - 6, top + h * (1 - pct));
				hbFill.Size = UDim2.fromOffset(3, math.max(1, h * pct));
				hbFill.Visible = true;
				if data.healthStyle == "Gradient" then
					gradH.Enabled = true;
					gradH.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, hFull),
						ColorSequenceKeypoint.new(1, hEmpty),
					});
					hbFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				else
					gradH.Enabled = false;
					hbFill.BackgroundColor3 = colOf(data.healthColor, hEmpty:Lerp(hFull, pct));
				end;
			else
				hbBg.Visible = false;
				hbFill.Visible = false;
			end;
			local showN = data.showName ~= false;
			local showS = data.showSub ~= false;
			if showN and showS then
				nameL.Position = UDim2.fromOffset(cx, top - 15);
				setTxt(nameL, tostring(data.name or ""), colOf(data.nameColor, Color3.fromRGB(255, 255, 255)));
				nameL.Visible = true;
				subL.Position = UDim2.fromOffset(cx, top - 2);
				setTxt(subL, tostring(data.sub or ""), colOf(data.subColor, Color3.fromRGB(200, 200, 200)));
				subL.Visible = true;
			elseif showN then
				nameL.Position = UDim2.fromOffset(cx, top - 2);
				setTxt(nameL, tostring(data.name or ""), colOf(data.nameColor, Color3.fromRGB(255, 255, 255)));
				nameL.Visible = true;
				subL.Visible = false;
			elseif showS then
				nameL.Visible = false;
				subL.Position = UDim2.fromOffset(cx, top - 2);
				setTxt(subL, tostring(data.sub or ""), colOf(data.subColor, Color3.fromRGB(200, 200, 200)));
				subL.Visible = true;
			else
				nameL.Visible = false;
				subL.Visible = false;
			end;
			local by = top + h + 2;
			if data.showItem then
				itemL.Position = UDim2.fromOffset(cx, by);
				setTxt(itemL, tostring(data.itemText or ""), colOf(data.itemColor, Color3.fromRGB(255, 255, 255)));
				itemL.Visible = true;
				by = by + 13;
			else
				itemL.Visible = false;
			end;
			if data.showAmmo and tonumber(data.ammoMax) and tonumber(data.ammoMax) > 0 then
				local aPct = animA or tonumber(data.ammoPct);
				if aPct == nil then
					aPct = 1;
				end;
				if aPct < 0 then
					aPct = 0;
				end;
				if aPct > 1 then
					aPct = 1;
				end;
				ammoBg.Position = UDim2.fromOffset(left, by);
				ammoBg.Size = UDim2.fromOffset(w, 3);
				ammoBg.Visible = true;
				ammoFill.Position = UDim2.fromOffset(left, by);
				ammoFill.Size = UDim2.fromOffset(math.max(1, w * aPct), 3);
				ammoFill.Visible = true;
				if data.ammoStyle == "Gradient" then
					local aFull = colOf(data.ammoFull, Color3.fromRGB(0, 255, 0));
					local aEmpty = colOf(data.ammoEmpty, Color3.fromRGB(255, 0, 0));
					gradA.Enabled = true;
					gradA.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, aFull),
						ColorSequenceKeypoint.new(1, aEmpty),
					});
					ammoFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				else
					gradA.Enabled = false;
					ammoFill.BackgroundColor3 = colOf(data.ammoColor, Color3.fromRGB(255, 255, 255));
				end;
			else
				ammoBg.Visible = false;
				ammoFill.Visible = false;
			end;
			if data.showInfo ~= false and type(data.info) == "table" then
				-- LOW HP mirrors the live hpct <= 0.25 gate: hidden while the
				-- animated health bar is high (else bar + flag contradict).
				-- Kept when it is the ONLY row so the slot is never empty.
				local visible = {};
				for _, entry in ipairs(data.info) do
					if type(entry) == "table" and entry.text then
						local k = entry.key or tostring(entry.text);
						if k == "Low health" or entry.text == "LOW HP" then
							if pct <= 0.25 or #data.info == 1 then
								table.insert(visible, entry);
							end;
						else
							table.insert(visible, entry);
						end;
					end;
				end;
				for i = 1, 7 do
					local fl = infoLs[i];
					local entry = visible[i];
					if type(entry) == "table" and entry.text then
						fl.Position = UDim2.fromOffset(left + w + 5, top + (i - 1) * 13);
						setTxt(fl, tostring(entry.text), colOf(entry.color, Color3.fromRGB(255, 255, 255)));
						fl.Visible = true;
					else
						fl.Visible = false;
					end;
				end;
			else
				for i = 1, 7 do
					infoLs[i].Visible = false;
				end;
			end;
			-- === ESP-PREVIEW-SYNC: skeleton, drawn from the real clone-bone
			-- projection so thickness/color match the live H.Skeleton.Draw.
			if data.showSkeleton == true and characterClone and characterClone.Parent then
				local skCol = colOf(data.skeletonColor, Color3.fromRGB(255, 255, 255));
				local skThick = tonumber(data.skeletonThickness) or 1;
				if skThick < 1 then
					skThick = 1;
				end;
				if skThick > 6 then
					skThick = 6;
				end;
				for i, bone in ipairs(SKEL_BONES) do
					local f = skelLines[i];
					local a = getBone(i .. "a", bone[1]);
					local b = getBone(i .. "b", bone[2]);
					if a and b then
						local pa = projectToView(a.Position);
						local pb = projectToView(b.Position);
						if pa and pb then
							setLine(f, pa.X, pa.Y, pb.X, pb.Y, skThick, skCol);
						else
							f.Visible = false;
						end;
					else
						f.Visible = false;
					end;
				end;
			else
				for i = 1, #skelLines do
					skelLines[i].Visible = false;
				end;
			end;
			-- === ESP-PREVIEW-SYNC: offscreen arrow demo. The clone is always
			-- on-screen, so park a sample arrow at the configured radius
			-- pointing east; rotation mirrors live H.Arrow.Update math.
			if data.showArrow == true then
				local dirX, dirY = 1, 0;
				local radius = tonumber(data.arrowRadius) or 180;
				local maxR = math.min(vs.X, vs.Y) / 2 - 40;
				if maxR < 40 then
					maxR = 40;
				end;
				if radius > maxR then
					radius = maxR;
				end;
				if radius < 40 then
					radius = 40;
				end;
				local ax = vs.X / 2 + dirX * radius;
				local ay = vs.Y / 2 + dirY * radius;
				local style = tostring(data.arrowStyle or "Triangle");
				local rot = math.deg(math.atan2(dirY, dirX)) + 90;
				if style == "Diamond" then
					rot = 0;
				end;
				arrowL.Position = UDim2.fromOffset(ax, ay);
				setTxt(arrowL, tostring(data.arrowGlyph or "▲"), colOf(data.arrowColor, Color3.fromRGB(255, 60, 80)));
				arrowL.TextSize = tonumber(data.arrowSize) or 28;
				arrowL.Size = UDim2.new(0, arrowL.TextSize + 32, 0, arrowL.TextSize + 32);
				arrowL.Rotation = rot;
				arrowL.Visible = true;
				if data.arrowShowDistance ~= false then
					arrowDistL.Position = UDim2.fromOffset(ax, ay + 22);
					setTxt(arrowDistL, "87m", colOf(data.arrowColor, Color3.fromRGB(255, 60, 80)));
					arrowDistL.Visible = true;
				else
					arrowDistL.Visible = false;
				end;
			else
				arrowL.Visible = false;
				arrowDistL.Visible = false;
			end;
		end;

		pcall(function()
			local player = Players.LocalPlayer;
			if player then
				if player.Character then
					task.spawn(updateViewport, player.Character);
				else
					Placeholder.Visible = true;
				end;
				charAddedConn = player.CharacterAdded:Connect(updateViewport);
			else
				Placeholder.Visible = true;
			end;
		end);

		task.spawn(function()
			while Box.Parent do
				task.wait(0.15);
				runElevated(function()
					local data = Config.Provider() or {};
					if data.rotate == nil then
						wantRotate = true;
					else
						wantRotate = data.rotate ~= false;
					end;
					previewData = data;
				end);
			end;
		end);

		pcall(function()
			rotConn = RunService.RenderStepped:Connect(function()
				if not Box.Parent then
					return;
				end;
				if not characterClone or not characterClone.Parent then
					hideOverlay();
					return;
				end;
				local hrp = characterClone:FindFirstChild("HumanoidRootPart");
				if not hrp then
					hideOverlay();
					return;
				end;
				if wantRotate then
					local theta = tick() * 0.9;
					lastTheta = theta;
					pcall(function()
						vCam.CFrame = CFrame.new(hrp.Position + Vector3.new(math.sin(theta) * 10.5, 2.5, math.cos(theta) * 10.5), hrp.Position);
					end);
				else
					lastTheta = 0;
					pcall(function()
						vCam.CFrame = CFrame.new(Vector3.new(0, 2.5, 10.5), hrp.Position);
					end);
				end;
				drawAlt = not drawAlt;
				if drawAlt then
					drawOverlay(hrp);
				end;
			end);
		end);

		local OpcToggle = function(value)
			pcall(function()
				Box.Visible = value;
			end);
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Title.Text = new_name;
				Fatality:ProtectText(Title,new_name);
			end,
			Refresh = function()
				pcall(function()
					local player = Players.LocalPlayer;
					local char = player and player.Character;
					if char then
						task.spawn(updateViewport, char);
					end;
				end);
			end,
			GetValue = function()
				return {};
			end,
			Signal = Event.Event:Connect(OpcToggle),
			Flag = Config.Flag and Config.Flag.."Preview",
			Frame = Box,
			Destroy = function()
				pcall(function()
					if charAddedConn then
						charAddedConn:Disconnect()
					end;
				end);
				pcall(function()
					if rotConn then
						rotConn:Disconnect()
					end;
				end);
				pcall(function()
					Box:Destroy();
				end);
			end,
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Preview"] = Respons;
		end;

		return Respons;
	end;

	return elements;
end;

function Fatality:CreateConfigWindow(Root: ScreenGui , Fatal , Button: ImageButton)

	local ConfigWindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local UIListLayout = Instance.new("UIListLayout")
	local SpaceBox = Instance.new("Frame")
	local InputFrame = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_3 = Instance.new("UICorner")
	local TextBox = Instance.new("TextBox")
	local AddConfigButton = Instance.new("ImageButton")
	local UICorner_4 = Instance.new("UICorner")
	local GetConfigButton = Instance.new("ImageButton")
	local UICorner_5 = Instance.new("UICorner")
	local SaveConfigButton = Instance.new("ImageButton")
	local UICorner_6 = Instance.new("UICorner")
	local DeleteButton = Instance.new("ImageButton")
	local UICorner_7 = Instance.new("UICorner")

	Fatality:ScrollSignal(ScrollingFrame,UIListLayout,"Y");

	Fatality:AddDragBlacklist(ConfigWindowFrame);

	local UIToggle = false;
	local ElementToggle = function(value)
		UIToggle = value;

		if value then
			ConfigWindowFrame.Position = UDim2.fromOffset(Button.AbsolutePosition.X,Button.AbsolutePosition.Y + (Button.AbsoluteSize.Y * 3));

			Fatality:CreateAnimation(ConfigWindowFrame,0.3,{
				Size = UDim2.new(0, 185, 0, 195),
			})

			Fatality:CreateAnimation(UIStroke,0.3,{
				Transparency = 0
			})

			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 0.750
			})

			Fatality:CreateAnimation(ScrollingFrame,0.3,{
				BackgroundTransparency = 0
			})

			Fatality:CreateAnimation(UIStroke_2,0.3,{
				Transparency = 0.750
			})

			Fatality:CreateAnimation(UIStroke_3,0.3,{
				Transparency = 0.750
			})

			Fatality:CreateAnimation(SpaceBox,0.3,{
				BackgroundTransparency = 0
			})

			Fatality:CreateAnimation(InputFrame,0.3,{
				BackgroundTransparency = 0
			})

			Fatality:CreateAnimation(TextBox,0.3,{
				TextTransparency = 0.5
			})

			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0.2500
			})

			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 0.75
			})
		else
			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(ConfigWindowFrame,0.275,{
				Size = UDim2.new(0, 185, 0, 0),
			})

			Fatality:CreateAnimation(UIStroke,0.3,{
				Transparency = 1
			})

			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(ScrollingFrame,0.3,{
				BackgroundTransparency = 1
			})

			Fatality:CreateAnimation(UIStroke_2,0.3,{
				Transparency = 1
			})

			Fatality:CreateAnimation(UIStroke_3,0.3,{
				Transparency = 1
			})

			Fatality:CreateAnimation(SpaceBox,0.3,{
				BackgroundTransparency = 1
			})

			Fatality:CreateAnimation(InputFrame,0.3,{
				BackgroundTransparency = 1
			})

			Fatality:CreateAnimation(TextBox,0.3,{
				TextTransparency = 1
			})

			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 1
			})
		end;
	end;

	ElementToggle(false);

	ConfigWindowFrame.Name = "ConfigWindowFrame"
	ConfigWindowFrame.Parent = Root
	ConfigWindowFrame.AnchorPoint = Vector2.new(0,1)
	ConfigWindowFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ConfigWindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigWindowFrame.BorderSizePixel = 0
	ConfigWindowFrame.ClipsDescendants = true
	ConfigWindowFrame.Position = UDim2.new(2,0,2,0)
	ConfigWindowFrame.Size = UDim2.new(0, 185, 0, 0)
	ConfigWindowFrame.ZIndex = 205

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ConfigWindowFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ConfigWindowFrame

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = ConfigWindowFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 205
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = ConfigWindowFrame
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = Fatality.Colors.Black
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0, 8, 0, 8)
	ScrollingFrame.Size = UDim2.new(1, -40, 1, -45)
	ScrollingFrame.ZIndex = 207
	ScrollingFrame.ScrollBarThickness = 0

	UICorner_2.CornerRadius = UDim.new(0, 3)
	UICorner_2.Parent = ScrollingFrame

	UIStroke_2.Transparency = 0.750
	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_2.Parent = ScrollingFrame

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	SpaceBox.Name = "SpaceBox"
	SpaceBox.Parent = ScrollingFrame
	SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpaceBox.BorderSizePixel = 0
	SpaceBox.Size = UDim2.new(0, 0, 0, 1)

	InputFrame.Name = "InputFrame"
	InputFrame.Parent = ConfigWindowFrame
	InputFrame.AnchorPoint = Vector2.new(0, 1)
	InputFrame.BackgroundColor3 = Fatality.Colors.Black
	InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InputFrame.BorderSizePixel = 0
	InputFrame.Position = UDim2.new(0, 8, 1, -9)
	InputFrame.Size = UDim2.new(1, -40, 0, 22)
	InputFrame.ZIndex = 208

	UIStroke_3.Transparency = 0.750
	UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_3.Parent = InputFrame

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = InputFrame

	TextBox.Parent = InputFrame
	TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextBox.Size = UDim2.new(1, -10, 1, -1)
	TextBox.ZIndex = 209
	TextBox.FontFace = Fatality.FontSemiBold
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 10.000
	TextBox.TextTransparency = 0.500
	TextBox.TextXAlignment = Enum.TextXAlignment.Left

	AddConfigButton.Name = "AddConfigButton"
	AddConfigButton.Parent = InputFrame
	AddConfigButton.AnchorPoint = Vector2.new(0, 0.5)
	AddConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AddConfigButton.BackgroundTransparency = 1.000
	AddConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AddConfigButton.BorderSizePixel = 0
	AddConfigButton.Position = UDim2.new(1, 8, 0.5, 0)
	AddConfigButton.Size = UDim2.new(0, 15, 0, 15)
	AddConfigButton.ZIndex = 209
	Fatality:SetIcon(AddConfigButton, "circle-plus")
	AddConfigButton.ImageTransparency = 0.500

	UICorner_4.CornerRadius = UDim.new(1, 0)
	UICorner_4.Parent = AddConfigButton

	GetConfigButton.Name = "GetConfigButton"
	GetConfigButton.Parent = ConfigWindowFrame
	GetConfigButton.AnchorPoint = Vector2.new(1, 0)
	GetConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GetConfigButton.BackgroundTransparency = 1.000
	GetConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GetConfigButton.BorderSizePixel = 0
	GetConfigButton.Position = UDim2.new(1, -8, 0, 10)
	GetConfigButton.Size = UDim2.new(0, 15, 0, 15)
	GetConfigButton.ZIndex = 209
	Fatality:SetIcon(GetConfigButton, "folder-up")
	GetConfigButton.ImageTransparency = 0.500

	UICorner_5.CornerRadius = UDim.new(1, 0)
	UICorner_5.Parent = GetConfigButton

	SaveConfigButton.Name = "SaveConfigButton"
	SaveConfigButton.Parent = ConfigWindowFrame
	SaveConfigButton.AnchorPoint = Vector2.new(1, 0)
	SaveConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SaveConfigButton.BackgroundTransparency = 1.000
	SaveConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaveConfigButton.BorderSizePixel = 0
	SaveConfigButton.Position = UDim2.new(1, -8, 0, 28)
	SaveConfigButton.Size = UDim2.new(0, 15, 0, 15)
	SaveConfigButton.ZIndex = 209
	Fatality:SetIcon(SaveConfigButton, "save")
	SaveConfigButton.ImageTransparency = 0.500

	UICorner_6.CornerRadius = UDim.new(1, 0)
	UICorner_6.Parent = SaveConfigButton

	DeleteButton.Name = "DeleteButton"
	DeleteButton.Parent = ConfigWindowFrame
	DeleteButton.AnchorPoint = Vector2.new(1, 0)
	DeleteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DeleteButton.BackgroundTransparency = 1.000
	DeleteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DeleteButton.BorderSizePixel = 0
	DeleteButton.Position = UDim2.new(1, -8, 0, 55)
	DeleteButton.Size = UDim2.new(0, 15, 0, 15)
	DeleteButton.ZIndex = 209
	Fatality:SetIcon(DeleteButton, "trash")
	DeleteButton.ImageColor3 = Fatality.Colors.Main
	DeleteButton.ImageTransparency = 0.250

	UICorner_7.CornerRadius = UDim.new(1, 0)
	UICorner_7.Parent = DeleteButton

	Button.MouseButton1Click:Connect(function()
		ElementToggle(true);
	end);

	Fatality:CreateHover(DeleteButton,function(bool)
		if bool then
			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0;
			})
		else
			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0.35;
			})
		end;
	end);

	Fatality:CreateHover(SaveConfigButton,function(bool)
		if bool then
			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	Fatality:CreateHover(GetConfigButton,function(bool)
		if bool then
			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	Fatality:CreateHover(AddConfigButton,function(bool)
		if bool then
			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	UserInputService.InputBegan:Connect(function(Input,Typing)
		if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
			if UIToggle and not Fatality:IsMouseOverFrame(ConfigWindowFrame) then
				ElementToggle(false);
			end;
		end;
	end);

	local new_button = function()
		local db_selected = Instance.new("TextButton")

		db_selected.Name = Fatality:RandomString()
		db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		db_selected.BackgroundTransparency = 1.000
		db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
		db_selected.BorderSizePixel = 0
		db_selected.Size = UDim2.new(1, 0, 0, 10)
		db_selected.ZIndex = 220
		db_selected.FontFace = Fatality.FontSemiBold
		db_selected.TextColor3 = Color3.fromRGB(150, 150, 150)
		db_selected.TextSize = 12.000
		db_selected.TextXAlignment = Enum.TextXAlignment.Left

		return db_selected;
	end;

	local Configs = {};
	local import = {
		Name = nil,
		Element = nil;
	};

	local res;
	res = Fatality:CreateResponse({
		SetFiles = function(configs,bypass)
			local OldLen = #Configs;

			Configs = configs;

			if OldLen ~= #configs and not bypass then
				res:ReloadConfig();
			end;
		end,

		Refresh = function()
			for i,v in next , ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					v:Destroy();
				end;
			end;

			for i,v in next, Configs do
				local button = new_button();

				button.Parent = ScrollingFrame;
				button.Text = " "..tostring(v);

				if tostring(import.Name) == tostring(v) or import.Name == v then
					import.Element = button;
					import.Name = v;
					import.Element.TextColor3 = Fatality.Colors.Main;
					button.Text = "  "..tostring(v);
				end;

				button.MouseButton1Click:Connect(function()
					if import.Element then
						import.Element.TextColor3 = Color3.fromRGB(150, 150, 150);
						import.Element.Text = " "..import.Name;
					end;

					import.Element = button;
					import.Name = v;
					button.TextColor3 = Fatality.Colors.Main;
					button.Text = "  "..tostring(v);
				end);
			end;
		end,

		ReloadConfig = function()
			assert(res.ConfigDirectory , "Config directory not found");

			local files = {};

			for i,v in next , listfiles(res.ConfigDirectory) do
				local spl = (string.find(v,'/',1,true) and string.split(v,'/')) or (string.find(v,'\\',1,true) and string.split(v,'\\'));
				local name = spl[#spl];

				table.insert(files,name);
			end;

			res:SetFiles(files,true);
			res:Refresh();
		end,

		DeleteConfig = function(name)
			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			if isfile(path) then
				delfile(path)
			end;
		end,

		SaveConfig = function(name,content)
			if string.find(name,'/',1,true) or string.find(name,'\\',1,true) or string.find(name,':',1,true) then
				return;	
			end;

			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			writefile(path , content);
		end,

		LoadConfig = function(name)

			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			if isfile(path) then
				local decoded = svc('HttpService'):JSONDecode(readfile(path));

				Fatal.Notifier:Notify({
					Title = "Config",
					Content = "Loaded config '"..tostring(name).."'",
					Icon = "settings",
					Duration = 4,
				});

				Fatal:LoadConfig(decoded);
			end;
		end,

		Init = function(Name: string,Folder: string)
			if not isfolder(Folder or "Fatality") then
				makefolder(Folder or "Fatality");	
			end;

			if not isfolder((Folder or "Fatality").."/Config") then
				makefolder((Folder or "Fatality").."/Config");	
			end;

			local cfgPath = (Folder or "Fatality").."/Config/"..tostring(Name);

			if not isfolder(cfgPath) then
				makefolder(cfgPath)
			end;

			res.ConfigDirectory = cfgPath;

			AddConfigButton.MouseButton1Click:Connect(function()
				local configName = TextBox.Text;

				if not configName:byte() then return end;

				local flags = Fatal:GetFlagConfig();

				flags.Info = {
					Name = Name,
					Folder = Folder,
					ConfigName = configName,
				};

				local code = svc('HttpService'):JSONEncode(flags);

				res:SaveConfig(configName , code);
				res:ReloadConfig();

				Fatal.Notifier:Notify({
					Title = "Config",
					Content = "Saved config '"..tostring(configName).."'",
					Icon = "settings",
					Duration = 4,
				});

				TextBox.Text = "";
			end);

			GetConfigButton.MouseButton1Click:Connect(function()
				if import and import.Name then
					res:LoadConfig(import.Name);
				end;
			end);

			SaveConfigButton.MouseButton1Click:Connect(function()
				if import and import.Name then
					local flags = Fatal:GetFlagConfig();
					local configName = import.Name;

					flags.Info = {
						Name = Name,
						Folder = Folder,
						ConfigName = configName,
						Type = "Overwrite"
					};

					Fatal.Notifier:Notify({
						Title = "Config",
						Content = "Saved config '"..tostring(configName).."'",
						Icon = "settings",
						Duration = 4,
					});

					local code = svc('HttpService'):JSONEncode(flags);

					res:SaveConfig(configName , code);
					res:ReloadConfig();
				end;
			end);

			DeleteButton.MouseButton1Click:Connect(function()
				if import and import.Name then

					Fatal.Notifier:Notify({
						Title = "Config",
						Content = "Deleted config '"..tostring(import.Name).."'",
						Icon = "settings",
						Duration = 4,
					});

					res:DeleteConfig(import.Name);
					res:ReloadConfig();
				end;
			end)
		end,
	});

	return res;
end;

function Fatality.new(Window: Window)
	Window = Window or {};
	Window.Name = Window.Name or "FATALITY";
	Window.Scale = Window.Scale or UDim2.new(0, 750, 0, 500);
	Window.Keybind = Window.Keybind or "Insert";
	Window.Expire = Window.Expire or "never";

	local Fatal = {
		Menus = {},
		ElementContents = {},
		MenuSelected = nil,
		Toggle = true,
		Signal = Instance.new('BindableEvent');
	};
	local inputBegan1, inputBegan2;

	Fatal.Notifier = Fatality.__NOTIFIER_CACHE or Fatality:CreateNotifier();

	local Fatalitywin = Instance.new("ScreenGui")
	do
		local _shared = (typeof(getgenv) == "function" and getgenv()) or _G;
		_shared.__FatalityGuis = _shared.__FatalityGuis or {};
		for _, old in ipairs(_shared.__FatalityGuis) do
			pcall(function()
				if typeof(old) == "Instance" then
					old:Destroy();
				end;
			end);
		end;
		_shared.__FatalityGuis = { Fatalitywin };
	end;
	local FatalFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local DropShadow = Instance.new("ImageLabel")
	local Header = Instance.new("Frame")
	local HeaderLine = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local HeaderText = Instance.new("TextLabel")
	local MenuButtonCont = Instance.new("Frame")
	local tbc = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local UserProfle = Instance.new("Frame")
	local UserIcon = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local User_name = Instance.new("TextLabel")
	local expire_days = Instance.new("TextLabel")
	local HeaderLineShadow = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local MenuFrame = Instance.new("Frame")
	local Bottom = Instance.new("Frame")
	local HeaderLine_2 = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local HeaderLineShadow_2 = Instance.new("Frame")
	local UIGradient_2 = Instance.new("UIGradient")
	local UICorner_6 = Instance.new("UICorner")
	local InfoButton = Instance.new("ImageButton")
	local SearchButton = Instance.new("ImageButton")
	local SaveButton = Instance.new("ImageButton")

	Fatality.WindowFlags[Fatalitywin] = {};

	Fatality:ScrollSignal(tbc,UIListLayout,'X');

	FatalFrame:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
		if FatalFrame.BackgroundTransparency >= 0.99 then
			Fatalitywin.Enabled = false;
		else
			Fatalitywin.Enabled = true;
		end;
	end);

	game:GetService("RunService").RenderStepped:Connect(function()
		if Fatal.Toggle and Fatalitywin.Parent then
			pcall(function()
				local UIS = game:GetService("UserInputService");
				if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
					UIS.MouseBehavior = Enum.MouseBehavior.Default;
				end;
			end);
		end;
	end);

	if not Fatality:IsMobile() then
		local CursorRing = Instance.new("Frame");
		local CursorDot = Instance.new("Frame");
		local CursorStroke = Instance.new("UIStroke");
		local CursorCorner = Instance.new("UICorner");
		local DotCorner = Instance.new("UICorner");
		CursorRing.Name = Fatality:RandomString();
		CursorRing.Parent = Fatalitywin;
		CursorRing.AnchorPoint = Vector2.new(0.5, 0.5);
		CursorRing.BackgroundTransparency = 1.000;
		CursorRing.BorderSizePixel = 0;
		CursorRing.Position = UDim2.fromOffset(0, 0);
		CursorRing.Size = UDim2.fromOffset(22, 22);
		CursorRing.ZIndex = 5000;
		CursorRing.Active = false;
		CursorRing.Visible = false;
		CursorCorner.CornerRadius = UDim.new(1, 0);
		CursorCorner.Parent = CursorRing;
		CursorStroke.Color = Fatality.Colors.Main;
		CursorStroke.Thickness = 2;
		CursorStroke.Parent = CursorRing;
		CursorDot.Name = Fatality:RandomString();
		CursorDot.Parent = CursorRing;
		CursorDot.AnchorPoint = Vector2.new(0.5, 0.5);
		CursorDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		CursorDot.BorderSizePixel = 0;
		CursorDot.Position = UDim2.new(0.5, 0, 0.5, 0);
		CursorDot.Size = UDim2.fromOffset(5, 5);
		CursorDot.ZIndex = 5001;
		CursorDot.Active = false;
		DotCorner.CornerRadius = UDim.new(1, 0);
		DotCorner.Parent = CursorDot;
		local _cursorPos = nil;
		game:GetService("RunService").RenderStepped:Connect(function()
			if Fatal.Toggle and Fatalitywin.Parent then
				local ok, mp = pcall(function()
					return game:GetService("UserInputService"):GetMouseLocation();
				end);
				if ok and typeof(mp) == "Vector2" then
					if not _cursorPos then
						_cursorPos = mp;
					else
						_cursorPos = _cursorPos:Lerp(mp, 0.45);
					end;
					CursorRing.Position = UDim2.fromOffset(math.floor(_cursorPos.X), math.floor(_cursorPos.Y));
					CursorStroke.Color = Fatality.Colors.Main;
					CursorRing.Visible = true;
				end;
			elseif CursorRing.Visible then
				CursorRing.Visible = false;
			end;
		end);
	end;

	local ToggleUI = function(bool)
		Fatal.Signal:Fire(bool);
		pcall(function()
			local UIS = game:GetService("UserInputService");
			if bool then
				Fatal._SavedMouse = UIS.MouseBehavior;
				UIS.MouseBehavior = Enum.MouseBehavior.Default;
			elseif Fatal._SavedMouse ~= nil then
				UIS.MouseBehavior = Fatal._SavedMouse;
			end;
		end);

		if bool then
			for i,v in next , Fatal.Menus do
				v.ValueSelect(false);
			end;

			if Fatal.MenuSelected then
				Fatal.MenuSelected.ValueSelect(true)
			end

			Fatality:CreateAnimation(FatalFrame,0.15,{
				Size = Window.Scale,
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(Header,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(HeaderLine,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(Bottom,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(HeaderLine_2,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(HeaderLineShadow,0.5,{
				BackgroundTransparency = 0.5,
			})

			Fatality:CreateAnimation(HeaderLineShadow_2,0.5,{
				BackgroundTransparency = 0.5,
			})

			Fatality:CreateAnimation(InfoButton,0.25,{
				ImageTransparency = 0.5
			})

			Fatality:CreateAnimation(SearchButton,0.25,{
				ImageTransparency = 0.5
			})

			Fatality:CreateAnimation(SaveButton,0.25,{
				ImageTransparency = 0.5
			})

			Fatality:CreateAnimation(HeaderText,0.35,{
				TextStrokeTransparency = 0.640,
				TextTransparency = 0
			})

			Fatality:CreateAnimation(UserIcon,0.45,{
				ImageTransparency = 0,
				Position = UDim2.new(1, -10,0.5, 0)
			})

			Fatality:CreateAnimation(User_name,0.35,{
				TextTransparency = 0,
				Position = UDim2.new(1, -40,0, 3)
			})

			Fatality:CreateAnimation(expire_days,0.5,{
				TextTransparency = 0,
				Position = UDim2.new(1, -40,0, 16)
			})

			Fatality:CreateAnimation(UIStroke,0.35,{
				Thickness = 2.500,
				Transparency = 0.900
			})

			Fatality:CreateAnimation(InfoButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(1, -5,0.5, 0)
			})

			Fatality:CreateAnimation(SearchButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(0,10,0.5, 0)
			})

			Fatality:CreateAnimation(SaveButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(0,35,0.5, 0)
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 0.75
			})
		else
			table.clear(Fatality.DragBlacklist);

			for i,v in next , Fatal.Menus do
				v.ValueSelect(false);
			end;

			Fatality:CreateAnimation(SaveButton,0.35,{
				Position = UDim2.new(0,35,1, 20)
			})

			Fatality:CreateAnimation(SearchButton,0.35,{
				Position = UDim2.new(0,10,1, 20)
			})

			Fatality:CreateAnimation(InfoButton,0.35,{
				Position = UDim2.new(1, -5,1, 20)
			})

			Fatality:CreateAnimation(UIStroke,0.35,{
				Thickness = 0,
				Transparency = 1
			})

			Fatality:CreateAnimation(UserIcon,0.35,{
				ImageTransparency = 1,
				Position = UDim2.new(1, -10,0.5, 0)
			})

			Fatality:CreateAnimation(User_name,0.35,{
				TextTransparency = 1,
				Position = UDim2.new(1, -40,0, 3)
			})

			Fatality:CreateAnimation(expire_days,0.1,{
				TextTransparency = 1,
				Position = UDim2.new(1, -40,0, 16)
			})

			Fatality:CreateAnimation(HeaderText,0.35,{
				TextStrokeTransparency = 1,
				TextTransparency = 1
			})

			Fatality:CreateAnimation(HeaderLineShadow_2,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(InfoButton,0.35,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(SearchButton,0.35,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(SaveButton,0.35,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(HeaderLineShadow,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(FatalFrame,0.75,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(Header,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(HeaderLine,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(Bottom,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(HeaderLine_2,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 1
			})
		end
	end

	Fatalitywin.Name = Fatality:RandomString();
	Fatalitywin.Parent = CoreGui;
	Fatalitywin.ResetOnSpawn = false;
	Fatalitywin.IgnoreGuiInset = true;
	Fatalitywin.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	table.insert(Fatality.Windows,Fatalitywin)

	-- GUI protection crashes some executors: contain errors, and allow a full
	-- skip via getgenv().FATALITY_NO_PROTECT = true (see UITest.lua).
	do
		local skipProtect = false;
		pcall(function()
			local g = (typeof(getgenv) == "function" and getgenv()) or _G;
			skipProtect = g and rawget(g, "FATALITY_NO_PROTECT") == true;
		end);
		if not skipProtect then
			pcall(protect_gui, Fatalitywin);
		end;
	end;

	FatalFrame.Active = true;
	FatalFrame.Name = Fatality:RandomString()
	FatalFrame.Parent = Fatalitywin
	FatalFrame.AnchorPoint = Vector2.new(0.5, 0)
	FatalFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	FatalFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FatalFrame.BorderSizePixel = 0
	FatalFrame.Position = UDim2.new(0.5, 0, 0.2);
	FatalFrame.Size = Window.Scale;
	FatalFrame.ClipsDescendants = true

	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = FatalFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = FatalFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = -1
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 1
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.Rotation = 0.001

	Header.Name = Fatality:RandomString()
	Header.Parent = FatalFrame
	Header.Active = true
	Header.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0, 0, 40)
	Header.ZIndex = 2

	HeaderLine.Name = Fatality:RandomString()
	HeaderLine.Parent = Header
	HeaderLine.AnchorPoint = Vector2.new(0, 1)
	HeaderLine.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	HeaderLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine.BorderSizePixel = 0
	HeaderLine.Position = UDim2.new(0, 0, 1, 0)
	HeaderLine.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine.ZIndex = 3

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = Header

	HeaderText.Name = Fatality:RandomString()
	HeaderText.Parent = Header
	HeaderText.AnchorPoint = Vector2.new(0, 0.5)
	HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderText.BackgroundTransparency = 1.000
	HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderText.BorderSizePixel = 0
	HeaderText.Position = UDim2.new(0, 5, 0.5, 0)
	HeaderText.Size = UDim2.new(0, 100, 0.699999988, 0)
	HeaderText.ZIndex = 4
	HeaderText.Font = Enum.Font.GothamBold
	HeaderText.Text = Window.Name
	HeaderText.TextColor3 = Color3.fromRGB(229, 229, 229)
	HeaderText.TextSize = 21.000
	HeaderText.TextStrokeColor3 = Color3.fromRGB(205, 67, 218)
	HeaderText.TextStrokeTransparency = 0.640

	MenuButtonCont.Name = Fatality:RandomString()
	MenuButtonCont.Parent = Header
	MenuButtonCont.AnchorPoint = Vector2.new(0, 0.5)
	MenuButtonCont.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuButtonCont.BackgroundTransparency = 1.000
	MenuButtonCont.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuButtonCont.BorderSizePixel = 0
	MenuButtonCont.ClipsDescendants = true
	MenuButtonCont.Position = UDim2.new(0, 115, 0.5, 0)
	MenuButtonCont.Size = UDim2.new(1, -275, 0.75, 0)
	MenuButtonCont.ZIndex = 4

	tbc.Name = Fatality:RandomString()
	tbc.Parent = MenuButtonCont
	tbc.Active = true
	tbc.AnchorPoint = Vector2.new(0.5, 0.5)
	tbc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tbc.BackgroundTransparency = 1.000
	tbc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tbc.BorderSizePixel = 0
	tbc.ClipsDescendants = false
	tbc.Position = UDim2.new(0.5, 0, 0.5, 0)
	tbc.Size = UDim2.new(1, -2, 1, 0)
	tbc.ZIndex = 4
	tbc.CanvasSize = UDim2.new(2, 0, 0, 0)
	tbc.ScrollBarThickness = 0

	UIListLayout.Parent = tbc
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 4)

	UserProfle.Name = Fatality:RandomString()
	UserProfle.Parent = Header
	UserProfle.AnchorPoint = Vector2.new(1, 0.5)
	UserProfle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserProfle.BackgroundTransparency = 1.000
	UserProfle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserProfle.BorderSizePixel = 0
	UserProfle.Position = UDim2.new(1, -5, 0.5, 0)
	UserProfle.Size = UDim2.new(0, 150, 0.75, 0)
	UserProfle.ZIndex = 4

	UserIcon.Name = Fatality:RandomString()
	UserIcon.Parent = UserProfle
	UserIcon.AnchorPoint = Vector2.new(1, 0.5)
	UserIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserIcon.BackgroundTransparency = 1.000
	UserIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserIcon.BorderSizePixel = 0
	UserIcon.Position = UDim2.new(1, -10, 0.5, 0)
	UserIcon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
	UserIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
	UserIcon.ZIndex = 5
	UserIcon.Image = "";
	-- Thumbnail fetch is a network yield: never block window construction.
	task.spawn(function()
		pcall(function()
			local thumb = Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180);
			if type(thumb) == "string" and thumb ~= "" then
				UserIcon.Image = thumb;
			end;
		end);
	end);

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = UserIcon

	UIStroke.Thickness = 2.500
	UIStroke.Transparency = 0.900
	UIStroke.Parent = UserIcon

	User_name.Name = Fatality:RandomString()
	User_name.Parent = UserProfle
	User_name.AnchorPoint = Vector2.new(1, 0)
	User_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	User_name.BackgroundTransparency = 1.000
	User_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
	User_name.BorderSizePixel = 0
	User_name.Position = UDim2.new(1, -40, 0, 3)
	User_name.Size = UDim2.new(0, 200, 0, 15)
	User_name.ZIndex = 4
	User_name.Font = Enum.Font.GothamMedium
	User_name.Text = (Client and Client.DisplayName) or "Player";
	User_name.TextColor3 = Color3.fromRGB(255, 255, 255)
	User_name.TextSize = 13.000
	User_name.TextStrokeTransparency = 0.700
	User_name.TextXAlignment = Enum.TextXAlignment.Right

	expire_days.Name = Fatality:RandomString()
	expire_days.Parent = UserProfle
	expire_days.AnchorPoint = Vector2.new(1, 0)
	expire_days.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	expire_days.BackgroundTransparency = 1.000
	expire_days.BorderColor3 = Color3.fromRGB(0, 0, 0)
	expire_days.BorderSizePixel = 0
	expire_days.Position = UDim2.new(1, -40, 0, 16)
	expire_days.Size = UDim2.new(0, 200, 0, 15)
	expire_days.ZIndex = 4
	expire_days.Font = Enum.Font.GothamMedium
	expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#f53174\">%s</font>",Window.Expire)
	expire_days.TextColor3 = Color3.fromRGB(255, 255, 255)
	expire_days.TextSize = 12.000
	expire_days.TextStrokeTransparency = 0.700
	expire_days.TextXAlignment = Enum.TextXAlignment.Right
	expire_days.RichText = true;

	HeaderLineShadow.Name = Fatality:RandomString()
	HeaderLineShadow.Parent = Header
	HeaderLineShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderSizePixel = 0
	HeaderLineShadow.Size = UDim2.new(1, 0, 1, 10)

	UIGradient.Rotation = 90
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient.Parent = HeaderLineShadow

	UICorner_4.CornerRadius = UDim.new(0, 5)
	UICorner_4.Parent = HeaderLineShadow

	MenuFrame.Name = Fatality:RandomString()
	MenuFrame.Parent = FatalFrame
	MenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuFrame.BackgroundTransparency = 1.000
	MenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuFrame.BorderSizePixel = 0
	MenuFrame.Position = UDim2.new(0, 0, 0, 50)
	MenuFrame.Size = UDim2.new(1, 0, 1, -82)

	Bottom.Name = Fatality:RandomString()
	Bottom.Parent = FatalFrame
	Bottom.Active = true
	Bottom.AnchorPoint = Vector2.new(0, 1)
	Bottom.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Bottom.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Bottom.BorderSizePixel = 0
	Bottom.Position = UDim2.new(0, 0, 1, 0)
	Bottom.Size = UDim2.new(1, 0, 0, 25)
	Bottom.ZIndex = 2

	HeaderLine_2.Name = Fatality:RandomString()
	HeaderLine_2.Parent = Bottom
	HeaderLine_2.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	HeaderLine_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine_2.BorderSizePixel = 0
	HeaderLine_2.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine_2.ZIndex = 3

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = Bottom

	HeaderLineShadow_2.Name = Fatality:RandomString()
	HeaderLineShadow_2.Parent = Bottom
	HeaderLineShadow_2.AnchorPoint = Vector2.new(0, 1)
	HeaderLineShadow_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BackgroundTransparency = 0.500
	HeaderLineShadow_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BorderSizePixel = 0
	HeaderLineShadow_2.Position = UDim2.new(0, 0, 1, 0)
	HeaderLineShadow_2.Size = UDim2.new(1, 0, 1, 5)

	UIGradient_2.Rotation = -90
	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient_2.Parent = HeaderLineShadow_2

	UICorner_6.CornerRadius = UDim.new(0, 5)
	UICorner_6.Parent = HeaderLineShadow_2

	Fatality:Drag(FatalFrame,FatalFrame,0.1);

	inputBegan1 = UserInputService.InputBegan:Connect(function(input,istyping)
		if not istyping then
			if input.KeyCode == Window.Keybind or input.KeyCode.Name == Window.Keybind then
				Fatal.Toggle = not Fatal.Toggle;

				ToggleUI(Fatal.Toggle);
			end;
		end
	end)

	function Fatal:SetUsername(name: string)
		User_name.Text = name or Client.DisplayName;
	end;

	function Fatal:SetProfile(icon: string)
		if type(icon) == "string" then UserIcon.Image = icon; return; end;
		task.spawn(function()
			pcall(function()
				local thumb = Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180);
				if type(thumb) == "string" and thumb ~= "" then UserIcon.Image = thumb; end;
			end);
		end);
	end;

	function Fatal:SetExpire(str: string)
		expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#f53174\">%s</font>",str)
	end;

	function Fatal:GetFlags()
		return Fatality.WindowFlags[Fatalitywin];
	end;

	function Fatal:AddConfig()
		local ConfigButton = Instance.new("ImageButton")

		ConfigButton.Name = "ConfigButton"
		ConfigButton.Parent = Bottom;
		ConfigButton.AnchorPoint = Vector2.new(0, 0.5)
		ConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ConfigButton.BackgroundTransparency = 1.000
		ConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigButton.BorderSizePixel = 0
		ConfigButton.Position = UDim2.new(0, 57, 0.5, 0)
		ConfigButton.Size = UDim2.new(0, 16, 0, 16)
		ConfigButton.ZIndex = 4
		Fatality:SetIcon(ConfigButton, "folders")
		ConfigButton.ImageTransparency = 0.500;

		Fatality:CreateHover(ConfigButton,function(bool)
			if bool then
				Fatality:CreateAnimation(ConfigButton,0.3,{
					ImageTransparency = 0.2500;
				})
			else
				Fatality:CreateAnimation(ConfigButton,0.3,{
					ImageTransparency = 0.500;
				})
			end;
		end);

		return Fatality:CreateConfigWindow(Fatalitywin,Fatal,ConfigButton);
	end;

	function Fatal:LoadConfig(config)

		for i,v in next , config do
			if i ~= "Info" then
				local Element = Fatality.WindowFlags[Fatalitywin][i];

				if Element then

					local Value = v.Value;
					local MainValue;

					task.spawn(function()
						if Value.Type == "String" then
							Element:SetValue(tostring(Value.Value));
						elseif Value.Type == "Boolean" then
							Element:SetValue((typeof(Value.Value) == 'boolean' and Value.Value) or (Value.Value == "true" and true or false));
						elseif Value.Type == "Number" then
							Element:SetValue(Value.Value);
						elseif Value.Type == "Color3" then
							Element:SetValue(Color3.new(Value.Value.R,Value.Value.G,Value.Value.B) , Value.Value.Transparency);
						elseif Value.Type == "Table" then
							Element:SetValue(Value.Value);

						end;
					end);
				end;

			end;
		end;
	end;

	function Fatal:GetFlagConfig()
		local Flags = Fatal:GetFlags();

		local ConfigElement = {};

		for i,v in next , Flags do
			local ValueData = {};
			local Value = v:GetValue();

			if typeof(Value) == "string" then
				ValueData.Type = "String";
				ValueData.Value = Value;
			elseif typeof(Value) == "boolean" then
				ValueData.Type = "Boolean";
				ValueData.Value = Value;
			elseif typeof(Value) == "number" then
				ValueData.Type = "Number";
				ValueData.Value = Value;
			elseif typeof(Value) == "Color3" then
				ValueData.Type = "Color3";

				local Color = Value.Color;
				local Transparency = Value.Transparency;

				ValueData.Value = {
					R = Color.R,
					G = Color.G,
					B = Color.B,

					Transparency = Transparency
				};
			elseif typeof(Value) == "table" then
				if Value.Color and Value.Transparency then
					ValueData.Type = "Color3";

					local Color = Value.Color;
					local Transparency = Value.Transparency;

					ValueData.Value = {
						R = Color.R,
						G = Color.G,
						B = Color.B,

						Transparency = Transparency
					};
				else
					ValueData.Type = "Table";
					ValueData.Value = Value;
				end;
			else
				ValueData.Type = "Unknow";
				ValueData.Value = nil;
			end;

			rawset(ConfigElement,i,{
				FlagId = v.Flag,
				Value = ValueData,
			})
		end;

		return ConfigElement;
	end;

	function Fatal:AddMenu(Menu : Menu)
		Menu = Menu or {};
		Menu.Name = Menu.Name or "EXAMPLE";
		Menu.Icon = Menu.Icon or "eye";
		Menu.AutoFill = (Menu.AutoFill == nil and false) or Menu.AutoFill;

		local MenuLib = {};
		local MenuButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Icon = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local menu_name = Instance.new("TextLabel")

		MenuButton.Name = Fatality:RandomString()
		MenuButton.Parent = tbc;
		MenuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		MenuButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuButton.BorderSizePixel = 0
		MenuButton.Size = UDim2.new(0, 90, 0.85, 0)
		MenuButton.ZIndex = 5

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = MenuButton

		UIStroke.Transparency = 0.950
		UIStroke.Parent = MenuButton

		Icon.Name = Fatality:RandomString()
		Icon.Parent = MenuButton
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 5, 0.5, 0)
		Icon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Icon.ZIndex = 5
		Fatality:SetIcon(Icon, Menu.Icon);
		Icon.ImageColor3 = Fatality.Colors.Main
		Icon.ScaleType = Enum.ScaleType.Crop

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Icon

		menu_name.Name = Fatality:RandomString()
		menu_name.Parent = MenuButton
		menu_name.AnchorPoint = Vector2.new(0, 0.5)
		menu_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		menu_name.BackgroundTransparency = 1.000
		menu_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		menu_name.BorderSizePixel = 0
		menu_name.Position = UDim2.new(0, 28, 0.5, 0)
		menu_name.Size = UDim2.new(1, 0, 1, 0)
		menu_name.ZIndex = 5
		menu_name.Font = Enum.Font.GothamBold
		menu_name.Text = Menu.Name
		menu_name.TextColor3 = Color3.fromRGB(255, 255, 255)
		menu_name.TextSize = 13.000
		menu_name.TextStrokeTransparency = 0.900
		menu_name.TextTransparency = 0.150
		menu_name.TextXAlignment = Enum.TextXAlignment.Left

		local text_size = Fatality:GetTextSize(menu_name);

		MenuButton.Size = UDim2.new(0, text_size.X + 33, 0.85, 0)

		local MenuLiber = Instance.new("Frame")
		local Left = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local Center = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local Right = Instance.new("ScrollingFrame")
		local UIListLayout_3 = Instance.new("UIListLayout")

		MenuLiber.Name = Fatality:RandomString()
		MenuLiber.Parent = MenuFrame
		MenuLiber.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MenuLiber.BackgroundTransparency = 1.000
		MenuLiber.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuLiber.BorderSizePixel = 0
		MenuLiber.ClipsDescendants = true
		MenuLiber.Size = UDim2.new(1, 0, 1, 0)
		MenuLiber.ZIndex = 7

		Left.Name = Fatality:RandomString()
		Left.Parent = MenuLiber
		Left.Active = true
		Left.AnchorPoint = Vector2.new(0.5, 0.5)
		Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Left.BackgroundTransparency = 1.000
		Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Left.BorderSizePixel = 0
		Left.ClipsDescendants = false
		Left.Position = UDim2.new(0.175, 0, 0.5, 0)
		Left.Size = UDim2.new(0.32, 0, 1, -5)
		Left.ScrollBarThickness = 0

		UIListLayout.Parent = Left
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 2)
		UIListLayout.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		Center.Name = Fatality:RandomString()
		Center.Parent = MenuLiber
		Center.Active = true
		Center.AnchorPoint = Vector2.new(0.5, 0.5)
		Center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Center.BackgroundTransparency = 1.000
		Center.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Center.BorderSizePixel = 0
		Center.ClipsDescendants = false
		Center.Position = UDim2.new(0.5, 0, 0.5, 0)
		Center.Size = UDim2.new(0.32, 0, 1, -5)
		Center.ScrollBarThickness = 0

		UIListLayout_2.Parent = Center
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 2)
		UIListLayout_2.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		Right.Name = Fatality:RandomString()
		Right.Parent = MenuLiber
		Right.Active = true
		Right.AnchorPoint = Vector2.new(0.5, 0.5)
		Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Right.BackgroundTransparency = 1.000
		Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Right.BorderSizePixel = 0
		Right.ClipsDescendants = false
		Right.Position = UDim2.new(0.825, 0, 0.5, 0)
		Right.Size = UDim2.new(0.32, 0, 1, -5)
		Right.ScrollBarThickness = 0

		UIListLayout_3.Parent = Right
		UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 2)
		UIListLayout_3.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		local BindEvent = Instance.new('BindableEvent',MenuLiber);
		BindEvent.Name = Fatality:RandomString();

		if not Menu.AutoFill then
			Fatality:ScrollSignal(Right,UIListLayout_3,'Y');
			Fatality:ScrollSignal(Center,UIListLayout_2,'Y');
			Fatality:ScrollSignal(Left,UIListLayout,'Y');
		else
			Right.CanvasSize = UDim2.new(0,0,0,0);
			Left.CanvasSize = UDim2.new(0,0,0,0);
			Center.CanvasSize = UDim2.new(0,0,0,0);
		end;

		Fatal.Signal.Event:Connect(function(Bool)
			if Bool then
				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = (MenuLiber.Visible and 0) or 1
				})

				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 0.950
				})

				Fatality:CreateAnimation(Left,0.3,{
					Position = UDim2.new(0.175, 0, 0.5, 0)
				})

				Fatality:CreateAnimation(Center,0.4,{
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})

				Fatality:CreateAnimation(Right,0.5,{
					Position = UDim2.new(0.825, 0, 0.5, 0)
				})

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = (MenuLiber.Visible and 0.15) or 0.5
				})

				Fatality:CreateAnimation(menu_name,0.5,{
					TextStrokeTransparency = 0.900,
					TextTransparency = (MenuLiber.Visible and 0.15) or 0.5
				})
			else
				Fatality:CreateAnimation(Left,0.5,{
					Position = UDim2.new(0.175, 0, 0.5, 1)
				})

				Fatality:CreateAnimation(Center,0.5,{
					Position = UDim2.new(0.5, 0, 0.5, 2)
				})

				Fatality:CreateAnimation(Right,0.5,{
					Position = UDim2.new(0.825, 0, 0.5, 3)
				})

				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 1
				})

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(menu_name,0.5,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})
			end;
		end)

		local ValueSelect = function(val)
			if val then
				MenuLiber.Visible = true;

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = 0.15,
					ImageColor3 = Fatality.Colors.Main
				});

				Fatality:CreateAnimation(menu_name,0.5,{
					TextTransparency = 0.15
				});

				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 0
				})

				BindEvent:SetAttribute('V',true);
				BindEvent:Fire(true);
			else
				BindEvent:SetAttribute('V',false);
				BindEvent:Fire(false);

				MenuLiber.Visible = false;

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = 0.5,
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				});

				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(menu_name,0.5,{
					TextTransparency = 0.5
				});
			end;
		end;

		local _B = {
			Root = MenuLiber,
			ValueSelect = ValueSelect,
			Bindable = BindEvent,
		};

		if not Fatal.MenuSelected then
			Fatal.MenuSelected = _B;

			ValueSelect(true);
		else
			ValueSelect(false);
		end;

		table.insert(Fatal.Menus,_B)

		Fatality:CreateHover(MenuButton,function(bool)
			if Fatal.MenuSelected.Root ~= MenuLiber then
				if bool then
					Fatality:CreateAnimation(Icon,0.5,{
						ImageTransparency = 0.2,
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					});

					Fatality:CreateAnimation(MenuButton,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(menu_name,0.5,{
						TextTransparency = 0.2
					});
				else
					Fatality:CreateAnimation(Icon,0.5,{
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					});

					Fatality:CreateAnimation(MenuButton,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(menu_name,0.5,{
						TextTransparency = 0.5
					});
				end
			end;
		end)

		Fatality:NewInput(MenuButton,function()
			for i,v in next , Fatal.Menus do
				if v.Root == MenuLiber then
					Fatal.MenuSelected = v;

					v.ValueSelect(true)
				else
					v.ValueSelect(false)
				end;
			end;
		end);
		
		function MenuLib:AddPreview(Config: Preview)
			Config = Config or {};
			Config.Name = Config.Name or "PREVIEW";
			Config.Position = Config.Position or "left";
			Config.Height = Config.Height or 0;
			
			local Preview = Instance.new("Frame")
			local PreviewName = Instance.new("TextLabel")
			local Main = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local MainBlock = Instance.new("Frame")

			Preview.Name = "Preview"
			Preview.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Preview.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			Preview.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Preview.BorderSizePixel = 0
			Preview.ClipsDescendants = true
			Preview.ZIndex = 15;
			Preview.Size = UDim2.new(1, 0, 0, 25 + Config.Height)
	
			PreviewName.Name = "PreviewName"
			PreviewName.Parent = Preview
			PreviewName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PreviewName.BackgroundTransparency = 1.000
			PreviewName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PreviewName.BorderSizePixel = 0
			PreviewName.Position = UDim2.new(0, 10, 0, 0)
			PreviewName.Size = UDim2.new(1, 0, 0, 15)
			PreviewName.ZIndex = 19
			PreviewName.FontFace = Fatality.FontSemiBold
			PreviewName.Text = Config.Name
			PreviewName.TextColor3 = Color3.fromRGB(255, 255, 255)
			PreviewName.TextSize = 15.000
			PreviewName.TextStrokeTransparency = 0.750
			PreviewName.TextXAlignment = Enum.TextXAlignment.Left

			Main.Name = "Main"
			Main.Parent = Preview
			Main.AnchorPoint = Vector2.new(0.5, 1)
			Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Main.BorderSizePixel = 0
			Main.Position = UDim2.new(0.5, 0, 1, -1)
			Main.Size = UDim2.new(1, -5, 1, -10)
			Main.ZIndex = 17

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Main

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Main

			MainBlock.Name = "MainBlock"
			MainBlock.Parent = Main
			MainBlock.AnchorPoint = Vector2.new(0.5, 0.5)
			MainBlock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainBlock.BackgroundTransparency = 1.000
			MainBlock.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainBlock.BorderSizePixel = 0
			MainBlock.Position = UDim2.new(0.5, 0, 0.5, 0)
			MainBlock.Size = UDim2.new(1, -5, 1, -5)
			MainBlock.ZIndex = 18
			
			local Toggle = function(v)
				if v then
					Fatality:CreateAnimation(Preview,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(PreviewName,0.5,{
						TextStrokeTransparency = 0.750,
						TextTransparency = 0
					})
					
					Fatality:CreateAnimation(Main,0.5,{
						BackgroundTransparency = 0
					})
					
					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})
					
					Fatality:CreateAnimation(MainBlock,0.5,{
						Size = UDim2.new(1, -5, 1, -5)
					})
				else
					Fatality:CreateAnimation(Preview,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(PreviewName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})

					Fatality:CreateAnimation(Main,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(MainBlock,0.5,{
						Size = UDim2.new(0,0,0,0)
					})
				end
			end;

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);
			
			return MainBlock;
		end;

		function MenuLib:AddListBox(Config : Listbox)
			Config = Config or {};
			Config.Name = Config.Name or "LIST BOX";
			Config.Position = Config.Position or "left";
			Config.Height = Config.Height or 0;
			Config.Values = Config.Values or {};
			Config.Multi = Config.Multi or false;
			Config.Default = Config.Default or ((Config.Multi and nil) or {});
			Config.Callback = Config.Callback or function() end;

			table.insert(Fatal.ElementContents,{
				Name = Config.Name,
				Path = Menu.Name .. " > ".. Config.Name,
				_TAB = _B
			});

			local ListBox = Instance.new("Frame")
			local Elements = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local SearchBox = Instance.new("Frame")
			local TextBox = Instance.new("TextBox")
			local UICorner_2 = Instance.new("UICorner")
			local UIStroke_2 = Instance.new("UIStroke")
			local OptionButton = Instance.new("ImageButton")
			local ScrollingFrame = Instance.new("ScrollingFrame")
			local UICorner_3 = Instance.new("UICorner")
			local UIStroke_3 = Instance.new("UIStroke")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local ListName = Instance.new("TextLabel")

			ListBox.Name = Fatality:RandomString()
			ListBox.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			ListBox.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			ListBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListBox.BorderSizePixel = 0
			ListBox.ClipsDescendants = true
			ListBox.Size = UDim2.new(1, 0, 0, 350)
			ListBox.ZIndex = 10
			ListBox.ClipsDescendants = true;

			Fatality:AddDragBlacklist(ScrollingFrame);

			Elements.Name = Fatality:RandomString()
			Elements.Parent = ListBox
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Elements.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)
			Elements.ZIndex = 10

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Elements

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements

			SearchBox.Name = Fatality:RandomString()
			SearchBox.Parent = Elements
			SearchBox.BackgroundColor3 = Fatality.Colors.Black
			SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchBox.BorderSizePixel = 0
			SearchBox.ClipsDescendants = true
			SearchBox.Position = UDim2.new(0, 10, 0, 15)
			SearchBox.Size = UDim2.new(0, 195, 0, 16)
			SearchBox.ZIndex = 10

			TextBox.Parent = SearchBox
			TextBox.BackgroundColor3 = Fatality.Colors.Black
			TextBox.BackgroundTransparency = 1.000
			TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0, 5, 0, 0)
			TextBox.Size = UDim2.new(1, -10, 0, 16)
			TextBox.ZIndex = 11
			TextBox.ClearTextOnFocus = false
			TextBox.FontFace = Fatality.FontSemiBold
			TextBox.PlaceholderText = "Start typing..."
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 11.000
			TextBox.TextXAlignment = Enum.TextXAlignment.Left

			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = SearchBox

			UIStroke_2.Transparency = 0.750
			UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
			UIStroke_2.Parent = SearchBox

			OptionButton.Name = Fatality:RandomString()
			OptionButton.Parent = Elements
			OptionButton.AnchorPoint = Vector2.new(1, 0)
			OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OptionButton.BackgroundTransparency = 1.000
			OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OptionButton.BorderSizePixel = 0
			OptionButton.Position = UDim2.new(1, -10, 0, 16)
			OptionButton.Size = UDim2.new(0, 13, 0, 13)
			OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
			OptionButton.ZIndex = 11
			OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
			OptionButton.ImageTransparency = 0.600
			OptionButton.Visible = Config.Option or false;

			ScrollingFrame.Parent = Elements
			ScrollingFrame.Active = true
			ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
			ScrollingFrame.BackgroundColor3 = Fatality.Colors.Black
			ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
			ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
			ScrollingFrame.ZIndex = 11
			ScrollingFrame.ScrollBarThickness = 0

			UICorner_3.CornerRadius = UDim.new(0, 3)
			UICorner_3.Parent = ScrollingFrame

			UIStroke_3.Transparency = 0.750
			UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
			UIStroke_3.Parent = ScrollingFrame

			UIListLayout.Parent = ScrollingFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local all = (#ScrollingFrame:GetChildren() - 1);
				local scale = math.clamp((all * (10 + UIListLayout.Padding.Offset)) + (Config.Height + UIListLayout.Padding.Offset),25,400);

				if Menu.AutoFill then
					ListBox.Size = UDim2.new(1,0,0,scale / 2.5);
				else
					ListBox.Size = UDim2.new(1,0,0,scale);
				end;

				ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y);
			end)

			SpaceBox.Name = Fatality:RandomString()
			SpaceBox.Parent = ScrollingFrame
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 1)

			ListName.Name = Fatality:RandomString()
			ListName.Parent = ListBox
			ListName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ListName.BackgroundTransparency = 1.000
			ListName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListName.BorderSizePixel = 0
			ListName.Position = UDim2.new(0, 10, 0, 0)
			ListName.Size = UDim2.new(1, 0, 0, 15)
			ListName.ZIndex = 10
			ListName.FontFace = Fatality.FontSemiBold
			ListName.Text = Config.Name
			ListName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ListName.TextSize = 15.000
			ListName.TextStrokeTransparency = 0.750
			ListName.TextXAlignment = Enum.TextXAlignment.Left

			local new_button = function()
				local db_selected = Instance.new("TextButton")

				db_selected.Name = Fatality:RandomString()
				db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				db_selected.BackgroundTransparency = 1.000
				db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				db_selected.BorderSizePixel = 0
				db_selected.Size = UDim2.new(1, 0, 0, 10)
				db_selected.ZIndex = 15
				db_selected.FontFace = Fatality.FontSemiBold
				db_selected.TextColor3 = Fatality.Colors.Main
				db_selected.TextSize = 12.000
				db_selected.TextTransparency = 0.5;
				db_selected.TextXAlignment = Enum.TextXAlignment.Left

				return db_selected;
			end;

			local Toggle = function(v)
				if v then
					Fatality:CreateAnimation(ListBox,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})

					Fatality:CreateAnimation(UIStroke_2,0.5,{
						Transparency = 0.75
					})

					Fatality:CreateAnimation(UIStroke_3,0.5,{
						Transparency = 0.75
					})

					Fatality:CreateAnimation(SearchBox,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(TextBox,0.5,{
						TextTransparency = 0
					})

					Fatality:CreateAnimation(OptionButton,0.45,{
						ImageTransparency = (Config.Option and 0.6) or 1,
					})

					Fatality:CreateAnimation(ScrollingFrame,0.45,{
						BackgroundTransparency = 0,
						Position = UDim2.new(0.5, 0, 0, 40)
					})

					table.foreach(ScrollingFrame:GetChildren(),function(i,v)
						if v:IsA('TextButton') then
							Fatality:CreateAnimation(v,0.45,{
								TextTransparency = 0.5
							});
						end;
					end);

					Fatality:CreateAnimation(ListName,0.5,{
						TextStrokeTransparency = 0.75,
						TextTransparency = 0
					})
				else

					table.foreach(ScrollingFrame:GetChildren(),function(i,v)
						if v:IsA('TextButton') then
							Fatality:CreateAnimation(v,0.45,{
								TextTransparency = 1
							});
						end;
					end);

					Fatality:CreateAnimation(ListBox,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(UIStroke_2,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(UIStroke_3,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(SearchBox,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(TextBox,0.5,{
						TextTransparency = 1
					})

					Fatality:CreateAnimation(OptionButton,0.45,{
						ImageTransparency = 1
					})

					Fatality:CreateAnimation(ScrollingFrame,0.45,{
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0, 40)
					})

					Fatality:CreateAnimation(ListName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})
				end
			end;

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);

			local DearchDelay = tick();

			TextBox:GetPropertyChangedSignal('Text'):Connect(function()
				DearchDelay = tick();

				if not TextBox.Text:byte() then
					for i,v in next , ScrollingFrame:GetChildren() do
						if v:IsA('TextButton') then
							v.Visible = true;
						end;
					end;

					return;
				end;

				task.delay(0.25,function()
					if (tick() - DearchDelay) > 0.25 then
						for i,v in next , ScrollingFrame:GetChildren() do
							if v:IsA('TextButton') then
								if string.find(string.lower(v.Text),string.lower(TextBox.Text),1,true) then
									v.Visible = true;
								else
									v.Visible = false;
								end;
							end;
						end;
					end;
				end)
			end);

			local res;
			res = Fatality:CreateResponse({
				Refresh = function()
					for i,v in next , ScrollingFrame:GetChildren() do
						if v:IsA('TextButton') then
							v:Destroy();
						end;
					end;

					local selectedmem;

					for i,v in next , Config.Values do
						local bth = new_button();

						bth.Text = string.rep(" ",2)..tostring(v);

						bth.Parent = ScrollingFrame;

						if Config.Multi then
							if (typeof(Config.Default) == 'table' and (Config.Default[v] or table.find(Config.Default,v))) or Config.Default == v then
								Config.Default[v] = true
								bth.TextColor3 = Fatality.Colors.Main;
								bth.TextTransparency = 0;

							else
								bth.TextColor3 = Color3.fromRGB(255, 255, 255);
								bth.TextTransparency = 0.5;

								Config.Default[v] = false
							end;

							Fatality:CreateHover(bth,function(bool)
								if not Config.Default[v] then
									if bool then
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0;
										})
									else
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0.5;
										})
									end;
								end;
							end)

							bth.MouseButton1Click:Connect(function()
								Config.Default[v] = not Config.Default[v];

								if Config.Default[v] then
									bth.TextColor3 = Fatality.Colors.Main;
									bth.TextTransparency = 0;

								else
									bth.TextColor3 = Color3.fromRGB(255, 255, 255);
									bth.TextTransparency = 0.5;
								end;

								Config.Callback(Config.Default);
							end)
						else
							if v == Config.Default then
								selectedmem = bth;
								Config.Default = v;

								bth.TextColor3 = Fatality.Colors.Main;
								bth.TextTransparency = 0;

							else
								bth.TextColor3 = Color3.fromRGB(255, 255, 255);
								bth.TextTransparency = 0.5;
							end;

							Fatality:CreateHover(bth,function(bool)
								if Config.Default ~= v then
									if bool then
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0;
										})
									else
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0.5;
										})
									end;
								end;
							end)

							bth.MouseButton1Click:Connect(function()
								if selectedmem then
									selectedmem.TextColor3 = Color3.fromRGB(255, 255, 255);
									selectedmem.TextTransparency = 0.5;
								end;

								bth.TextTransparency = 0;
								bth.TextColor3 = Fatality.Colors.Main;
								selectedmem = bth;
								Config.Default = v;

								Config.Callback(v);
							end)
						end;
					end;

					Config.Callback(Config.Default);
				end,
				SetValues = function(value)
					Config.Values = value;

				end,
				SetDefault = function(value)
					Config.Default = value;
				end,
				GetValue = function()
					return Config.Default;
				end,
				Flag = Config.Flag and Config.Flag.."ListBox",
				SetValue = function(a)

					Config.Default = a;

					res:Refresh();

					Config.Callback(Config.Default);
				end,

				Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			});

			res:Refresh();

			if Config.Flag then
				Fatality.WindowFlags[Fatalitywin][Config.Flag.."ListBox"] = res;
			end;

			return res;
		end;

		local function clampSections()
			for _, lay in ipairs({ UIListLayout, UIListLayout_2, UIListLayout_3 }) do
				pcall(function()
					if lay.Padding.Offset ~= 2 then
						lay.Padding = UDim.new(0, 2);
					end;
				end);
			end;
			for _, col in ipairs({ Left, Center, Right }) do
				pcall(function()
					for _, f in ipairs(col:GetChildren()) do
						if typeof(f) == "Instance" and f:IsA("GuiObject") and f:GetAttribute("FatalSection") then
							local pos = f.Position;
							if pos.X.Scale ~= 0 or pos.X.Offset < 0 then
								f.Position = UDim2.new(0, 0, pos.Y.Scale, pos.Y.Offset);
							end;
							local size = f.Size;
							if size.X.Scale ~= 1 or size.X.Offset > 0 then
								f.Size = UDim2.new(1, 0, size.Y.Scale, size.Y.Offset);
							end;
						end;
					end;
				end);
			end;
		end;

		MenuLiber:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampSections);

		function MenuLib:ClampSections()
			clampSections();
		end;

		function MenuLib:AddSection(Config : Section)
			Config = Config or {};
			Config.Name = Config.Name or "SECTION";
			Config.Position = Config.Position or "center";
			Config.Height = Config.Height or 0;

			table.insert(Fatal.ElementContents,{
				Name = Config.Name,
				Path = Menu.Name .. " > ".. Config.Name,
				_TAB = _B
			});

			local Section = Instance.new("Frame")
			local Elements = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local SectionName = Instance.new("TextLabel")

			local Toggle = function(v)
				if v then
					Fatality:CreateAnimation(Section,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})

					Fatality:CreateAnimation(SectionName,0.5,{
						TextStrokeTransparency = 0.750,
						TextTransparency = 0
					})
				else
					Fatality:CreateAnimation(Section,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(SectionName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})
				end
			end;

			Section.Name = Fatality:RandomString()
			Section.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Section.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, 0)
			Section:SetAttribute("FatalSection", true)

			Elements.Name = Fatality:RandomString()
			Elements.Parent = Section
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Elements.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Elements

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements

			UIListLayout.Parent = Elements
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			SpaceBox.Name = Fatality:RandomString()
			SpaceBox.Parent = Elements
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 14)

			SectionName.Name = Fatality:RandomString()
			SectionName.Parent = Section
			SectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.BackgroundTransparency = 1.000
			SectionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionName.BorderSizePixel = 0
			SectionName.Position = UDim2.new(0, 10, 0, 0)
			SectionName.Size = UDim2.new(1, 0, 0, 15)
			SectionName.FontFace = Fatality.FontSemiBold;
			SectionName.Text = Config.Name
			SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.TextSize = 15.000
			SectionName.TextStrokeTransparency = 0.750
			SectionName.TextXAlignment = Enum.TextXAlignment.Left


			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local MainScale = UIListLayout.AbsoluteContentSize.Y + 26 + Config.Height;

				if not Menu.AutoFill then
					Fatality:CreateAnimation(Section,0.25,{
						Size = UDim2.new(1, 0, 0, MainScale)
					})
				else
					Section.Size = UDim2.new(1,0,0,MainScale / 2.5);
				end;
			end);

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);

			local _els = Fatality:CreateElements(Elements,Elements.ZIndex,BindEvent,{
				Path = Menu.Name .. " > ".. Config.Name,
				Memory = function(Name)
					table.insert(Fatal.ElementContents,{
						Name = Name,
						Path = Menu.Name .. " > ".. Config.Name .. " > " .. Name,
						_TAB = _B
					});
				end,
			});
			_els._Section = Section;
			clampSections();
			return _els;
		end;

		-- Sub-tabs (side tabs like Local / Enemy / Team / World). The first
		-- AddTab call builds a left strip and indents the three columns;
		-- each tab owns the sections created through it and shows only them
		-- while selected. Sections added directly to the menu are never
		-- hidden. Tabs stack their sections with the normal column layout.
		local Tabs = {};
		local SelectedTab = nil;
		local TabsStrip = nil;
		local TabIndicator = nil;

		local function restyleTabs()
			for _, t in ipairs(Tabs) do
				local on = (t == SelectedTab);
				if t.Button then
					Fatality:CreateAnimation(t.Button, 0.25, {
						BackgroundTransparency = on and 0.85 or 1,
						TextColor3 = on and Fatality.Colors.Main or Color3.fromRGB(150, 150, 150),
					});
				end;
			end;
		end;

		local function selectTab(tab)
			SelectedTab = tab;
			local idx = 0;
			for i, t in ipairs(Tabs) do
				local on = (t == tab);
				if on then
					idx = i;
				end;
				for _, f in ipairs(t.Frames) do
					pcall(function()
						if typeof(f) == "Instance" then f.Visible = on; end;
					end);
				end;
			end;
			if TabIndicator and idx > 0 then
				Fatality:CreateAnimation(TabIndicator, 0.35, {
					Position = UDim2.new(0, 8, 0, (idx - 1) * 28 + 11),
				});
			end;
			restyleTabs();
		end;

		table.insert(Fatality._ThemeUpdaters, function()
			if TabIndicator then
				TabIndicator.BackgroundColor3 = Fatality.Colors.Main;
			end;
			restyleTabs();
		end);

		local function ensureTabsUI()
			if TabsStrip then return; end;
			Left.AnchorPoint = Vector2.new(0, 0.5);
			Left.Position = UDim2.new(0, 122, 0.5, 0);
			Left.Size = UDim2.new(1 / 3, -47.33, 1, -5);
			Center.AnchorPoint = Vector2.new(0, 0.5);
			Center.Position = UDim2.new(1 / 3, 80.67, 0.5, 0);
			Center.Size = UDim2.new(1 / 3, -47.33, 1, -5);
			Right.AnchorPoint = Vector2.new(0, 0.5);
			Right.Position = UDim2.new(2 / 3, 39.33, 0.5, 0);
			Right.Size = UDim2.new(1 / 3, -47.33, 1, -5);
			TabsStrip = Instance.new("Frame");
			local StripList = Instance.new("UIListLayout");
			TabsStrip.Name = Fatality:RandomString();
			TabsStrip.Parent = MenuLiber;
			TabsStrip.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			TabsStrip.BackgroundTransparency = 1.000;
			TabsStrip.BorderColor3 = Color3.fromRGB(0, 0, 0);
			TabsStrip.BorderSizePixel = 0;
			TabsStrip.Position = UDim2.new(0, 6, 0, 5);
			TabsStrip.Size = UDim2.new(0, 104, 1, -10);
			TabsStrip.ZIndex = 7;
			StripList.Parent = TabsStrip;
			StripList.SortOrder = Enum.SortOrder.LayoutOrder;
			StripList.Padding = UDim.new(0, 4);
		end;

		function MenuLib:AddTab(TabConfig)
			TabConfig = TabConfig or {};
			TabConfig.Name = TabConfig.Name or "TAB";
			ensureTabsUI();
			local tab = { Name = TabConfig.Name, Frames = {}, Button = nil };
			local Btn = Instance.new("TextButton");
			local BtnCorner = Instance.new("UICorner");
			local BtnPad = Instance.new("UIPadding");
			Btn.Name = Fatality:RandomString();
			Btn.Parent = TabsStrip;
			Btn.BackgroundColor3 = Color3.fromRGB(19, 19, 19);
			Btn.BorderColor3 = Color3.fromRGB(0, 0, 0);
			Btn.BorderSizePixel = 0;
			Btn.Size = UDim2.new(1, 0, 0, 24);
			Btn.FontFace = Fatality.FontSemiBold;
			Btn.Text = TabConfig.Name;
			Btn.TextColor3 = Color3.fromRGB(150, 150, 150);
			Btn.TextSize = 13;
			Btn.TextXAlignment = Enum.TextXAlignment.Left;
			BtnPad.PaddingLeft = UDim.new(0, 14);
			BtnPad.Parent = Btn;
			BtnCorner.CornerRadius = UDim.new(0, 3);
			BtnCorner.Parent = Btn;
			Fatality:ProtectText(Btn,TabConfig.Name);
			Btn.MouseButton1Click:Connect(function()
				selectTab(tab);
			end);
			Fatality:CreateHover(Btn, function(hover)
				if SelectedTab == tab then
					return;
				end;
				Fatality:CreateAnimation(Btn, 0.2, {
					BackgroundTransparency = hover and 0.9 or 1,
				});
			end);
			tab.Button = Btn;
			table.insert(Tabs, tab);
			if not TabIndicator then
				TabIndicator = Instance.new("Frame");
				TabIndicator.Name = Fatality:RandomString();
				TabIndicator.Parent = MenuLiber;
				TabIndicator.BackgroundColor3 = Fatality.Colors.Main;
				TabIndicator.BorderSizePixel = 0;
				TabIndicator.Position = UDim2.new(0, 8, 0, 11);
				TabIndicator.Size = UDim2.new(0, 3, 0, 12);
				TabIndicator.BackgroundTransparency = 0;
				local IndCorner = Instance.new("UICorner");
				IndCorner.CornerRadius = UDim.new(0, 2);
				IndCorner.Parent = TabIndicator;
			end;
			local TabLib = {};
			function TabLib:AddSection(Config)
				local els = MenuLib:AddSection(Config);
				if type(els) == "table" and typeof(els._Section) == "Instance" then
					table.insert(tab.Frames, els._Section);
					els._Section.Visible = (SelectedTab == tab);
				end;
				return els;
			end;
			function TabLib:Select()
				selectTab(tab);
			end;
			if SelectedTab == nil then
				selectTab(tab);
			else
				restyleTabs();
			end;
			return TabLib;
		end;

		return MenuLib;
	end;

	do
		InfoButton.Name = Fatality:RandomString()
		InfoButton.Parent = Bottom
		InfoButton.AnchorPoint = Vector2.new(1, 0.5)
		InfoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		InfoButton.BackgroundTransparency = 1.000
		InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InfoButton.BorderSizePixel = 0
		InfoButton.Position = UDim2.new(1, -5, 0.5, 0)
		InfoButton.Size = UDim2.new(0, 16, 0, 16)
		InfoButton.ZIndex = 4
		Fatality:SetIcon(InfoButton, "info")
		InfoButton.ImageTransparency = 0.500

		SearchButton.Name = Fatality:RandomString()
		SearchButton.Parent = Bottom
		SearchButton.AnchorPoint = Vector2.new(0, 0.5)
		SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SearchButton.BackgroundTransparency = 1.000
		SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchButton.BorderSizePixel = 0
		SearchButton.Position = UDim2.new(0, 10, 0.5, 0)
		SearchButton.Size = UDim2.new(0, 16, 0, 16)
		SearchButton.ZIndex = 4
		Fatality:SetIcon(SearchButton, "search")
		SearchButton.ImageTransparency = 0.500

		SaveButton.Name = Fatality:RandomString()
		SaveButton.Parent = Bottom
		SaveButton.AnchorPoint = Vector2.new(0, 0.5)
		SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SaveButton.BackgroundTransparency = 1.000
		SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SaveButton.BorderSizePixel = 0
		SaveButton.Position = UDim2.new(0, 35, 0.5, 0)
		SaveButton.Size = UDim2.new(0, 16, 0, 16)
		SaveButton.ZIndex = 4
		Fatality:SetIcon(SaveButton, "save")
		SaveButton.ImageTransparency = 0.500

		Fatality:CreateHover(SaveButton,function(bool)
			if bool then
				Fatality:CreateAnimation(SaveButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				Fatality:CreateAnimation(SaveButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		Fatality:CreateHover(InfoButton,function(bool)
			if bool then
				Fatality:CreateAnimation(InfoButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				Fatality:CreateAnimation(InfoButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		function Fatal:AddSave(callback)
			SaveButton.MouseButton1Click:Connect(callback);
		end;

		function Fatal:AddInfo(callback)
			InfoButton.MouseButton1Click:Connect(callback);
		end;
	end;

	do
		local SearchFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local DropShadow = Instance.new("ImageLabel")
		local SearchBox = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local searchScale = UDim2.new(0, 295, 0, 295);

		Fatality:AddDragBlacklist(SearchFrame);

		local searchOpen = false;
		local SearchToggle = function(value)
			searchOpen = (value == true);
			if value then
				SearchFrame.Position = UDim2.fromOffset(SearchButton.AbsolutePosition.X - 5,SearchButton.AbsolutePosition.Y + (SearchButton.AbsoluteSize.Y * 3))

				Fatality:CreateAnimation(SearchFrame,0.35,{
					Size = searchScale
				})

				Fatality:CreateAnimation(DropShadow,0.35,{
					ImageTransparency = 0.750
				})

				Fatality:CreateAnimation(SearchBox,0.35,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(UIStroke_2,0.5,{
					Transparency = 0.650
				})

				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 0
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 0
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 0
				})
			else
				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 1
				})

				Fatality:CreateAnimation(SearchFrame,0.35,{
					Size = UDim2.new(searchScale.X.Scale, searchScale.X.Offset, 0, 0)
				})

				Fatality:CreateAnimation(DropShadow,0.35,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(SearchBox,0.5,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(UIStroke_2,0.5,{
					Transparency = 1
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 1
				})

				table.foreach(ScrollingFrame:GetChildren(),function(i,v)
					if v:IsA('Frame') then
						v:Destroy();
					end;
				end);
			end;
		end;

		SearchFrame.Name = Fatality:RandomString()
		SearchFrame.Parent = Fatalitywin;
		SearchFrame.AnchorPoint = Vector2.new(0, 1)
		SearchFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
		SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchFrame.BorderSizePixel = 0
		SearchFrame.Position = UDim2.new(4,0,4,0)
		SearchFrame.Size = searchScale
		SearchFrame.ZIndex = 100
		SearchFrame.ClipsDescendants = true

		UIStroke.Color = Color3.fromRGB(29, 29, 29)
		UIStroke.Parent = SearchFrame

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = SearchFrame

		DropShadow.Name = Fatality:RandomString()
		DropShadow.Parent = SearchFrame
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1.000
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Rotation = 0.010
		DropShadow.Size = UDim2.new(1, 47, 1, 47)
		DropShadow.ZIndex = 99
		DropShadow.Image = "rbxassetid://6014261993"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 0.750
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

		SearchBox.Name = Fatality:RandomString()
		SearchBox.Parent = SearchFrame
		SearchBox.AnchorPoint = Vector2.new(0.5, 0)
		SearchBox.BackgroundColor3 = Fatality.Colors.Black
		SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchBox.BorderSizePixel = 0
		SearchBox.Position = UDim2.new(0.5, 0, 0, 9)
		SearchBox.Size = UDim2.new(1, -15, 0, 25)
		SearchBox.ZIndex = 101

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = SearchBox

		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
		UIStroke_2.Parent = SearchBox

		TextBox.Parent = SearchBox
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -15, 1, -5)
		TextBox.ZIndex = 102
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = Fatality.FontSemiBold;
		TextBox.PlaceholderText = "Search"
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 12.000
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		ScrollingFrame.Parent = SearchFrame
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
		ScrollingFrame.Size = UDim2.new(1, -15, 1, -45)
		ScrollingFrame.ZIndex = 102
		ScrollingFrame.ScrollBarThickness = 0

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
		end)

		SearchToggle(false);

		Fatality:CreateHover(SearchButton,function(bool)
			if bool then
				Fatality:CreateAnimation(SearchButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				Fatality:CreateAnimation(SearchButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		local SearchInformation = {};

		local get_button = function(Name,Path,TAB_WARP)
			local ResultFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local FeatureName = Instance.new("TextLabel")
			local FeaturePath = Instance.new("TextLabel")

			ResultFrame.Name = Fatality:RandomString()
			ResultFrame.Parent = ScrollingFrame;
			ResultFrame.BackgroundColor3 = Fatality.Colors.Black
			ResultFrame.BackgroundTransparency = 1.000
			ResultFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ResultFrame.BorderSizePixel = 0
			ResultFrame.Size = UDim2.new(1, 0, 0, 42)
			ResultFrame.ZIndex = 103

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = ResultFrame

			FeatureName.Name = Fatality:RandomString()
			FeatureName.Parent = ResultFrame
			FeatureName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureName.BackgroundTransparency = 1.000
			FeatureName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureName.BorderSizePixel = 0
			FeatureName.Position = UDim2.new(0, 6, 0, 5)
			FeatureName.Size = UDim2.new(1, 0, 0, 15)
			FeatureName.ZIndex = 104
			FeatureName.FontFace = Fatality.FontSemiBold
			FeatureName.Text = Name
			FeatureName.TextColor3 = Color3.fromRGB(255, 255, 255)
			FeatureName.TextSize = 14.000
			FeatureName.TextXAlignment = Enum.TextXAlignment.Left

			FeaturePath.Name = Fatality:RandomString()
			FeaturePath.Parent = ResultFrame
			FeaturePath.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeaturePath.BackgroundTransparency = 1.000
			FeaturePath.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeaturePath.BorderSizePixel = 0
			FeaturePath.Position = UDim2.new(0, 6, 0, 22)
			FeaturePath.Size = UDim2.new(1, 0, 0, 15)
			FeaturePath.ZIndex = 104
			FeaturePath.FontFace = Fatality.FontSemiBold
			FeaturePath.Text = Path
			FeaturePath.TextColor3 = Color3.fromRGB(255, 255, 255)
			FeaturePath.TextSize = 12.000
			FeaturePath.TextTransparency = 0.500
			FeaturePath.TextXAlignment = Enum.TextXAlignment.Left

			local button = Fatality:NewInput(ResultFrame);

			Fatality:CreateHover(button,function(bool)
				if bool then
					Fatality:CreateAnimation(ResultFrame,0.5,{
						BackgroundTransparency = 0
					})
				else
					Fatality:CreateAnimation(ResultFrame,0.5,{
						BackgroundTransparency = 1
					})
				end	
			end);

			button.MouseButton1Click:Connect(function()
				if TAB_WARP then
					for i,v in next , Fatal.Menus do
						if v.Root == TAB_WARP.Root then
							Fatal.MenuSelected = v;
							v.ValueSelect(true)
						else
							v.ValueSelect(false)
						end;
					end;
				end;
			end);

			return ResultFrame;
		end

		SearchButton.MouseButton1Click:Connect(function()
			TextBox.Text = "";

			SearchToggle(true);

			table.clear(SearchInformation);

			table.foreach(ScrollingFrame:GetChildren(),function(i,v)
				if v:IsA('Frame') then
					v:Destroy();
				end;
			end);

			table.foreach(Fatal.ElementContents,function(i,v)
				local button = get_button(v.Name,v.Path,v._TAB);

				SearchInformation[v.Path.." - "..Fatality:RandomString()] = {
					root = button,
					callback = function()

					end,
				};
			end);
		end)

		local DearchDelay = tick();

		TextBox:GetPropertyChangedSignal('Text'):Connect(function()
			DearchDelay = tick();

			if not TextBox.Text:byte() then
				for i,v in next , SearchInformation do
					v.root.Visible = true;
				end;

				return;
			end;

			task.delay(0.5,function()
				if (tick() - DearchDelay) > 0.5 then
					for i,v in next , SearchInformation do
						if string.find(tostring(string.lower(i)),string.lower(TextBox.Text),1,true) then
							v.root.Visible = true;
						else
							v.root.Visible = false;
						end;
					end;
				end;
			end)
		end);

		inputBegan2 = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				-- Guard: closed search used to run a hit-test + 7 tweens +
				-- a child-destroy sweep on EVERY global click.
				if searchOpen and not Fatality:IsMouseOverFrame(SearchFrame) then
					SearchToggle(false);
				end
			end
		end)
	end;

	function Fatal:GetButton()
		local backpack = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")
		local RowLabel = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local StyledTextLabel = Instance.new("TextLabel")
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		local UIPadding = Instance.new("UIPadding")
		local IconHost = Instance.new("Frame")
		local IntegrationIconFrame = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local IntegrationIcon = Instance.new("ImageLabel")
		local SelectedHighlighter = Instance.new("Frame")
		local corner = Instance.new("UICorner")
		local Highlighter = Instance.new("Frame")
		local corner_2 = Instance.new("UICorner")
		local _5 = Instance.new("Frame")

		backpack.Name = "FATALITY"..Fatality:RandomString();
		backpack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		backpack.BackgroundTransparency = 1.000
		backpack.BorderSizePixel = 0
		backpack.LayoutOrder = 9
		backpack.Size = UDim2.new(1, 0, 0, 56)
		backpack.AutoButtonColor = false

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = backpack

		RowLabel.Name = "RowLabel"
		RowLabel.Parent = backpack
		RowLabel.BackgroundTransparency = 1.000
		RowLabel.BorderSizePixel = 0
		RowLabel.LayoutOrder = 9
		RowLabel.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout.Parent = RowLabel
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 8)

		StyledTextLabel.Name = "StyledTextLabel"
		StyledTextLabel.Parent = RowLabel
		StyledTextLabel.BackgroundTransparency = 1.000
		StyledTextLabel.Size = UDim2.new(1, -52, 1, 0)
		StyledTextLabel.Font = Enum.Font.BuilderSansBold
		StyledTextLabel.Text = Window.Name
		StyledTextLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
		StyledTextLabel.TextScaled = true
		StyledTextLabel.TextSize = 20.000
		StyledTextLabel.TextWrapped = true
		StyledTextLabel.TextXAlignment = Enum.TextXAlignment.Left

		UITextSizeConstraint.Parent = StyledTextLabel
		UITextSizeConstraint.MaxTextSize = 20
		UITextSizeConstraint.MinTextSize = 15

		UIPadding.Parent = RowLabel
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 8)

		IconHost.Name = "IconHost"
		IconHost.Parent = RowLabel
		IconHost.BackgroundTransparency = 1.000
		IconHost.BorderSizePixel = 0
		IconHost.LayoutOrder = 9
		IconHost.Size = UDim2.new(0, 44, 0, 44)
		IconHost.ZIndex = 9

		IntegrationIconFrame.Name = "IntegrationIconFrame"
		IntegrationIconFrame.Parent = IconHost
		IntegrationIconFrame.BackgroundTransparency = 1.000
		IntegrationIconFrame.BorderSizePixel = 0
		IntegrationIconFrame.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout_2.Parent = IntegrationIconFrame
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

		IntegrationIcon.Name = "IntegrationIcon"
		IntegrationIcon.Parent = IntegrationIconFrame
		IntegrationIcon.BackgroundTransparency = 1.000
		IntegrationIcon.Size = UDim2.new(0, 36, 0, 36)
		IntegrationIcon.Image = "http://www.roblox.com/asset/?id=11290237405"
		IntegrationIcon.ImageColor3 = Color3.fromRGB(247, 247, 248)

		SelectedHighlighter.Name = "SelectedHighlighter"
		SelectedHighlighter.Parent = IconHost
		SelectedHighlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		SelectedHighlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SelectedHighlighter.BackgroundTransparency = 0.850
		SelectedHighlighter.BorderSizePixel = 0
		SelectedHighlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		SelectedHighlighter.Size = UDim2.new(0, 36, 0, 36)
		SelectedHighlighter.Visible = false

		corner.CornerRadius = UDim.new(1, 0)
		corner.Name = "corner"
		corner.Parent = SelectedHighlighter

		Highlighter.Name = "Highlighter"
		Highlighter.Parent = IconHost
		Highlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		Highlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Highlighter.BackgroundTransparency = 0.850
		Highlighter.BorderSizePixel = 0
		Highlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		Highlighter.Size = UDim2.new(0, 36, 0, 36)
		Highlighter.Visible = false

		corner_2.CornerRadius = UDim.new(1, 0)
		corner_2.Name = "corner"
		corner_2.Parent = Highlighter

		_5.Name = "5"
		_5.Parent = IconHost
		_5.BackgroundTransparency = 1.000
		_5.Size = UDim2.new(1, 0, 1, 0)
		_5.ZIndex = 2

		backpack.MouseButton1Click:Connect(function()
			Fatal.Toggle = not Fatal.Toggle;

			ToggleUI(Fatal.Toggle);
		end);

		backpack.MouseEnter:Connect(function()
			Fatality:CreateAnimation(backpack,0.3,nil,{
				BackgroundColor3 = Fatality.Colors.Main,
				BackgroundTransparency = 0.85
			})
		end)

		backpack.MouseLeave:Connect(function()
			Fatality:CreateAnimation(backpack,0.3,nil,{
				BackgroundTransparency = 1
			})
		end)

		return backpack;
	end;

	function Fatal:SetVisible(b)
		Fatal.Toggle = b;
		ToggleUI(b);
	end;

	function Fatal:Destroy()
		Fatalitywin:Destroy()
		Fatal.Signal:Destroy()
		Fatality.WindowFlags[Fatalitywin] = nil
		if inputBegan1 then inputBegan1:Disconnect() end
		if inputBegan2 then inputBegan2:Disconnect() end
	end;

	ToggleUI(true);

	return Fatal;
end;

function Fatality:Loader(Config: Loader)
	Config = Config or {};
	Config.Name = Config.Name or "FATALITY";
	Config.Duration = Config.Duration or 3.5;
	Config.Scale = Config.Scale or 3;

	local Blur = Instance.new('BlurEffect');
	local Loader = Instance.new("ScreenGui")
	local center = Instance.new("Frame")
	local texts = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local BlackFrame = Instance.new("Frame")

	Loader.Name = Fatality:RandomString()
	Loader.Parent = CoreGui
	Loader.IgnoreGuiInset = true
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global

	center.Name = Fatality:RandomString()
	center.Parent = Loader
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	center.BackgroundTransparency = 1.000
	center.BorderColor3 = Color3.fromRGB(0, 0, 0)
	center.BorderSizePixel = 0
	center.Position = UDim2.new(0.5, 0, 0.5, 0)

	texts.Name = Fatality:RandomString()
	texts.Parent = Loader
	texts.AnchorPoint = Vector2.new(0.5, 0.5)
	texts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	texts.BackgroundTransparency = 1.000
	texts.BorderColor3 = Color3.fromRGB(0, 0, 0)
	texts.BorderSizePixel = 0
	texts.Position = UDim2.new(0.5, 0, 0.5, 0)
	texts.Size = UDim2.new(1, 0, 0, 200)

	UIListLayout.Parent = texts
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, Config.Scale * 5)

	BlackFrame.Name = Fatality:RandomString()
	BlackFrame.Parent = Loader
	BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BackgroundTransparency = 1
	BlackFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BorderSizePixel = 0
	BlackFrame.Size = UDim2.new(1, 0, 1, 0)

	Blur.Size = 0;
	Blur.Parent = svc('Lighting');

	Fatality:CreateAnimation(Blur,1,{
		Size = 60
	})

	Fatality:CreateAnimation(BlackFrame,0.5,{
		BackgroundTransparency = 0.7
	}).Completed:Wait();

	task.wait(0.5);

	local UText = {
		Y = 14,
	};

	local createText = function(TEXT)
		local LIT = Instance.new("Frame")
		local ASCII = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local UIScale = Instance.new("UIScale")

		LIT.Name = Fatality:RandomString()
		LIT.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LIT.BackgroundTransparency = 1.000
		LIT.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LIT.BorderSizePixel = 0
		LIT.Size = UDim2.new(0, 56, 0, 100)
		LIT.ZIndex = 8

		ASCII.Name = Fatality:RandomString()
		ASCII.Parent = LIT
		ASCII.AnchorPoint = Vector2.new(0.5, 0.5)
		ASCII.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ASCII.BackgroundTransparency = 1.000
		ASCII.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ASCII.BorderSizePixel = 0
		ASCII.Position = UDim2.new(0.5, 0, 0.5, 0)
		ASCII.Size = UDim2.new(0, 28, 0, 50)
		ASCII.ZIndex = 8
		ASCII.Font = Enum.Font.GothamBold
		ASCII.Text = TEXT
		ASCII.TextColor3 = Color3.fromRGB(255, 255, 255)
		ASCII.TextSize = 50.000
		ASCII.TextWrapped = true

		local textsize = Fatality:GetTextSize(ASCII);

		ASCII.Size = UDim2.new(0, textsize.X + 100, 0, 50)
		LIT.Size = UDim2.new(0, (textsize.X * 2.5) + (UText[TEXT] or 0), 0, 100)

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 116, 116)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(132, 58, 58))}
		UIGradient.Rotation = 88
		UIGradient.Parent = ASCII

		UIScale.Parent = ASCII
		UIScale.Scale = Config.Scale

		return LIT,ASCII
	end;

	local PosText = {};
	local IsFirst = true;

	string.gsub(Config.Name,'.',function(T)
		local L,A = createText(T);

		L.Parent = texts;
		A.TextTransparency = 1;

		if not IsFirst then
			A.Position = UDim2.new(0.5,0,0.5,200);
		end;

		table.insert(PosText,{
			Frame = L,
			Text = A
		});

		IsFirst = false;
	end);

	do
		local StartText = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local UIScale = Instance.new("UIScale")

		StartText.Name = Fatality:RandomString()
		StartText.Parent = Loader
		StartText.AnchorPoint = Vector2.new(0.5, 0.5)
		StartText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		StartText.BackgroundTransparency = 1.000
		StartText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		StartText.BorderSizePixel = 0
		StartText.Position = UDim2.new(0.5, 0, 0.5, 0)
		StartText.Size = UDim2.new(0, 28, 0, 50)
		StartText.ZIndex = 8
		StartText.Font = Enum.Font.GothamBold
		StartText.Text = Config.Name:sub(1,1)
		StartText.TextColor3 = Color3.fromRGB(255, 255, 255)
		StartText.TextSize = 50.000
		StartText.TextWrapped = true
		StartText.TextTransparency = 1;

		local textsize = Fatality:GetTextSize(StartText);
		local baseSIZX = textsize.X;

		StartText.Size = UDim2.new(0, baseSIZX + 100, 0, 50)

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 116, 116)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(132, 58, 58))}
		UIGradient.Rotation = 88
		UIGradient.Parent = StartText

		UIScale.Parent = StartText
		UIScale.Scale = Config.Scale * 4;

		Fatality:CreateAnimation(StartText,0.45,{
			TextTransparency = 0
		})

		Fatality:CreateAnimation(UIScale,0.5,{
			Scale = Config.Scale;
		});

		task.wait(0.45);

		Fatality:CreateAnimation(StartText,0.35,{
			Position = UDim2.fromOffset(PosText[1].Frame.AbsolutePosition.X + (PosText[1].Frame.AbsoluteSize.X / 2),PosText[1].Frame.AbsolutePosition.Y + (PosText[1].Frame.AbsoluteSize.Y / 2) + math.abs(Loader.AbsolutePosition.Y))
		})

		task.wait(0.5);

		for i,v in next , PosText do
			if i > 1 then
				Fatality:CreateAnimation(v.Text,0.65,{
					Position = UDim2.new(0.5,0,0.5,0);
					TextTransparency = 0
				})
			end;
		end;

		task.wait((Config.Duration - 0.5) + 0.65);

		Fatality:CreateAnimation(StartText,1.5,{
			TextTransparency = 1
		})

		for i,v in next , PosText do
			Fatality:CreateAnimation(v.Text,1.5,{
				TextTransparency = 1
			})
		end;

		Fatality:CreateAnimation(Blur,1.5,{
			Size = 0
		})

		Fatality:CreateAnimation(BlackFrame,1.5,{
			BackgroundTransparency = 1
		})

		task.wait(1.65);

		Loader:Destroy();
	end;
end;

function Fatality:CreateNotifier(): Notifier
	if Fatality.__NOTIFIER_CACHE then return Fatality.__NOTIFIER_CACHE; end;

	local Notify = Instance.new("ScreenGui")
	local layout = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notify.Name = Fatality:RandomString();
	Notify.Parent = CoreGui
	Notify.ResetOnSpawn = false
	Notify.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Notify.IgnoreGuiInset = true;

	layout.Name = Fatality:RandomString();
	layout.Parent = Notify
	layout.AnchorPoint = Vector2.new(1, 0)
	layout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	layout.BackgroundTransparency = 1.000
	layout.BorderColor3 = Color3.fromRGB(0, 0, 0)
	layout.BorderSizePixel = 0
	layout.Position = UDim2.new(1, -5, 0, 5)
	layout.Size = UDim2.new(0, 150, 0, 50)

	UIListLayout.Parent = layout
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local res = Fatality:CreateResponse({
		Notify = function(Config: Notify)
			Config = Config or {}
			Config.Icon = Config.Icon or "settings";
			Config.Content = Config.Content or nil;
			Config.Title = Config.Title or "Notification";
			Config.Duration = Config.Duration or 5;

			local notify = Instance.new("Frame")
			local notify_block = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Icon = Instance.new("ImageLabel")
			local HeaderText = Instance.new("TextLabel")
			local BodyText = Instance.new("TextLabel")

			notify.Name = Fatality:RandomString()
			notify.Parent = layout
			notify.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			notify.BackgroundTransparency = 1.000
			notify.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify.BorderSizePixel = 0
			notify.Size = UDim2.new(0, 0, 0, 0)

			notify_block.Name = Fatality:RandomString()
			notify_block.Parent = notify
			notify_block.AnchorPoint = Vector2.new(0.5, 0)
			notify_block.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			notify_block.BackgroundTransparency = 1
			notify_block.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify_block.BorderSizePixel = 0
			notify_block.Position = UDim2.new(0.5, 0, -1, 0)
			notify_block.Size = UDim2.new(1, 0, 1, -12)
			notify_block.ClipsDescendants = true
			notify_block.ZIndex = 54

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = notify_block

			UIStroke.Thickness = 1
			UIStroke.Transparency = 1
			UIStroke.Parent = notify_block

			Icon.Name = Fatality:RandomString()
			Icon.Parent = notify_block
			Icon.BackgroundColor3 = Fatality.Colors.Main
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 7, 0, 7)
			Icon.Size = UDim2.new(0, 18, 0, 18)
			Fatality:SetIcon(Icon, Config.Icon);
			Icon.ImageColor3 = Fatality.Colors.Main
			Icon.ImageTransparency = 1
			Icon.ZIndex = 55

			HeaderText.Name = Fatality:RandomString()
			HeaderText.Parent = notify_block
			HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderText.BackgroundTransparency = 1.000
			HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HeaderText.BorderSizePixel = 0
			HeaderText.Position = UDim2.new(0, 30, 0, 7)
			HeaderText.Size = UDim2.new(1, 0, 0, 15)
			HeaderText.ZIndex = 55
			HeaderText.FontFace = Fatality.FontSemiBold
			HeaderText.Text = Config.Title
			HeaderText.TextColor3 = Fatality.Colors.Main
			HeaderText.TextSize = 13.000
			HeaderText.TextTransparency = 1
			HeaderText.TextXAlignment = Enum.TextXAlignment.Left

			BodyText.Name = Fatality:RandomString()
			BodyText.Parent = notify_block
			BodyText.AnchorPoint = Vector2.new(0, 1)
			BodyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			BodyText.BackgroundTransparency = 1.000
			BodyText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			BodyText.BorderSizePixel = 0
			BodyText.Position = UDim2.new(0, 10, 1, 0)
			BodyText.Size = UDim2.new(1, -15, 1, -29)
			BodyText.ZIndex = 55
			BodyText.FontFace = Fatality.FontSemiBold
			BodyText.Text = Config.Content or "";
			BodyText.TextColor3 = Color3.fromRGB(255, 255, 255)
			BodyText.TextSize = 12.000
			BodyText.TextTransparency = 1
			BodyText.TextWrapped = true
			BodyText.TextXAlignment = Enum.TextXAlignment.Left
			BodyText.TextYAlignment = Enum.TextYAlignment.Top

			local updateScale = function()
				local TitleScale = Fatality:GetTextSize(HeaderText,Enum.Font.GothamBold);
				local ContentScale = Fatality:GetTextSize(BodyText,Enum.Font.GothamMedium);

				local XScale = (TitleScale.X > ContentScale.X and TitleScale.X) or ContentScale.X;
				local YScale = (TitleScale.Y > ContentScale.Y and TitleScale.Y) or ContentScale.Y;

				notify.Size = UDim2.new(0, XScale + 25, 0, YScale + 50);

				Fatality:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 0, 0)
				});
			end;

			task.delay(0.1,function()
				Fatality:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 0.1
				})

				Fatality:CreateAnimation(UIStroke,0.25,{
					Thickness = 2.500,
					Transparency = 0.900
				})

				Fatality:CreateAnimation(Icon,0.25,{
					ImageTransparency = 0
				})

				Fatality:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 0.200
				})

				Fatality:CreateAnimation(BodyText,0.25,{
					TextTransparency = 0.3
				})
			end);

			updateScale();

			task.delay(Config.Duration + 0.25,function()
				Fatality:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 1, 0)
				})

				Fatality:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(UIStroke,0.25,{
					Thickness = 1,
					Transparency = 1
				})

				Fatality:CreateAnimation(Icon,0.25,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(BodyText,0.25,{
					TextTransparency = 1
				})

				task.delay(0.35,function()
					Fatality:CreateAnimation(notify,0.5,{
						Size = UDim2.new(0,0,0,0)
					})

					task.wait(0.5)

					notify:Destroy();
				end);
			end)
		end,
		Destroy = function()
			Notify:Destroy();
			Fatality.__NOTIFIER_CACHE = nil;
		end,
	});

	Fatality.__NOTIFIER_CACHE = res;

	return res;
end;

-- ======================================================================
-- Fatality UX Pack v1.1 — aliases, bind manager, config helpers.
-- Adds convenience on top of the existing API without changing it:
--   * every control also answers :Set() / :Get()
--   * dropdowns answer :SetValues(), listboxes answer :Set()
--   * Fatality.BindToggle / AddBindableToggle: keybinds that actually
--     flip the toggle visual (press -> :SetValue, so callbacks fire),
--     with Toggle/Hold/Always/Set modes and unlimited extra binds
--   * folder config helpers: List/Save/Load/Delete + dropdown+listbox
--     binding + autosave polling + autoload
--   * tab helpers: EnsureTab / EnsureSection (nil-safe fallbacks)
-- ======================================================================
do
	local _UIS = game:GetService("UserInputService");
	local _Http = game:GetService("HttpService");

	local _origCreateResponse = Fatality.CreateResponse;
	function Fatality:CreateResponse(args)
		if type(args) == "table" then
			if args.SetValue and not args.Set then
				args.Set = args.SetValue;
			end;
			if args.GetValue and not args.Get then
				args.Get = args.GetValue;
			end;
			if args.SetData and not args.SetValues then
				args.SetValues = args.SetData;
			end;
			if args.SetText and not args.Set then
				args.Set = args.SetText;
			end;
			if args.SetText and not args.SetTextAlias then
				args.SetTextAlias = true;
			end;
			if args.Fire and not args.Click then
				args.Click = args.Fire;
			end;
			if args.Refresh and not args.RefreshList then
				args.RefreshList = args.Refresh;
			end;
		end;
		return _origCreateResponse(self, args);
	end;

	Fatality.UXVersion = "1.1";
	Fatality._BindRegistry = Fatality._BindRegistry or {};
	Fatality._ThemeUpdaters = Fatality._ThemeUpdaters or {};

	Fatality.Themes = {
		Default = { Main = Color3.fromRGB(255, 106, 133) },
		Crimson = { Main = Color3.fromRGB(255, 60, 80) },
		Azure = { Main = Color3.fromRGB(80, 170, 255) },
		Emerald = { Main = Color3.fromRGB(60, 220, 130) },
		Violet = { Main = Color3.fromRGB(170, 120, 255) },
		Amber = { Main = Color3.fromRGB(255, 180, 80) },
		Ghost = { Main = Color3.fromRGB(230, 230, 235) },
	};

	function Fatality.SetTheme(t)
		local main = nil;
		if type(t) == "string" then
			local preset = Fatality.Themes and Fatality.Themes[t];
			if preset then
				main = preset.Main;
			end;
		elseif type(t) == "table" and typeof(t.Main) == "Color3" then
			main = t.Main;
		end;
		if typeof(main) ~= "Color3" then
			return false;
		end;
		Fatality.Colors.Main = main;
		Fatality.CurrentTheme = main;
		if Fatality._ThemeUpdaters then
			for _, fn in ipairs(Fatality._ThemeUpdaters) do
				pcall(fn);
			end;
		end;
		return true;
	end;

	local function _normKey(k)
		if typeof(k) == "EnumItem" then
			return string.lower(k.Name);
		end;
		return string.lower(tostring(k or ""));
	end;

	local function _inputKeyName(input)
		local ok, n = pcall(function()
			return input.KeyCode.Name;
		end);
		if ok and type(n) == "string" then
			return n;
		end;
		return tostring(input.KeyCode);
	end;

	local _dispatcherOn = false;
	local function _ensureDispatcher()
		if _dispatcherOn then
			return;
		end;
		_dispatcherOn = true;
		_UIS.InputBegan:Connect(function(input, gpe)
			if gpe then
				return;
			end;
			local kn = string.lower(_inputKeyName(input));
			for _, rec in ipairs(Fatality._BindRegistry) do
				if rec.Removed ~= true then
					for _, k in ipairs(rec.Keys) do
						if kn == _normKey(k) then
							pcall(function()
								rec.Press();
							end);
							break
						end;
					end;
				end;
			end;
		end);
		_UIS.InputEnded:Connect(function(input)
			local kn = string.lower(_inputKeyName(input));
			for _, rec in ipairs(Fatality._BindRegistry) do
				if rec.Removed ~= true then
					for _, k in ipairs(rec.Keys) do
						if kn == _normKey(k) then
							pcall(function()
								rec.Release();
							end);
							break
						end;
					end;
				end;
			end;
		end);
	end;

	function Fatality.NormKey(k)
		return _normKey(k);
	end;

	function Fatality.BindToggle(toggle, opts)
		opts = opts or {};
		local rec = {
			Toggle = toggle,
			Keys = {},
			Mode = opts.Mode or "Toggle",
			SetTo = (opts.SetTo == nil) and true or opts.SetTo,
			Held = false,
			Pressed = false,
			Removed = false,
		};
		local function cur()
			local ok, v = pcall(function()
				return toggle:GetValue();
			end);
			if ok and type(v) == "boolean" then
				return v;
			end;
			return false;
		end;
		function rec.Press()
			if rec.Mode == "Always" then
				toggle:SetValue(true);
			elseif rec.Mode == "Hold" then
				rec.Held = true;
				toggle:SetValue(true);
			elseif rec.Mode == "Set" then
				rec.Pressed = true;
				toggle:SetValue(rec.SetTo ~= false);
			else
				toggle:SetValue(not cur());
			end;
		end;
		function rec.Release()
			rec.Held = false;
			rec.Pressed = false;
			if rec.Mode == "Hold" then
				toggle:SetValue(false);
			end;
		end;
		function rec.AddKey(key)
			if key == nil then
				return;
			end;
			for _, k in ipairs(rec.Keys) do
				if _normKey(k) == _normKey(key) then
					return;
				end;
			end;
			table.insert(rec.Keys, key);
		end;
		function rec.SetMode(m)
			rec.Mode = m;
		end;
		function rec.SetSetTo(v)
			rec.SetTo = v;
		end;
		function rec.Remove()
			rec.Removed = true;
			for i, r in ipairs(Fatality._BindRegistry) do
				if r == rec then
					table.remove(Fatality._BindRegistry, i);
					break;
				end;
			end;
		end;
		if opts.DefaultKey ~= nil then
			rec.AddKey(opts.DefaultKey);
		end;
		if type(opts.Keys) == "table" then
			for _, k in ipairs(opts.Keys) do
				rec.AddKey(k);
			end;
		end;
		table.insert(Fatality._BindRegistry, rec);
		_ensureDispatcher();
		return rec;
	end;

	function Fatality.AddBindableToggle(section, cfg)
		cfg = cfg or {};
		local name = cfg.Name or "Toggle";
		local def = (cfg.Default == nil) and false or cfg.Default;
		local flag = cfg.Flag;
		local toggle = section:AddToggle({
			Name = name,
			Default = def,
			Risky = cfg.Risky or false,
			Option = true,
			Flag = flag,
			Callback = cfg.Callback or function()
			end,
		});
		local handles = { Toggle = toggle, Rows = {}, Count = 0 };
		handles.Bind = nil;
		if toggle and toggle.Option and type(toggle.Option.AddKeybind) == "function" then
			local nextOrder = 0;
			local function takeOrder()
				nextOrder = nextOrder + 1;
				return nextOrder;
			end;
			local function stamp(ctrl, order)
				if ctrl and ctrl.Frame and typeof(ctrl.Frame) == "Instance" then
					pcall(function()
						ctrl.Frame.LayoutOrder = order or takeOrder();
					end);
				end;
			end;
			local function dropRow(row)
				if row.rec and type(row.rec.Remove) == "function" then
					pcall(function()
						row.rec.Remove();
					end);
				end;
				for _, c in ipairs({ row.key, row.mode, row.set, row.remove }) do
					if c and type(c.Destroy) == "function" then
						pcall(function()
							c.Destroy();
						end);
					elseif c and c.Frame and typeof(c.Frame) == "Instance" then
						pcall(function()
							c.Frame:Destroy();
						end);
					end;
				end;
				for i, r in ipairs(handles.Rows) do
					if r == row then
						table.remove(handles.Rows, i);
						break;
					end;
				end;
				handles.Count = #handles.Rows;
			end;
			handles._bindNum = 1;
			local function addBindRow(label, defMode, defSetTo, persist)
				local idx = #handles.Rows + 1;
				local rowRec = Fatality.BindToggle(toggle, { Mode = defMode, SetTo = defSetTo });
				local row = { rec = rowRec };
				row.key = toggle.Option:AddKeybind({
					Name = label,
					Callback = function(k)
						rowRec.AddKey(k);
						if cfg.OnBind then
							pcall(cfg.OnBind, k, idx);
						end;
					end,
				});
				stamp(row.key);
				row.mode = toggle.Option:AddDropdown({
					Name = "Mode",
					Values = cfg.Modes or { "Toggle", "Hold", "Always", "Set" },
					Default = defMode,
					Flag = (persist and flag and (flag .. "_mode")) or nil,
					Callback = function(m)
						rowRec.SetMode(m);
						if cfg.OnMode then
							pcall(cfg.OnMode, m, idx);
						end;
					end,
				});
				stamp(row.mode);
				row.set = toggle.Option:AddToggle({
					Name = "Set to",
					Default = defSetTo,
					Flag = (persist and flag and (flag .. "_setto")) or nil,
					Callback = function(v)
						rowRec.SetSetTo(v);
						if cfg.OnSetTo then
							pcall(cfg.OnSetTo, v, idx);
						end;
					end,
				});
				stamp(row.set);
				if idx > 1 then
					row.remove = toggle.Option:AddButton({
						Name = "Remove",
						Callback = function()
							dropRow(row);
						end,
					});
					stamp(row.remove);
				end;
				table.insert(handles.Rows, row);
				handles.Count = #handles.Rows;
				return row;
			end;
			local first = addBindRow(cfg.BindName or "Bind 1", cfg.Mode or "Toggle", ((cfg.SetTo == nil) and true or cfg.SetTo), true);
			handles.Bind = first.rec;
			handles.Key1 = first.key;
			handles.ModeCtrl = first.mode;
			handles.SetCtrl = first.set;
			handles.AddBtn = toggle.Option:AddButton({
				Name = cfg.AddName or "Add bind",
				Callback = function()
					local m, s = "Toggle", true;
					if handles.Rows[1] and handles.Rows[1].rec then
						m, s = handles.Rows[1].rec.Mode, handles.Rows[1].rec.SetTo;
					end;
					handles._bindNum = handles._bindNum + 1;
					addBindRow("Bind " .. tostring(handles._bindNum), m, s, false);
					if cfg.OnBindAdded then
						pcall(cfg.OnBindAdded, #handles.Rows);
					end;
				end,
			});
			stamp(handles.AddBtn, 1000000);
		end;
		return handles;
	end;

	function Fatality.AddBindableSlider(section, cfg)
		cfg = cfg or {};
		local name = cfg.Name or "Slider";
		local def = (cfg.Default == nil) and 50 or cfg.Default;
		local mn = cfg.Min or 0;
		local mx = cfg.Max or 100;
		local flag = cfg.Flag;
		local slider = section:AddSlider({
			Name = name,
			Default = def,
			Min = mn,
			Max = mx,
			Type = cfg.Type or "",
			Round = cfg.Round or 0,
			Risky = cfg.Risky or false,
			Option = true,
			Flag = flag,
			Callback = cfg.Callback or function()
			end,
		});
		local function makeRec(target)
			local rec = { Keys = {}, Target = target, Removed = false };
			function rec.Press()
				slider:SetValue(math.clamp(rec.Target, mn, mx));
			end;
			function rec.Release()
			end;
			function rec.Remove()
				rec.Removed = true;
				for i, r in ipairs(Fatality._BindRegistry) do
					if r == rec then
						table.remove(Fatality._BindRegistry, i);
						break;
					end;
				end;
			end;
			function rec.AddKey(key)
				if key == nil then
					return;
				end;
				for _, k in ipairs(rec.Keys) do
					if Fatality.NormKey(k) == Fatality.NormKey(key) then
						return;
					end;
				end;
				table.insert(rec.Keys, key);
			end;
			function rec.SetTarget(v)
				rec.Target = v;
			end;
			table.insert(Fatality._BindRegistry, rec);
			_ensureDispatcher();
			return rec;
		end;
		local handles = { Slider = slider, Rows = {}, Count = 0 };
		handles.Bind = nil;
		if slider and slider.Option and type(slider.Option.AddKeybind) == "function" then
			local nextOrder = 0;
			local function takeOrder()
				nextOrder = nextOrder + 1;
				return nextOrder;
			end;
			local function stamp(ctrl, order)
				if ctrl and ctrl.Frame and typeof(ctrl.Frame) == "Instance" then
					pcall(function()
						ctrl.Frame.LayoutOrder = order or takeOrder();
					end);
				end;
			end;
			local function dropRow(row)
				if row.rec and type(row.rec.Remove) == "function" then
					pcall(function()
						row.rec.Remove();
					end);
				end;
				for _, c in ipairs({ row.key, row.val, row.remove }) do
					if c and type(c.Destroy) == "function" then
						pcall(function()
							c.Destroy();
						end);
					elseif c and c.Frame and typeof(c.Frame) == "Instance" then
						pcall(function()
							c.Frame:Destroy();
						end);
					end;
				end;
				for i, r in ipairs(handles.Rows) do
					if r == row then
						table.remove(handles.Rows, i);
						break;
					end;
				end;
				handles.Count = #handles.Rows;
			end;
			handles._bindNum = 1;
			local function addValueRow(label, defTarget, persist)
				local idx = #handles.Rows + 1;
				local rowRec = makeRec(defTarget);
				local row = { rec = rowRec };
				row.key = slider.Option:AddKeybind({
					Name = label,
					Callback = function(k)
						rowRec.AddKey(k);
						if cfg.OnBind then
							pcall(cfg.OnBind, k, idx);
						end;
					end,
				});
				stamp(row.key);
				row.val = slider.Option:AddSlider({
					Name = cfg.ValueName or "Set value",
					Min = mn,
					Max = mx,
					Default = defTarget,
					Flag = (persist and flag and (flag .. "_value")) or nil,
					Callback = function(v)
						rowRec.SetTarget(v);
						if cfg.OnValue then
							pcall(cfg.OnValue, v, idx);
						end;
					end,
				});
				stamp(row.val);
				if idx > 1 then
					row.remove = slider.Option:AddButton({
						Name = "Remove",
						Callback = function()
							dropRow(row);
						end,
					});
					stamp(row.remove);
				end;
				table.insert(handles.Rows, row);
				handles.Count = #handles.Rows;
				return row;
			end;
			local firstTarget = cfg.Value;
			if firstTarget == nil then
				firstTarget = def;
			end;
			local first = addValueRow(cfg.BindName or "Bind 1", firstTarget, true);
			handles.Bind = first.rec;
			handles.Key1 = first.key;
			handles.ValueCtrl = first.val;
			handles.AddBtn = slider.Option:AddButton({
				Name = cfg.AddName or "Add bind",
				Callback = function()
					local t = def;
					if handles.Rows[1] and handles.Rows[1].rec then
						t = handles.Rows[1].rec.Target;
					end;
					handles._bindNum = handles._bindNum + 1;
					addValueRow("Bind " .. tostring(handles._bindNum), t, false);
					if cfg.OnBindAdded then
						pcall(cfg.OnBindAdded, #handles.Rows);
					end;
				end,
			});
			stamp(handles.AddBtn, 1000000);
		end;
		return handles;
	end;

	function Fatality.WireMenuKey(window, key)
		local box = { Key = key or "RightShift" };
		_UIS.InputBegan:Connect(function(input, gpe)
			if gpe then
				return;
			end;
			local kn = string.lower(_inputKeyName(input));
			if kn == _normKey(box.Key) or input.KeyCode == Enum.KeyCode.Insert then
				pcall(function()
					window:SetVisible(not window.Toggle);
				end);
			end;
		end);
		return box;
	end;

	function Fatality.EnsureTab(menu, name)
		if type(menu.AddTab) ~= "function" then
			return nil;
		end;
		menu._FatalTabs = menu._FatalTabs or {};
		if menu._FatalTabs[name] then
			return menu._FatalTabs[name];
		end;
		local tab = menu:AddTab({ Name = name });
		menu._FatalTabs[name] = tab;
		return tab;
	end;

	function Fatality.EnsureSection(tabOrMenu, menuFallback, pos, name)
		local ok, sec = pcall(function()
			if tabOrMenu then
				return tabOrMenu:AddSection({ Position = pos, Name = name });
			end;
			return menuFallback:AddSection({ Position = pos, Name = name });
		end);
		if ok and sec then
			return sec;
		end;
		return menuFallback:AddSection({ Position = pos, Name = name });
	end;

	local function _encodePlain(v)
		if typeof(v) == "Color3" then
			return { __fatal = "C3", R = v.R, G = v.G, B = v.B };
		end;
		if typeof(v) == "EnumItem" then
			return { __fatal = "E", N = v.Name };
		end;
		if type(v) == "table" and typeof(v.Color) == "Color3" then
			return { __fatal = "C3T", R = v.Color.R, G = v.Color.G, B = v.Color.B, T = v.Transparency or 0 };
		end;
		return v;
	end;

	local function _decodePlain(v)
		if type(v) == "table" and v.__fatal == "C3" then
			return Color3.new(tonumber(v.R) or 0, tonumber(v.G) or 0, tonumber(v.B) or 0);
		end;
		if type(v) == "table" and v.__fatal == "E" then
			local ok, code = pcall(function()
				return Enum.KeyCode[tostring(v.N)];
			end);
			if ok and code then
				return code;
			end;
			return tostring(v.N);
		end;
		if type(v) == "table" and v.__fatal == "C3T" then
			return { Color = Color3.new(tonumber(v.R) or 0, tonumber(v.G) or 0, tonumber(v.B) or 0), Transparency = tonumber(v.T) or 0 };
		end;
		return v;
	end;

	function Fatality.GetPlainFlags(window)
		local out = {};
		local ok, flags = pcall(function()
			return window:GetFlags();
		end);
		if not ok or type(flags) ~= "table" then
			return out;
		end;
		for id, el in pairs(flags) do
			local okv, v = pcall(function()
				return el:GetValue();
			end);
			if okv then
				out[id] = v;
			end;
		end;
		return out;
	end;

	function Fatality.ApplyPlainFlags(window, tbl)
		if type(tbl) ~= "table" then
			return 0;
		end;
		local ok, flags = pcall(function()
			return window:GetFlags();
		end);
		if not ok or type(flags) ~= "table" then
			return 0;
		end;
		window._FatalLoading = true;
		local n = 0;
		for id, v in pairs(tbl) do
			local el = flags[id];
			if el and type(el.SetValue) == "function" then
				local dec = _decodePlain(v);
				pcall(function()
					if type(dec) == "table" and typeof(dec.Color) == "Color3" then
						el:SetValue(dec.Color, dec.Transparency);
					else
						el:SetValue(dec);
					end;
				end);
				n = n + 1;
			end;
		end;
		window._FatalLoading = false;
		return n;
	end;

	function Fatality.SnapshotDefaults(window)
		window._FatalDefaults = Fatality.GetPlainFlags(window);
		return window._FatalDefaults;
	end;

	function Fatality.ResetToDefaults(window)
		if type(window._FatalDefaults) ~= "table" then
			return 0;
		end;
		return Fatality.ApplyPlainFlags(window, window._FatalDefaults);
	end;

	function Fatality.ListConfigs(folder)
		local out = {};
		local ok, files = pcall(function()
			if type(listfiles) == "function" then
				return listfiles(folder);
			end;
			return {};
		end);
		if ok and type(files) == "table" then
			for _, f in ipairs(files) do
				local s = string.gsub(tostring(f), "\\", "/");
				local base = s:match("([^/]+)$") or s;
				if string.sub(base, 1, 1) ~= "_" and string.sub(base, -5) == ".json" then
					table.insert(out, string.sub(base, 1, -6));
				end;
			end;
		end;
		table.sort(out);
		return out;
	end;

	function Fatality.SaveNamed(window, folder, name)
		name = tostring(name or "default");
		if name == "" then
			name = "default";
		end;
		pcall(function()
			if type(makefolder) == "function" and type(isfolder) == "function" then
				if not isfolder(folder) then
					makefolder(folder);
				end;
			elseif type(makefolder) == "function" then
				makefolder(folder);
			end;
		end);
		local plain = Fatality.GetPlainFlags(window);
		plain.__fatal_plain = true;
		local enc = {};
		for k, v in pairs(plain) do
			enc[k] = _encodePlain(v);
		end;
		local js = _Http:JSONEncode(enc);
		writefile(folder .. "/" .. name .. ".json", js);
		return true;
	end;

	function Fatality.LoadNamed(window, folder, name)
		name = tostring(name or "default");
		if name == "" then
			name = "default";
		end;
		local path = folder .. "/" .. name .. ".json";
		local ok, hit = pcall(isfile, path);
		if not (ok and hit) then
			return false, "missing";
		end;
		local data = _Http:JSONDecode(readfile(path));
		if type(data) ~= "table" then
			return false, "corrupt";
		end;
		local n = Fatality.ApplyPlainFlags(window, data);
		return true, n;
	end;

	function Fatality.DeleteNamed(folder, name)
		name = tostring(name or "default");
		pcall(delfile, folder .. "/" .. name .. ".json");
		return true;
	end;

	function Fatality.BindConfigList(window, folder, dropdown, listbox, statusLabel, opts)
		opts = opts or {};
		local function setStatus(msg)
			if statusLabel and type(statusLabel.SetText) == "function" then
				pcall(function()
					statusLabel:SetText(tostring(msg));
				end);
			end;
		end;
		local function currentList()
			local l = Fatality.ListConfigs(folder);
			if #l == 0 then
				l = { "default" };
			end;
			return l;
		end;
		local function refresh(msg)
			local l = currentList();
			if dropdown then
				pcall(function()
					if type(dropdown.SetData) == "function" then
						dropdown:SetData(l);
					elseif type(dropdown.SetValues) == "function" then
						dropdown:SetValues(l);
					end;
				end);
			end;
			if listbox and type(listbox.SetValues) == "function" then
				pcall(function()
					listbox:SetValues(l);
					listbox:Refresh();
				end);
			end;
			if msg then
				setStatus(msg);
			elseif opts.Quiet ~= true then
				setStatus(tostring(#l) .. " configs");
			end;
			if opts.OnRefresh then
				pcall(opts.OnRefresh, l);
			end;
			return l;
		end;
		return {
			Refresh = refresh,
			List = currentList,
			Save = function(name)
				local ok = Fatality.SaveNamed(window, folder, name);
				if ok then
					refresh("Saved " .. tostring(name));
				end;
				return ok;
			end,
			Load = function(name)
				local ok, info = Fatality.LoadNamed(window, folder, name);
				refresh(ok and ("Loaded " .. tostring(name)) or ("Missing " .. tostring(name)));
				if opts.OnLoad then
					pcall(opts.OnLoad, name, ok);
				end;
				return ok, info;
			end,
			Delete = function(name)
				Fatality.DeleteNamed(folder, name);
				refresh("Deleted " .. tostring(name));
			end,
		};
	end;

	function Fatality.EnableAutosave(window, folder, getName, interval)
		interval = interval or 2;
		local last = nil;
		local stop = false;
		task.spawn(function()
			while not stop do
				task.wait(interval);
				pcall(function()
					if window._FatalLoading then
						return;
					end;
					if window._FatalAutosave ~= true then
						return;
					end;
					local name = tostring(getName and getName() or "default");
					if name == "" then
						name = "default";
					end;
					local plain = Fatality.GetPlainFlags(window);
					plain.__fatal_plain = true;
					local enc = {};
					for k, v in pairs(plain) do
						enc[k] = _encodePlain(v);
					end;
					local js = _Http:JSONEncode(enc);
					if js ~= last then
						last = js;
						pcall(function()
							writefile(folder .. "/" .. name .. ".json", js);
						end);
					end;
				end);
			end;
		end);
		return function()
			stop = true;
		end;
	end;

	function Fatality.TryAutoload(window, folder, name)
		if type(name) ~= "string" or name == "" then
			return false;
		end;
		local ok, hit = pcall(isfile, folder .. "/" .. name .. ".json");
		if not (ok and hit) then
			return false;
		end;
		local ok2 = Fatality.LoadNamed(window, folder, name);
		return ok2;
	end;

	function Fatality.EnsureConfigFolder(folder)
		pcall(function()
			if type(makefolder) == "function" and type(isfolder) == "function" then
				if not isfolder(folder) then
					makefolder(folder);
				end;
			elseif type(makefolder) == "function" then
				makefolder(folder);
			end;
		end);
		return true;
	end;

	function Fatality.ReadBoot(folder)
		local ok, data = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(folder .. "/" .. "_boot.json"));
		end);
		if ok and type(data) == "table" then
			return data;
		end;
		return nil;
	end;

	function Fatality.WriteBoot(folder, autoload, config, last)
		pcall(function()
			Fatality.EnsureConfigFolder(folder);
			local payload = {
				autoload = autoload == true,
				config = config,
				last = last
			};
			writefile(folder .. "/" .. "_boot.json", game:GetService("HttpService"):JSONEncode(payload));
		end);
		return true;
	end;

	function Fatality.PickSingleValue(v, fallback)
		if type(v) == "string" then
			return v;
		end;
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if vv == true then
					return tostring(kk);
				end;
			end;
		end;
		return fallback;
	end;

	function Fatality.ApplyThemeSelection(themeName, accent)
		if themeName == "Custom" then
			local c = accent;
			if typeof(c) ~= "Color3" then
				c = Color3.fromRGB(255, 106, 133);
			end;
			return Fatality.SetTheme({ Main = c });
		end;
		return Fatality.SetTheme(tostring(themeName or "Default"));
	end;

	function Fatality.BuildSettingsTab(window, settingsMenu, opts)
		opts = opts or {};
		local folder = opts.Folder or "ArchHook";
		local notifier = opts.Notifier;
		local version = opts.Version or "1.0";
		local accentDefault = opts.AccentDefault;
		if typeof(accentDefault) ~= "Color3" then
			accentDefault = Color3.fromRGB(255, 106, 133);
		end;
		local menuDefault = opts.MenuDefault or "RightShift";
		local pollInterval = opts.PollInterval or 2;
		local sync = opts.Sync;
		local themeValues = opts.Themes or { "Default", "Crimson", "Azure", "Emerald", "Violet", "Amber", "Ghost", "Custom" };
		Fatality.EnsureConfigFolder(folder);
		local configTab = Fatality.EnsureTab(settingsMenu, "Config");
		local uiTab = Fatality.EnsureTab(settingsMenu, "UI");
		local confSec = Fatality.EnsureSection(configTab, settingsMenu, "left", "CONFIG");
		local actSec = Fatality.EnsureSection(configTab, settingsMenu, "center", "ACTIONS");
		local autoSec = Fatality.EnsureSection(configTab, settingsMenu, "right", "AUTO");
		local themeSec = Fatality.EnsureSection(uiTab, settingsMenu, "left", "THEME");
		local menuSec = Fatality.EnsureSection(uiTab, settingsMenu, "center", "MENU");
		local infoSec = Fatality.EnsureSection(uiTab, settingsMenu, "right", "INFO");
		local state = {
			configName = "default",
			selectedName = "default",
			autosaveOn = false,
			autosavePick = "Follow selection",
			autoloadOn = false,
			autoloadPick = "Last used",
			themePick = "Default",
			accent = accentDefault,
			menuKey = menuDefault,
			lastConfig = "default"
		};
		local function syncSet(k, v)
			if type(sync) == "table" then
				sync[k] = v;
			end;
		end;
		local function notify(title, content)
			pcall(function()
				if notifier and type(notifier.Notify) == "function" then
					notifier:Notify({ Title = title, Content = content, Icon = "info" });
				else
					Fatality.__NOTIFIER_CACHE:Notify({ Title = title, Content = content, Icon = "info" });
				end;
			end);
		end;
		syncSet("Config name", state.configName);
		syncSet("Selected config", state.selectedName);
		syncSet("Autosave", false);
		syncSet("Autosave config", state.autosavePick);
		syncSet("Autoload", false);
		syncSet("Autoload config", state.autoloadPick);
		syncSet("Theme", state.themePick);
		syncSet("Accent color", state.accent);
		syncSet("Menu key", state.menuKey);
		local function currentList()
			local l = Fatality.ListConfigs(folder);
			if #l == 0 then
				l = { "default" };
			end;
			return l;
		end;
		local initList = currentList();
		local statusLabel = nil;
		pcall(function()
			statusLabel = confSec:AddLabel({ Text = "Ready", Size = 13 });
		end);
		local nameBox = nil;
		pcall(function()
			nameBox = confSec:AddTextInput({
				Name = "Config name",
				Default = "default",
				Placeholder = "cfg name",
				MaxLength = 24,
				Flag = "Config name",
				Callback = function(v)
					v = tostring(v or "default");
					if v == "" then
						v = "default";
					end;
					state.configName = v;
					syncSet("Config name", v);
				end
			});
		end);
		local listDropdown = nil;
		pcall(function()
			listDropdown = confSec:AddDropdown({
				Name = "Config list",
				Values = initList,
				Default = initList[1],
				Flag = "Selected config",
				Callback = function(v)
					local pick = Fatality.PickSingleValue(v, initList[1]);
					state.selectedName = tostring(pick);
					state.configName = tostring(pick);
					syncSet("Selected config", tostring(pick));
					syncSet("Config name", tostring(pick));
					if nameBox and type(nameBox.SetValue) == "function" then
						pcall(function()
							nameBox:SetValue(tostring(pick));
						end);
					end;
				end
			});
		end);
		local autosaveDropdown = nil;
		local autoloadDropdown = nil;
		local accentPicker = nil;
		local menuBox = nil;
		pcall(function()
			menuBox = Fatality.WireMenuKey(window, state.menuKey);
		end);
		local function setStatus(msg)
			if statusLabel and type(statusLabel.SetText) == "function" then
				pcall(function()
					statusLabel:SetText(tostring(msg));
				end);
			end;
		end;
		local function refreshLists(msg)
			local l = currentList();
			if listDropdown and type(listDropdown.SetData) == "function" then
				pcall(function()
					listDropdown:SetData(l);
				end);
			elseif listDropdown and type(listDropdown.SetValues) == "function" then
				pcall(function()
					listDropdown:SetValues(l);
				end);
			end;
			local function refreshPick(ctrl, sentinel)
				if ctrl and type(ctrl.SetData) == "function" then
					pcall(function()
						local vals = { sentinel };
						for _, n in ipairs(l) do
							if n ~= sentinel then
								table.insert(vals, n);
							end;
						end;
						ctrl:SetData(vals);
					end);
				elseif ctrl and type(ctrl.SetValues) == "function" then
					pcall(function()
						local vals = { sentinel };
						for _, n in ipairs(l) do
							if n ~= sentinel then
								table.insert(vals, n);
							end;
						end;
						ctrl:SetValues(vals);
					end);
				end;
			end;
			refreshPick(autosaveDropdown, "Follow selection");
			refreshPick(autoloadDropdown, "Last used");
			if msg then
				setStatus(msg);
			else
				setStatus(tostring(#l) .. " configs found");
			end;
			return l;
		end;
		local function resolveAutosaveName()
			if state.autosavePick == nil or state.autosavePick == "Follow selection" then
				return tostring(state.selectedName or state.configName or "default");
			end;
			return tostring(state.autosavePick);
		end;
		local function persistBoot()
			Fatality.WriteBoot(folder, state.autoloadOn, state.autoloadPick, state.lastConfig);
		end;
		local function applyThemeNow()
			Fatality.ApplyThemeSelection(state.themePick, state.accent);
		end;
		local handle = {};
		function handle.Refresh(msg)
			return refreshLists(msg);
		end;
		function handle.List()
			return currentList();
		end;
		function handle.GetSelected()
			return tostring(state.selectedName or state.configName or "default");
		end;
		function handle.GetConfigName()
			return tostring(state.configName or "default");
		end;
		function handle.Save(name)
			name = tostring(name or state.configName or "default");
			if name == "" then
				name = "default";
			end;
			local ok = Fatality.SaveNamed(window, folder, name);
			if ok then
				state.configName = name;
				state.selectedName = name;
				state.lastConfig = name;
				syncSet("Config name", name);
				syncSet("Selected config", name);
				syncSet("Last config", name);
				if nameBox and type(nameBox.SetValue) == "function" then
					pcall(function()
						nameBox:SetValue(name);
					end);
				end;
				persistBoot();
				refreshLists("Saved " .. name);
			end;
			return ok;
		end;
		function handle.Load(name)
			name = tostring(name or state.selectedName or state.configName or "default");
			if name == "" then
				name = "default";
			end;
			local ok, info = Fatality.LoadNamed(window, folder, name);
			if ok then
				state.configName = name;
				state.selectedName = name;
				state.lastConfig = name;
				syncSet("Config name", name);
				syncSet("Selected config", name);
				syncSet("Last config", name);
				if nameBox and type(nameBox.SetValue) == "function" then
					pcall(function()
						nameBox:SetValue(name);
					end);
				end;
				pcall(function()
					local flags = window:GetFlags();
					local themeEl = flags["ThemeDropdown"];
					if themeEl and type(themeEl.GetValue) == "function" then
						local tv = themeEl:GetValue();
						if type(tv) == "string" then
							state.themePick = tv;
							syncSet("Theme", tv);
						end;
					end;
					local accentEl = flags["Accent colorColorPicker"];
					if accentEl and type(accentEl.GetValue) == "function" then
						local av = accentEl:GetValue();
						if type(av) == "table" and typeof(av.Color) == "Color3" then
							state.accent = av.Color;
							syncSet("Accent color", av.Color);
						elseif typeof(av) == "Color3" then
							state.accent = av;
							syncSet("Accent color", av);
						end;
					end;
				end);
				applyThemeNow();
				persistBoot();
				refreshLists("Loaded " .. name);
			else
				refreshLists("Missing " .. name);
			end;
			return ok, info;
		end;
		function handle.Delete(name)
			name = tostring(name or state.selectedName or state.configName or "default");
			Fatality.DeleteNamed(folder, name);
			refreshLists("Deleted " .. name);
			return true;
		end;
		function handle.Reset()
			local n = Fatality.ResetToDefaults(window);
			applyThemeNow();
			setStatus("Defaults restored");
			return n;
		end;
		function handle.MarkDirty()
			return true;
		end;
		pcall(function()
			actSec:AddButton({ Name = "Save config", Callback = function()
				handle.Save(handle.GetConfigName());
				notify("FATALITY", "Config saved");
			end });
		end);
		pcall(function()
			actSec:AddButton({ Name = "Load config", Callback = function()
				handle.Load(handle.GetSelected());
				notify("FATALITY", "Config loaded");
			end });
		end);
		pcall(function()
			actSec:AddButton({ Name = "Delete config", Callback = function()
				handle.Delete(handle.GetSelected());
				notify("FATALITY", "Config deleted");
			end });
		end);
		pcall(function()
			actSec:AddButton({ Name = "Refresh list", Callback = function()
				handle.Refresh();
			end });
		end);
		pcall(function()
			actSec:AddButton({ Name = "Reset defaults", Callback = function()
				handle.Reset();
			end });
		end);
		pcall(function()
			autoSec:AddToggle({
				Name = "Autosave",
				Default = false,
				Flag = "Autosave",
				Callback = function(v)
					state.autosaveOn = v == true;
					window._FatalAutosave = state.autosaveOn;
					syncSet("Autosave", state.autosaveOn);
					persistBoot();
				end
			});
		end);
		pcall(function()
			local asVals = { "Follow selection" };
			for _, n in ipairs(initList) do
				if n ~= "Follow selection" then
					table.insert(asVals, n);
				end;
			end;
			autosaveDropdown = autoSec:AddDropdown({
				Name = "Autosave config",
				Values = asVals,
				Default = "Follow selection",
				Flag = "Autosave config",
				Callback = function(v)
					state.autosavePick = Fatality.PickSingleValue(v, "Follow selection");
					syncSet("Autosave config", state.autosavePick);
					persistBoot();
				end
			});
		end);
		pcall(function()
			autoSec:AddToggle({
				Name = "Autoload last config",
				Default = false,
				Flag = "Autoload",
				Callback = function(v)
					state.autoloadOn = v == true;
					syncSet("Autoload", state.autoloadOn);
					persistBoot();
				end
			});
		end);
		pcall(function()
			local alVals = { "Last used" };
			for _, n in ipairs(initList) do
				if n ~= "Last used" then
					table.insert(alVals, n);
				end;
			end;
			autoloadDropdown = autoSec:AddDropdown({
				Name = "Autoload config",
				Values = alVals,
				Default = "Last used",
				Flag = "Autoload config",
				Callback = function(v)
					state.autoloadPick = Fatality.PickSingleValue(v, "Last used");
					syncSet("Autoload config", state.autoloadPick);
					persistBoot();
				end
			});
		end);
		pcall(function()
			themeSec:AddDropdown({
				Name = "Theme",
				Values = themeValues,
				Default = "Default",
				Flag = "Theme",
				Callback = function(v)
					local pick = Fatality.PickSingleValue(v, "Default");
					state.themePick = tostring(pick);
					syncSet("Theme", state.themePick);
					if state.themePick ~= "Custom" then
						pcall(function()
							local preset = Fatality.Themes and Fatality.Themes[state.themePick];
							if preset and typeof(preset.Main) == "Color3" and accentPicker and type(accentPicker.SetValue) == "function" then
								accentPicker:SetValue(preset.Main, 0);
							end;
						end);
					end;
					if window._FatalLoading ~= true then
						applyThemeNow();
					end;
				end
			});
		end);
		pcall(function()
			accentPicker = themeSec:AddColorPicker({
				Name = "Accent color",
				Default = accentDefault,
				Flag = "Accent color",
				Callback = function(v)
					local c = v;
					if type(c) == "table" and typeof(c.Color) == "Color3" then
						c = c.Color;
					end;
					if typeof(c) == "Color3" then
						state.accent = c;
						syncSet("Accent color", c);
						if state.themePick == "Custom" and window._FatalLoading ~= true then
							applyThemeNow();
						end;
					end;
				end
			});
		end);
		pcall(function()
			menuSec:AddKeybind({
				Name = "Menu key",
				Default = menuDefault,
				Flag = "Menu key",
				Callback = function(v)
					state.menuKey = v;
					syncSet("Menu key", v);
					if menuBox then
						menuBox.Key = v;
					end;
				end
			});
		end);
		if type(Fatality.WireMenuKey) == "function" and menuBox == nil then
			pcall(function()
				menuBox = Fatality.WireMenuKey(window, state.menuKey);
			end);
		end;
		pcall(function()
			menuSec:AddButton({ Name = "About", Callback = function()
				if type(opts.OnAbout) == "function" then
					pcall(opts.OnAbout);
				else
					notify("FATALITY", "Helpers ready");
				end;
			end });
		end);
		pcall(function()
			menuSec:AddButton({ Name = "Unload", Risky = true, Callback = function()
				if type(opts.OnUnload) == "function" then
					pcall(opts.OnUnload);
				end;
			end });
		end);
		local infoLabel = nil;
		pcall(function()
			infoLabel = infoSec:AddLabel({ Text = "Fatality " .. tostring(version) .. " UX " .. tostring(Fatality.UXVersion or "1.0"), Size = 13 });
		end);
		handle._statusLabel = statusLabel;
		handle._infoLabel = infoLabel;
		handle._menuBox = menuBox;
		handle._window = window;
		handle._folder = folder;
		pcall(function()
			Fatality.SnapshotDefaults(window);
		end);
		refreshLists("Ready");
		applyThemeNow();
		window._FatalAutosave = false;
		pcall(function()
			handle._stopAutosave = Fatality.EnableAutosave(window, folder, resolveAutosaveName, pollInterval);
		end);
		pcall(function()
			local boot = Fatality.ReadBoot(folder);
			if boot and boot.autoload == true then
				local target = nil;
				if type(boot.config) == "string" and boot.config ~= "" and boot.config ~= "Last used" then
					target = boot.config;
				elseif type(boot.last) == "string" and boot.last ~= "" then
					target = boot.last;
				end;
				if target then
					state.autoloadOn = true;
					window._FatalAutosave = state.autosaveOn;
					syncSet("Autoload", true);
					if type(boot.config) == "string" and boot.config ~= "" then
						state.autoloadPick = boot.config;
						syncSet("Autoload config", boot.config);
						if autoloadDropdown and type(autoloadDropdown.SetValue) == "function" then
							pcall(function()
								autoloadDropdown:SetValue(boot.config);
							end);
						end;
					end;
					handle.Load(target);
				end;
			end;
		end);
		if type(opts.InfoProvider) == "function" then
			task.spawn(function()
				while task.wait(2) do
					pcall(function()
						if infoLabel and type(infoLabel.SetText) == "function" then
							local txt = opts.InfoProvider();
							if type(txt) == "string" and txt ~= "" then
								infoLabel:SetText(txt);
							end;
						end;
					end);
				end;
			end);
		end;
		return handle;
	end;
end;

Fatality.FATALITY_PID = Fatality:RandomString();

return Fatality;
