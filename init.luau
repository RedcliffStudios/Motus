--!strict

--- @class Motus
--- A lightweight animation handler wrapper for Roblox animator objects
--- Provides simple methods for loading, playing, stopping, and managing animations.
--- Handles caching and cleanup automatically.
local Motus = {}
Motus.__index = Motus

--[=[
	@type AnimationInput Animation | string | number
	@within Motus
	Represents an input that can be used to identify an animation.  
	Can be an `Animation` instance, an asset ID string (`"rbxassetid://1234"`) or a numeric asset ID.
]=]
type AnimationInput = Animation | string | number

--[=[
	@class MotusAnimator
	An animator wrapper used to manage animation playback, loading, and cleanup.
]=]
export type MotusAnimator = typeof(setmetatable(
	{} :: {
		_animator: Animator,
		_animCache: { [string]: AnimationTrack },
	},
	Motus
))

--[=[
	@private
	@prop _animator Animator
	@within MotusAnimator
	The Animator object used for animation
]=]

--[=[
	@private
	@prop _animCache {[string]: AnimationTrack}
	@within MotusAnimator
	The cache that stores loaded AnimationTracks
]=]

local function InputToID(input: AnimationInput): string
	local ID
	if typeof(input) == "number" then
		ID = "rbxassetid://" .. tostring(input)
	elseif typeof(input) == "Instance" then
		ID = input.AnimationId
	else
		ID = input
	end
	return ID
end

local function MakeAnimation(input: AnimationInput)
	local Animation = Instance.new("Animation")
	Animation.AnimationId = InputToID(input)
	return Animation
end

--[=[
	@function new
	@within Motus
	@param model Model -- The model containing an `Animator` instance.
	@return MotusAnimator -- A new `MotusAnimator` bound to the model's Animator.
	@tag constructor

	Creates a new `MotusAnimator` object
]=]
function Motus.new(model: Model): MotusAnimator
	local animator = model:FindFirstChildWhichIsA("Animator", true) :: Animator?
	assert(animator, model.Name .. " needs to have an Animator")
	local self = setmetatable({
		_animator = animator,
		_animCache = {},
	}, Motus)
	return self
end

--[=[
	@method Preload
	@within MotusAnimator
	@param Input AnimationInput | { AnimationInput }

	Preloads and caches one or multiple animations for future playback.
]=]
function Motus.Preload(self: MotusAnimator, Input: AnimationInput | { AnimationInput })
	if type(Input) == "table" then
		for _, input in ipairs(Input) do
			self._animCache[InputToID(input)] = self._animator:LoadAnimation(MakeAnimation(input))
		end
	else
		self._animCache[InputToID(Input)] = self._animator:LoadAnimation(MakeAnimation(Input))
	end
end

--[=[
	@method Play
	@within MotusAnimator
	@param animation AnimationInput
	@param priority Enum.AnimationPriority?
	@param speed number?
	@param weight number?
	@param fadeTime number?
	@return AnimationTrack
	@tag playback

	Plays an animation on the attached Animator.  
	Automatically loads and caches it if necessary.
	Returns the AnimationTrack that is being played.
]=]
function Motus.Play(
	self: MotusAnimator,
	animation: AnimationInput,
	priority: Enum.AnimationPriority?,
	speed: number?,
	weight: number?,
	fadeTime: number?
): AnimationTrack
	local Key = InputToID(animation)
	local Track = self._animCache[Key]
	if not Track then
		Track = self._animator:LoadAnimation(MakeAnimation(animation))
		self._animCache[Key] = Track
	end
	Track.Priority = priority or Track.Priority
	Track:Play(fadeTime or 0, weight or 1, speed or 1)
	return Track
end

--[=[
	@method Stop
	@within MotusAnimator
	@param animation AnimationInput
	@param fadeTime number?
	@tag playback

	Stops a single animation if it's currently playing.
]=]
function Motus.Stop(self: MotusAnimator, animation: AnimationInput, fadeTime: number?)
	local Track = self._animCache[InputToID(animation)]
	if Track then
		Track:Stop(fadeTime or 0)
	else
		warn("Attempted to stop a non-existent or uncached animation:", animation)
	end
end

--[=[
	@method StopAll
	@within MotusAnimator
	@param fadeTime number?
	@tag playback

	Stops all currently cached and playing animations.
]=]
function Motus.StopAll(self: MotusAnimator, fadeTime: number?)
	for _, track in pairs(self._animCache) do
		track:Stop(fadeTime or 0)
	end
end

--[=[
	@method Destroy
	@within MotusAnimator
	@tag cleanup

	Cleans up all cached animations and destroys them.
]=]
function Motus.Destroy(self: MotusAnimator)
	self:StopAll(0)
	for _, track in pairs(self._animCache) do
		track:Destroy()
	end
	table.clear(self._animCache)
end

return Motus :: { new: (Model) -> MotusAnimator }
