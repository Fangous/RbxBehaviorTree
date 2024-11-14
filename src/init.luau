--!strict
--[=[
	@class RbxBehaviorTree
	A module for creating and managing behavior trees. Behavior trees are commonly used in game AI to control NPC behavior.

	Provides nodes and functions to create complex behavior trees with fallback, sequence, and action nodes.
]=]
local RunService = game:GetService("RunService")

local Trove = require(script.Parent.Trove)
local Timer = require(script.Parent.Timer)

--[=[
	@interface Node
	@within RbxBehaviorTree
	.Type NodeType
	.TickNode (subTree: NodeTree) -> NodeResult
	.SubTree NodeTree

	A single node in a behavior tree.
]=]
export type Node = {
	NodeType: NodeType,
	TickNode: (subTree: NodeTree) -> NodeResult,
	SubTree: NodeTree,
}
--[=[
	@type NodeTree {Node}
	@within RbxBehaviorTree

	An array of `Node` elements representing a tree structure.
]=]
export type NodeTree = { Node }
--[=[
	@type NodeType "FALLBACK" | "SEQUENCE" | "ACTION"
	@within RbxBehaviorTree

	Enumeration of node types that define behavior when ticked.
]=]
export type NodeType = "FALLBACK" | "SEQUENCE" | "ACTION"
--[=[
	@type NodeResult "SUCCESS" | "FAILURE" | "RUNNING"
	@within RbxBehaviorTree

	Enumeration of possible results for a node after execution.
]=]
export type NodeResult = "SUCCESS" | "FAILURE" | "RUNNING"
--[=[
	@type NodeAction () -> NodeResult
	@within RbxBehaviorTree
]=]
export type NodeAction = () -> NodeResult

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

--[=[
	@function New
	@within RbxBehaviorTree
	@param tickFrequency number -- Frequency at which the behavior tree is updated (in seconds).
	@param rootNode Node -- The root node of the behavior tree.
	@return function -- Returns a function to destroy the behavior tree.

	Creates a new behavior tree with a given tick frequency and root node. The behavior tree will automatically update at the given frequency until it is destroyed. This function returns a function that can be called to destroy the behavior tree.
]=]
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

--[=[
	@function FallbackNode
	@within RbxBehaviorTree
	@param nodeTree NodeTree -- Array of child nodes for the Fallback node.
	@return Node -- Returns a new Fallback node.

	Primitive for creating a FallbackNode. Think of this as your typical "OR" gate in programming. The first child node to return `SUCCESS` will cause the FallbackNode to return `SUCCESS`.
]=]
function BehaviorTree.FallbackNode(nodeTree: NodeTree): Node
	return {
		NodeType = "FALLBACK",
		TickNode = tickFallbackNode,
		SubTree = nodeTree,
	}
end

--[=[
	@function SequenceNode
	@within RbxBehaviorTree
	@param nodeTree NodeTree -- Array of child nodes for the Sequence node.
	@return Node -- Returns a new Sequence node.

	Primitive for creating a SequenceNode. Think of this as your typical "AND" gate in programming. All child nodes must return `SUCCESS` for the SequenceNode to return `SUCCESS`.
]=]
function BehaviorTree.SequenceNode(nodeTree: NodeTree): Node
	return {
		NodeType = "SEQUENCE",
		TickNode = tickSequenceNode,
		SubTree = nodeTree,
	}
end

--[=[
	@function ActionNode
	@within RbxBehaviorTree
	@param action NodeAction -- A function that defines the action and returns a `NodeResult`.
	@return Node -- Returns a new Action node.

	Primitive for creating an custom action to be used within a NodeTree. An ActionNode should never be a behavior tree's root node, as then there would be no "tree" to traverse.
]=]
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
