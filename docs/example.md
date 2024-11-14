---
title: Example
sidebar_position: 4
---

# Example

Here is an example ```TestTree.luau``` module:

```lua
--!strict
local RbxBehaviorTree = require(path.to.RbxBehaviorTree)

local FallbackNode = RbxBehaviorTree.FallbackNode
local SequenceNode = RbxBehaviorTree.SequenceNode
local ActionNode = RbxBehaviorTree.ActionNode

return function(object: any)
	object:SetAttribute("Number", 0)

	local nodeTree = SequenceNode {
		FallbackNode {
			ActionNode(function()
				print("First action succeeded!")
				return "SUCCESS"
			end),
			ActionNode(function()
				warn("We will never get here!")
				return "FAILURE"
			end),
		},
		SequenceNode {
			FallbackNode {
				ActionNode(function()
					print("Second action succeeded!")
					return "SUCCESS"
				end),
				ActionNode(function()
					warn("We will never get here!")
					return "FAILURE"
				end),
			},
			ActionNode(function()
				local currentNumber = object:GetAttribute("Number")

				if currentNumber >= 5 then
					print("Third action succeeded!")
					return "SUCCESS"
				else
					print("Incrementing number...")
					object:SetAttribute("Number", currentNumber + 1)
					return "RUNNING"
				end
			end),
			ActionNode(function()
				warn("Fourth action succeeded!")
				return "SUCCESS"
			end),
		},
	}

	return RbxBehaviorTree.New(1, nodeTree)
end
```

You can now create a new TestTree behavior tree and clean it up after 10 seconds with the following code:

```lua
local TestTree = require(path.to.TestTree)

local newTestTree = TestTree(workspace.Baseplate)
task.wait(10)
newTestTree() --destroy newTestTree
```