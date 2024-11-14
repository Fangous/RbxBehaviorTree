"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[831],{36725:e=>{e.exports=JSON.parse('{"functions":[{"name":"New","desc":"Creates a new behavior tree with a given tick frequency and root node. The behavior tree will automatically update at the given frequency until it is destroyed. This function returns a function that can be called to destroy the behavior tree.","params":[{"name":"tickFrequency","desc":"Frequency at which the behavior tree is updated (in seconds).","lua_type":"number"},{"name":"rootNode","desc":"The root node of the behavior tree.","lua_type":"Node"},{"name":"cleanup","desc":"Optional function to run after the behavior tree is destroyed.","lua_type":"(() -> ())?"}],"returns":[{"desc":"Returns a function to destroy the behavior tree.","lua_type":"function"}],"function_type":"static","source":{"line":99,"path":"src/init.luau"}},{"name":"FallbackNode","desc":"Primitive for creating a FallbackNode. Think of this as your typical \\"OR\\" gate in programming. The first child node to return `SUCCESS` will cause the FallbackNode to return `SUCCESS`.","params":[{"name":"nodeName","desc":"Name of the fallback node.","lua_type":"string"},{"name":"nodeTree","desc":"Array of child nodes for the Fallback node.","lua_type":"NodeTree"}],"returns":[{"desc":"Returns a new Fallback node.","lua_type":"Node"}],"function_type":"static","source":{"line":138,"path":"src/init.luau"}},{"name":"SequenceNode","desc":"Primitive for creating a SequenceNode. Think of this as your typical \\"AND\\" gate in programming. All child nodes must return `SUCCESS` for the SequenceNode to return `SUCCESS`.","params":[{"name":"nodeName","desc":"Name of the sequence node.","lua_type":"string"},{"name":"nodeTree","desc":"Array of child nodes for the Sequence node.","lua_type":"NodeTree"}],"returns":[{"desc":"Returns a new Sequence node.","lua_type":"Node"}],"function_type":"static","source":{"line":156,"path":"src/init.luau"}},{"name":"ActionNode","desc":"Primitive for creating an custom action to be used within a NodeTree. An ActionNode cannot be a behavior tree\'s root node, as then there would be no \\"tree\\" to traverse.","params":[{"name":"nodeName","desc":"Name of the action node.","lua_type":"string"},{"name":"action","desc":"A function that defines the action and returns a `NodeResult`.","lua_type":"NodeAction"}],"returns":[{"desc":"Returns a new Action node.","lua_type":"Node"}],"function_type":"static","source":{"line":174,"path":"src/init.luau"}}],"properties":[{"name":"NodeResults","desc":"Enumeration of possible results for a node after execution.","lua_type":"{ [string]: NodeResult }","source":{"line":83,"path":"src/init.luau"}}],"types":[{"name":"Node","desc":"A single node in a behavior tree.","fields":[{"name":"Type","lua_type":"NodeType","desc":""},{"name":"TickNode","lua_type":"(subTree: NodeTree) -> NodeResult","desc":""},{"name":"SubTree","lua_type":"NodeTree","desc":""}],"source":{"line":22,"path":"src/init.luau"}},{"name":"NodeTree","desc":"An array of `Node` elements representing a tree structure.","lua_type":"{Node}","source":{"line":34,"path":"src/init.luau"}},{"name":"NodeType","desc":"Possible node types that define behavior when ticked.","lua_type":"\\"FALLBACK\\" | \\"SEQUENCE\\" | \\"ACTION\\"","source":{"line":41,"path":"src/init.luau"}},{"name":"NodeResult","desc":"Possible results for a node after execution.","lua_type":"\\"SUCCESS\\" | \\"FAILURE\\" | \\"RUNNING\\"","source":{"line":48,"path":"src/init.luau"}},{"name":"NodeAction","desc":"","lua_type":"() -> NodeResult","source":{"line":53,"path":"src/init.luau"}}],"name":"RbxBehaviorTree","desc":"A module for creating and managing behavior trees. Behavior trees are commonly used in game AI to control NPC behavior.\\n\\nProvides nodes and functions to create complex behavior trees with fallback, sequence, and action nodes.","source":{"line":8,"path":"src/init.luau"}}')}}]);