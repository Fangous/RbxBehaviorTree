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
local NodeResults = RbxBehaviorTree.NodeResults

return function(object: any)
	local nodeTree

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