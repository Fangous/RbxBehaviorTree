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
	NodeName: string,
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

	Possible node types that define behavior when ticked.
]=]
export type NodeType = "SEQUENCE" | "FALLBACK" | "ACTION"
--[=[
	@type NodeResult "SUCCESS" | "FAILURE" | "RUNNING"
	@within RbxBehaviorTree

	Possible results for a node after execution.
]=]
export type NodeResult = "SUCCESS" | "FAILURE" | "RUNNING"
--[=[
	@type NodeAction () -> NodeResult
	@within RbxBehaviorTree
]=]
export type NodeAction = () -> NodeResult
--[=[
	@interface BehaviorTree
	@within RbxBehaviorTree
	.RootNode Node
	.Destroy () -> ()

	A behavior tree with a root node and a destroy function.
]=]
export type BehaviorTree = {
	RootNode: Node,
	Destroy: () -> (),
}

local isStudio = RunService:IsStudio()

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
	@prop NodeResults { [string]: NodeResult }
	@within RbxBehaviorTree

	Enumeration of possible results for a node after execution.
]=]
BehaviorTree.NodeResults = {
	["SUCCESS"] = "SUCCESS",
	["FAILURE"] = "FAILURE",
	["RUNNING"] = "RUNNING",
} :: { [string]: NodeResult }

--[=[
	@prop NodeTypes { [string]: NodeType }
	@within RbxBehaviorTree

	Enumeration of possible node types that define behavior when ticked.
]=]
BehaviorTree.NodeTypes = {
	["SEQUENCE"] = "SEQUENCE",
	["FALLBACK"] = "FALLBACK",
	["ACTION"] = "ACTION",
} :: { [string]: NodeType }

--[=[
	@function New
	@within RbxBehaviorTree
	@param tickFrequency number -- Frequency at which the behavior tree is updated (in seconds).
	@param rootNode Node -- The root node of the behavior tree.
	@param cleanup (() -> ())? -- Optional function to run after the behavior tree is destroyed.
	@return BehaviorTree -- Returns a new behavior tree.

	Creates a new behavior tree with a given tick frequency and root node. The behavior tree will automatically update at the given frequency until it is destroyed. This function returns a function that can be called to destroy the behavior tree.
]=]
function BehaviorTree.New(tickFrequency: number, rootNode: Node, cleanup: (() -> ())?): BehaviorTree
	assert(rootNode.NodeType ~= "ACTION", "'rootNode' cannot be an action node. Must be a fallback or sequence node.")

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

	if not isStudio then
		treeTrove:Add(Timer.Simple(tickFrequency, function()
			tickNode(runningNode or rootNode)
		end, true, RunService.Heartbeat, os.clock))
	end

	if cleanup then
		treeTrove:Add(cleanup)
	end

	return {
		RootNode = rootNode,
		Destroy = function()
			treeTrove:Destroy()
		end,
	}
end

--[=[
	@function SequenceNode
	@within RbxBehaviorTree
	@param nodeName string -- Name of the sequence node.
	@param nodeTree NodeTree -- Array of child nodes for the Sequence node.
	@return Node -- Returns a new Sequence node.

	Primitive for creating a SequenceNode. Think of this as your typical "AND" gate in programming. All child nodes must return `SUCCESS` for the SequenceNode to return `SUCCESS`.
]=]
function BehaviorTree.SequenceNode(nodeName: string, nodeTree: NodeTree): Node
	return {
		NodeName = nodeName,
		NodeType = BehaviorTree.NodeTypes.SEQUENCE,
		TickNode = tickSequenceNode,
		SubTree = nodeTree,
	}
end

--[=[
	@function FallbackNode
	@within RbxBehaviorTree
	@param nodeName string -- Name of the fallback node.
	@param nodeTree NodeTree -- Array of child nodes for the Fallback node.
	@return Node -- Returns a new Fallback node.

	Primitive for creating a FallbackNode. Think of this as your typical "OR" gate in programming. The first child node to return `SUCCESS` will cause the FallbackNode to return `SUCCESS`.
]=]
function BehaviorTree.FallbackNode(nodeName: string, nodeTree: NodeTree): Node
	return {
		NodeName = nodeName,
		NodeType = BehaviorTree.NodeTypes.FALLBACK,
		TickNode = tickFallbackNode,
		SubTree = nodeTree,
	}
end

--[=[
	@function ActionNode
	@within RbxBehaviorTree
	@param nodeName string -- Name of the action node.
	@param action NodeAction -- A function that defines the action and returns a `NodeResult`.
	@return Node -- Returns a new Action node.

	Primitive for creating an custom action to be used within a NodeTree. An ActionNode cannot be a behavior tree's root node, as then there would be no "tree" to traverse.
]=]
function BehaviorTree.ActionNode(nodeName: string, action: NodeAction): Node
	return {
		NodeName = nodeName,
		NodeType = BehaviorTree.NodeTypes.ACTION,
		TickNode = function()
			return action()
		end,
		SubTree = {},
	}
end

return BehaviorTree
