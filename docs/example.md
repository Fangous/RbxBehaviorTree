---
title: Example
sidebar_position: 4
---

# Example

Here is an example ```TestTree.rbxbtree.luau``` module:

```lua
--!strict
local RbxBehaviorTree = require(path.to.RbxBehaviorTree)

local FallbackNode = RbxBehaviorTree.FallbackNode
local SequenceNode = RbxBehaviorTree.SequenceNode
local ActionNode = RbxBehaviorTree.ActionNode
local NodeResults = RbxBehaviorTree.NodeResults

return function(object: any)
	local fireAlarmOn = false
	local distanceFromBuilding = 0
	local safeDistance = 5
	local hasApple = false
	local hasSandwich = true
	local hasBanana = true
	local isBananaOpen = false

	local nodeTree = SequenceNode("Root", {
		FallbackNode("CheckForFireAlarm", {
			ActionNode("FireAlarmOff", function()
				if not fireAlarmOn then
					print("No fire alarm")
					return NodeResults.SUCCESS
				else
					print("Fire alarm is on!")
					return NodeResults.FAILURE
				end
			end),
			ActionNode("RunAway", function()
				if distanceFromBuilding < safeDistance then
					distanceFromBuilding += 1
					print("Run away!")
					return NodeResults.RUNNING
				else
					return NodeResults.SUCCESS
				end
			end),
		}),
		FallbackNode("EatFood", {
			ActionNode("EatApple", function()
				if hasApple then
					hasApple = false
					print("Ate apple!")
					return NodeResults.SUCCESS
				else
					print("We don't have an apple!")
					return NodeResults.FAILURE
				end
			end),
			ActionNode("EatSandwich", function()
				if hasSandwich then
					hasSandwich = false
					print("Ate sandwich!")
					return NodeResults.SUCCESS
				else
					print("We don't have a sandwich!")
					return NodeResults.FAILURE
				end
			end),
			SequenceNode("EatBanana", {
				ActionNode("OpenBanana", function()
					if hasBanana then
						isBananaOpen = true
						print("Opened banana!")
						return NodeResults.SUCCESS
					else
						print("We can't open a non-existent banana!")
						return NodeResults.FAILURE
					end
				end),
				ActionNode("EatBanana", function()
					if hasBanana and isBananaOpen then
						hasBanana = false
						print("Ate banana!")
						return NodeResults.SUCCESS
					else
						--Currently this will never print, since our parent SequenceNode will always fail out at "OpenBanana"
						print("Where is our banana?")
						return NodeResults.FAILURE
					end
				end),
			}),
		}),
	})

	return RbxBehaviorTree.New(1, nodeTree)
end
```

You can now create a new TestTree behavior tree and clean it up after 10 seconds with the following code:

```lua
local TestTree = require(path.to.TestTree)

local newTestTree = TestTree()
task.wait(10)
newTestTree.Destroy() -- Clean up newTestTree
```