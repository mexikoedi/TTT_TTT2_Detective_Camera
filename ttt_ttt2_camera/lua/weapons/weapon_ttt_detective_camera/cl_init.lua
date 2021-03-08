if engine.ActiveGamemode() ~= "terrortown" then return end
include("shared.lua")
SWEP.PrintName = "Detective Camera"
SWEP.Slot = 7
SWEP.ViewModelFOV = 10
SWEP.ViewModelFlip = false
SWEP.Icon = "vgui/ttt/weapon_detective_camera"

SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "Detective Camera",
    desc = "Use this to watch people get killed live. Left Click to place."
}

function SWEP:PrimaryAttack()
    self.DrawInstructions = true
    RENDER_CONNECTION_LOST = false
end

function SWEP:Deploy()
    if IsValid(self:GetOwner()) then
        self:GetOwner():DrawViewModel(false)
    end

    return true
end

function SWEP:DrawWorldModel()
end

function SWEP:OnRemove()
    if IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() then
        self:GetOwner():ConCommand("lastinv")
    end
end

surface.SetFont("TabLarge")
local w = surface.GetTextSize("MOVE THE MOUSE UP AND DOWN TO PITCH THE CAMERA")

function SWEP:DrawHUD()
    if self.DrawInstructions then
        surface.SetFont("TabLarge")
        surface.SetTextColor(Color(50, 60, 200, 255))
        surface.SetTextPos(ScrW() / 2 - w / 2, ScrH() / 2 + 50)
        surface.DrawText("MOVE THE MOUSE UP AND DOWN TO PITCH THE CAMERA")
    end
end

net.Receive("TTTCamera.Instructions", function()
    local p = LocalPlayer()

    if p.GetWeapon and IsValid(p:GetWeapon("weapon_ttt_detective_camera")) then
        p:GetWeapon("weapon_ttt_detective_camera").DrawInstructions = false
    end
end)