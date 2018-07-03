Array::indexOf or= (item) ->
  for x, i in this
    return i if x is item
  return -1

data = JSON.parse Utils.domLoadDataSync "data/data.json"

gutter = 20
padding = 16
count = data.buckets.length
boxSize = (Screen.width-3*padding)/2
thumbSize = ((Screen.width-3.5*padding-back.width)/3)*1.3
focusedBoxHeight = 124	
bucketThumbnailsContainerHeight = thumbSize + 2*padding
activeBucket = null

class BucketThumb extends Layer
	constructor: (@options={}) ->
		@options.width ?= thumbSize*.7
		@options.height ?= thumbSize
		@options.backgroundColor ?= "rgba(255,255,255,0)"
		
			
		@label = new TextLayer
			fontSize: 16

			
		@thumb = new Layer
					
		super @options
		
		@label.parent = @
		@label.centerX()
		@label.textAlign = "center"
		@label.state = "default"
		@label.width = @options.width
		@label.autoHeight = yes
		@label.y = thumbSize*0.75
		@label.centerX()
		@label.color = "rgba(255,255,255,1)"
		@label.fontStyle = "bold"
		@label.opacity = 0.7
		
		@thumb.parent = @
		@thumb.width = thumbSize*0.7
		@thumb.height = thumbSize*0.7
		@thumb.borderRadius = thumbSize*0.4
		@thumb.borderColor = "rgba(255,255,255,0)"
		@thumb.borderWidth = thumbSize*0.04
		@thumb.centerX()
		@thumb.state = "default"
		
		@thumb.states = 
			active:
				borderColor : "#ffffff"
			default:
				borderColor : "rgba(255,255,255,0)"
		
		@label.states = 
			active:
				fontWeight: 600
				opacity: 1
			default:
				fontWeight: 400
				opacity: 0.4
				
		@onClick ->
			if @.thumb.state == "default"
				@.thumb.states.switchInstant "active"
				@.thumb.state = "active"
				@.label.states.switchInstant "active"
				@.label.state = "active"
				newActiveBucket = (item for item in bucketBoxes when item.thumb == @)[0]
				newActiveBucket.states.switchInstant "active"
				newActiveBucket.state = "active"
				newActiveBucket.visible = true
				activeBucket = newActiveBucket
				newBucketIndex = bucketBoxes.indexOf(newActiveBucket)
				centerBucket = if newBucketIndex > 1 then bucketBoxes[newBucketIndex-1] 								else newActiveBucket
				bucketThumbnailsContainer.scrollToLayer(centerBucket.thumb)
				bucketThumbnailsContainer.states.active =
					x: padding
					parent: newActiveBucket
					visible: true
					backgroundColor: newActiveBucket.backgroundColor
				bucketThumbnailsContainer.states.switchInstant "active"
				bucketThumbnailsContainer.state = "active"
				back.visible = true
				back.parent = newActiveBucket
				activeIndex = bucketBoxes.indexOf(newActiveBucket)
				for inActiveBucketBox, index in bucketBoxes
					if index != activeIndex
						inActiveBucketBox.visible = false
						inActiveBucketBox.thumb.thumb.states.switchInstant "default"
						inActiveBucketBox.thumb.thumb.state = "default"
						inActiveBucketBox.thumb.label.states.switchInstant "default"
						inActiveBucketBox.thumb.label.state = "default"
				for tagLayer in tagsContainer.content.children
					tagLayer.destroy()
				tagsContainer.visible = false		
				for tagObject, index in newActiveBucket.tags
					tagLayer = comp_tag.copy()
					tagLayer.parent = tagsContainer.content
					tagLayer.originX = 0
					tagLayer.scale = 1.4
					tagLayer.x = tagsContainer.frame.x
					tagLayer.y = index*(tagLayer.height + padding)
					tag_name.text = tagObject.name
					tag_trend.text = tagObject.trend	
				tagsContainer.visible = true
		
class Bucket extends Layer
	constructor: (@options={}) ->
		@options.width ?= boxSize
		@options.height ?= boxSize
		@options.borderRadius ?= "16px"
		
		@label = new TextLayer
			fontSize: 16
			color: "rgba(255,255,255,1)"
		@thumbnail = new Layer
			width: @options.width*0.6
			height: @options.height*0.6
			borderRadius:  @options.height*0.3
		
		super @options
				
		@thumbnail.parent = @
		@thumbnail.centerX()
		@thumbnail.y = 16
		@thumbnail.state = "default"
		@label.parent = @
		@label.centerX()
		@label.textAlign = "center"
		@label.state = "default"
		@label.width = @thumbnail.width
		@label.autoHeight = yes
		@label.y = @thumbnail.y + @thumbnail.height + 16
		
		@states =
			default:
				height: @options.height
				width: @options.width
				x: @options.x
				y: @options.y
				borderRadius: "16px"
			active:	
				height: bucketThumbnailsContainerHeight + 2*padding
				width: Screen.width
				x: 0
				y: 0
				borderRadius: "0px"
				animationOptions: 
					curve: Bezier.easeOut
					time: 0.1	
		@label.states =
			default:
				x: @thumbnail.x
				y: @thumbnail.y + @thumbnail.height + 16
				textAlign: "center"
				width: @thumbnail.width
				autoHeight: yes
				animationOptions: 
					curve: Bezier.linear
					time: 0.1	
			active:
				x: @thumbnail.x + @thumbnail.width + padding
				y: @thumbnail.y + @thumbnail.height*0.8
				textAlign: "center"
				width: @thumbnail.width
				autoHeight: yes
				animationOptions: 
					curve: Bezier.linear
					time: 0.1		
				
		@thumbnail.states =
			default:
				x: @options.width*0.2
				y: 16
				width: @options.width*0.6
				height: @options.height*0.6
				borderRadius:  @options.height*0.3
				animationOptions: 
					curve: Bezier.easeIn
					time: 0.1	
			active:
# 				x: @options.width*0.2
# 				y: 16 + bucketThumbnailsContainerHeight + 0.4*padding
# 				textAlign: "center"
				width: 0
				height: 0
# 				autoHeight: yes
				animationOptions: 
					curve: Bezier.easeOut
					time: 0.1		
		
		@.onClick ->
			if @.state != "active"
				scroll.scrollToTop()
				scroll.scrollHorizontal = false
				scroll.scrollVertical = false
				@.states.switchInstant "active"
				@.state = "active"
				bucketThumbnailsContainer.states.active =
					parent: @
					visible: true
					backgroundColor: @.backgroundColor
					x: padding
				bucketThumbnailsContainer.states.switchInstant "active"
				bucketThumbnailsContainer.state = "active"
				bucketThumbnailsContainer.scrollToLayer(@.thumb)
				back.visible = true
				back.parent = @
				@.thumb.thumb.states.switchInstant "active"
				@.thumb.thumb.state = "active"
				@.thumb.label.states.switchInstant "active"
				@.thumb.label.state = "active"
				activeBucket = @
				activeIndex = bucketBoxes.indexOf(@)
				for inActiveBucketBox, index in bucketBoxes
					inActiveBucketBox.label.states.switchInstant "active"
					inActiveBucketBox.label.state = "active"
					inActiveBucketBox.thumbnail.states.switchInstant "active"
					inActiveBucketBox.thumbnail.state = "active"
					
					if index != activeIndex
						inActiveBucketBox.visible = false
						
				for tagObject, index in @.tags
					tagLayer = comp_tag.copy()
					tagLayer.parent = tagsContainer.content
					tagLayer.originX = 0
					tagLayer.scale = 1.4
					tagLayer.x = tagsContainer.frame.x
					tagLayer.y = index*(tagLayer.height + padding)
					tag_name.text = tagObject.name
					tag_trend.text = tagObject.trend	
				tagsContainer.visible = true

bucketBoxes = []

bucketsCont = new Layer
	width: Screen.width
	height: (count/2)*(boxSize+padding) + padding
	backgroundColor: "#ffffff"
	parent : screen_1
	
scroll = ScrollComponent.wrap(bucketsCont)
scroll.scrollHorizontal = false
scroll.content.clip = false
scroll.directionLock = true
scroll.backgroundColor = "rgba(255,255,255,0)"
scroll.mouseWheelEnabled = true

tagsContainer = new ScrollComponent
	width: Screen.width
	height: Screen.height - 2*padding
	centerX: screen_1.centerX
	y: 3*padding + bucketThumbnailsContainerHeight
	backgroundColor: "#fffff"
tagsContainer.parent = bucketsCont
tagsContainer.scrollHorizontal = false
tagsContainer.backgroundColor = "#fffff"
tagsContainer.mouseWheelEnabled = true
tagsContainer.visible = false
tagsContainer.content.clip = false
tagsContainer.directionLock = true
tagsContainer.centerX()
tagsContainer.contentInset = 
		right: 2*padding
		left: 3*padding
		top: 0.4*padding
		bottom: padding

bucketThumbnailsContainer = new ScrollComponent
	width: Screen.width
	height: bucketThumbnailsContainerHeight + padding
	x: back.x + back.width + padding
bucketThumbnailsContainer.parent = bucketsCont
bucketThumbnailsContainer.scrollHorizontal = true
bucketThumbnailsContainer.scrollVertical = false
bucketThumbnailsContainer.visible = false
bucketThumbnailsContainer.mouseWheelEnabled = true
bucketThumbnailsContainer.content.clip = false
bucketThumbnailsContainer.directionLock = true
bucketThumbnailsContainer.state = "default"
bucketThumbnailsContainer.contentInset = 
		right: padding
		left: 0
		top: 3.6*padding
		bottom: 0.4*padding		

bucketThumbnailsContainer.states =
	default:
		x: padding
		parent: bucketsCont
		scrollVertical: false
		visible: false
		
back.visible = false
back.parent = bucketsCont
back.scale = 1.2
back.y = 0.6*padding
back.x = 1.6*padding
	
back.onTap ->
	back.visible = false
	bucketThumbnailsContainer.states.switchInstant "default"
	bucketThumbnailsContainer.state = "default"
	for bucketBox in bucketBoxes
		bucketBox.visible = true
		bucketBox.states.switch "default"
		bucketBox.state = "default"
		bucketBox.label.states.switchInstant "default"
		bucketBox.label.state = "default"
		bucketBox.thumbnail.states.switchInstant "default"
		bucketBox.thumbnail.state = "default"
		bucketBox.thumb.thumb.states.switchInstant "default"
		bucketBox.thumb.thumb.state = "default"
		bucketBox.thumb.label.states.switchInstant "default"
		bucketBox.thumb.label.state = "default"
	scroll.scrollHorizontal = false
	scroll.scrollVertical = true
	bucketsCont.width = Screen.width
	for tagLayer in tagsContainer.content.subLayers
		tagLayer.destroy()
	tagsContainer.visible = false

	
for bucketObject, index in data.buckets
	bucketBox = new Bucket
	bucketBox.parent = bucketsCont
	bucketBox.width = boxSize
	bucketBox.height = boxSize	
	xPosition = if (index%2 != 0 and index !=0) then bucketBox.width + 2*padding 				else padding
	bucketBox.x = xPosition
	yPosition = 2*padding + (Math.floor(index/2)) *(bucketBox.width+padding)
	bucketBox.y = yPosition 
	bucketBox.states.default =
				height: boxSize
				width: boxSize
				x: xPosition
				y: yPosition
				animationOptions: 
					curve: Bezier.ease
					time: 0.1
	bucketBox.state = "default"			
	bucketBox.backgroundColor = bucketObject.backgroundColor	
	bucketBox.label.text = bucketObject.name
	bucketBox.thumbnail.image = Utils.randomImage()
	bucketBox.tags = bucketObject.tags
	bucketBoxThumb = new BucketThumb
		x:index*(.8*padding+thumbSize*0.8)
	bucketBoxThumb.parent = bucketThumbnailsContainer.content
	bucketBoxThumb.thumb.image = bucketBox.thumbnail.image
	bucketBoxThumb.label.text = bucketObject.name
	bucketBox.thumb = bucketBoxThumb
	bucketBox.thumb.state = "default"
	bucketBoxes.push(bucketBox)	
	
