include("fedhoria/modules.lua")
local enabled 	= CreateConVar("fedhoria_enabled", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))
local lethalheadshots = CreateConVar("fedhoria_lethalheadshots", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))

local last_dmgpos = {}

hook.Add("CreateEntityRagdoll", "Fedhoria", function(ent, ragdoll)
	if (!enabled:GetBool()) then return end
	local dmgpos = last_dmgpos[ent]

	local phys_bone, lpos

	if dmgpos then
		phys_bone = ragdoll:GetClosestPhysBone(dmgpos)
		if phys_bone then
			local phys = ragdoll:GetPhysicsObjectNum(phys_bone)
			lpos = phys:WorldToLocal(dmgpos)
		end
	end

	timer.Simple(0, function()
		if !IsValid(ragdoll) then return end	

		if phys_bone == 10 and (lethalheadshots:GetInt()) == 1 then return end

		fedhoria.StartModule(ragdoll, "stumble_legs", phys_bone, lpos)
		last_dmgpos[ent] = nil		
	end)
end)

hook.Add("EntityTakeDamage", "Fedhoria", function(ent, dmginfo)
	if (!enabled:GetBool()) then return end
	if (dmginfo:GetDamage() < ent:Health()) then return end

	last_dmgpos[ent] = dmginfo:GetDamagePosition()
end)

local once = true

--RagMod/TTT support
hook.Add("OnEntityCreated", "Fedhoria", function(ent)
	--If RagMod isn't installed remove this hook
	if once then
		once = nil
		if (!RMA_Ragdolize and !CORPSE) then
			hook.Remove("OnEntityCreated", "Fedhoria")
			return
		end
		--these hooks fucks shit up
		if RMA_Ragdolize then
			hook.Remove( "PlayerDeath", "RM_PlayerDies")
			hook.Add( "PostPlayerDeath", "RemoveRagdoll", function(ply)
				if IsValid(ply.RM_Ragdoll) then
					SafeRemoveEntity(ply:GetRagdollEntity())
					ply:SpectateEntity(ply.RM_Ragdoll)
				end
			end)
		end
	end
	if (!enabled:GetBool() or !ent:IsRagdoll()) then return end
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		if CORPSE then
			local ply = ent:GetDTEntity(CORPSE.dti.ENT_PLAYER)
			if (IsValid(ply) and ply:IsPlayer()) then
				fedhoria.StartModule(ent, "stumble_legs")
				return
			end
		end
		for _, ply in ipairs(player.GetAll()) do
			if (ply.RM_IsRagdoll and ply.RM_Ragdoll == ent) then
				fedhoria.StartModule(ent, "stumble_legs")
				return
			end
		end
	end)
end)


local PLAYER = FindMetaTable("Player")


local dolls = {}


local oldGetRagdollEntity = PLAYER.GetRagdollEntity

local function GetRagdollEntity(self)
	return dolls[self] or NULL
end



hook.Add("RM_RagdollReady", "Fedhoria", function(ragdoll)
	if IsValid(ragdoll) then
		fedhoria.StartModule(ragdoll, "stumble_legs")
	end
end)



hook.Add("PostPlayerDeath", "Fedhoria", function(ply)
	if (!enabled:GetBool()) then return end
	timer.Simple(0, function()
		if !IsValid(ply) then return end
		local ragdoll = ply:GetRagdollEntity()
		if (IsValid(ragdoll) and ragdoll:IsRagdoll()) then
			fedhoria.StartModule(ragdoll, "stumble_legs")
		end
	end)
end)