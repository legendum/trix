#= require trix/views/text_view

{makeElement, getBlockAttributes} = Trix

class Trix.BlockView extends Trix.ObjectView
  constructor: ->
    super
    @block = @object
    @attributes = @block.getAttributes()

  createNodes: ->
    comment = document.createComment("block")
    nodes = [comment]
    if @block.isEmpty()
      nodes.push(makeElement("br"))
    else
      textConfig = getBlockAttributes()[@block.getLastAttribute()]?.text
      textView = @findOrCreateCachedChildView(Trix.TextView, @block.text, {textConfig})
      nodes.push(textView.getNodes()...)
      nodes.push(makeElement("br")) if @shouldAddExtraNewlineElement()

    if @attributes.length
      nodes
    else
      element = makeElement(Trix.config.blockAttributes.default.tagName)
      element.appendChild(node) for node in nodes
      [element]

  createContainerElement: (depth) ->
    attribute = @attributes[depth]
    config = getBlockAttributes()[attribute]
    makeElement(config.tagName)

  # A single <br> at the end of a block element has no visual representation
  # so add an extra one.
  shouldAddExtraNewlineElement:->
    /\n\n$/.test(@block.toString())
