--!strict
local RunService = game:GetService("RunService")

local Trove = require(script.Parent.Trove)
local Timer = require(script.Parent.Timer)

export type NodeResult = "SUCCESS" | "FAILURE" | "RUNNING"
export type NodeType = "FALLBACK" | "SEQUENCE" | "ACTION"
export type NodeAction = () -> NodeResult
export type NodeTree = { Node }
export type Node = {
	NodeType: NodeType,
	TickNode: (subTree: NodeTree) -> NodeResult,
	SubTree: NodeTree,
}

local function scanTreeForResult(subTree: NodeTree, excludedResult: NodeResult): NodeResult
	for _, child in subTree do
		local result = child.TickNode(child.SubTree)

		if result ~= excludedResult then
			return result :: NodeResult
		end
	end

	return excludedResult
end

local function tickFallbackNode(subTree: NodeTree): NodeResult
	return scanTreeForResult(subTree, "FAILURE")
end

local function tickSequenceNode(subTree: NodeTree): NodeResult
	return scanTreeForResult(subTree, "SUCCESS")
end

local BehaviorTree = {}

function BehaviorTree.New(tickFrequency: number, rootNode: Node)
	local treeTrove = Trove.new()
	local runningNode: Node? = nil

	local function tickNode(node: Node): NodeResult
		local result = node.TickNode(node.SubTree)

		if result == "RUNNING" then
			runningNode = node
		elseif result == "SUCCESS" or result == "FAILURE" then
			runningNode = nil
		end

		return result :: NodeResult
	end

	treeTrove:Add(Timer.Simple(tickFrequency, function()
		tickNode(runningNode or rootNode)
	end, true, RunService.Heartbeat, os.clock))

	return function()
		treeTrove:Destroy()
	end
end

function BehaviorTree.FallbackNode(nodeTree: NodeTree): Node
	return {
		NodeType = "FALLBACK",
		TickNode = tickFallbackNode,
		SubTree = nodeTree,
	}
end

function BehaviorTree.SequenceNode(nodeTree: NodeTree): Node
	return {
		NodeType = "SEQUENCE",
		TickNode = tickSequenceNode,
		SubTree = nodeTree,
	}
end

function BehaviorTree.ActionNode(action: NodeAction): Node
	return {
		NodeType = "ACTION",
		TickNode = function()
			return action()
		end,
		SubTree = {},
	}
end

return BehaviorTree
