import QtQuick
import "root:/Theme"

Item {
    id: root
    
    // Customizable properties
    property color baseColor: Theme.primaryColor
    property real baseOpacity: 0.9
    property real gradientOpacity: 0.6
    property real borderOpacity: 0.6
    property real shadowOpacity: 0.2
    property real borderRadius: Theme.borderRadius
    property bool topLeftRadius: false
    property bool topRightRadius: false
    property bool bottomLeftRadius: false
    property bool bottomRightRadius: false
    property real borderWidth: 1
    property real shadowOffset: 2
    property real animationOpacity: 1.0  // For animated components
    
    // Border visibility controls
    property bool showBorder: true
    property bool showOuterBorder: true
    property bool showInnerShadow: true
    property bool showDropShadow: true
    
    // Convenience properties for common radius patterns
    property bool allRadius: false
    property bool leftRadius: false
    property bool rightRadius: false
    property bool topRadius: false
    property bool bottomRadius: false
    
    // Internal computed radius values
    readonly property real computedTopLeftRadius: {
        if (allRadius) return borderRadius
        if (leftRadius || topRadius) return borderRadius
        return topLeftRadius ? borderRadius : 0
    }
    
    readonly property real computedTopRightRadius: {
        if (allRadius) return borderRadius
        if (rightRadius || topRadius) return borderRadius
        return topRightRadius ? borderRadius : 0
    }
    
    readonly property real computedBottomLeftRadius: {
        if (allRadius) return borderRadius
        if (leftRadius || bottomRadius) return borderRadius
        return bottomLeftRadius ? borderRadius : 0
    }
    
    readonly property real computedBottomRightRadius: {
        if (allRadius) return borderRadius
        if (rightRadius || bottomRadius) return borderRadius
        return bottomRightRadius ? borderRadius : 0
    }
    
    // Main background with transparency
    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: root.baseColor
        opacity: root.baseOpacity * root.animationOpacity
        topLeftRadius: root.computedTopLeftRadius
        topRightRadius: root.computedTopRightRadius
        bottomLeftRadius: root.computedBottomLeftRadius
        bottomRightRadius: root.computedBottomRightRadius
    }
    
    // Glassmorphism gradient overlay
    Rectangle {
        id: gradientOverlay
        anchors.fill: parent
        opacity: root.gradientOpacity * root.animationOpacity
        topLeftRadius: root.computedTopLeftRadius
        topRightRadius: root.computedTopRightRadius
        bottomLeftRadius: root.computedBottomLeftRadius
        bottomRightRadius: root.computedBottomRightRadius
        
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#40FFFFFF" }
            GradientStop { position: 0.5; color: "#20FFFFFF" }
            GradientStop { position: 1.0; color: "#10FFFFFF" }
        }
    }
    
    // Outer border for glassmorphism effect
    Rectangle {
        id: outerBorder
        anchors.fill: parent
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, root.borderOpacity * root.animationOpacity)
        border.width: root.borderWidth
        topLeftRadius: root.computedTopLeftRadius
        topRightRadius: root.computedTopRightRadius
        bottomLeftRadius: root.computedBottomLeftRadius
        bottomRightRadius: root.computedBottomRightRadius
        visible: root.showBorder && root.showOuterBorder
    }
    
    // Subtle inner shadow effect
    Rectangle {
        id: innerShadow
        anchors {
            fill: parent
            margins: root.borderWidth
        }
        color: "transparent"
        border.color: Qt.rgba(0, 0, 0, root.shadowOpacity * root.animationOpacity)
        border.width: root.borderWidth
        topLeftRadius: Math.max(0, root.computedTopLeftRadius - root.borderWidth)
        topRightRadius: Math.max(0, root.computedTopRightRadius - root.borderWidth)
        bottomLeftRadius: Math.max(0, root.computedBottomLeftRadius - root.borderWidth)
        bottomRightRadius: Math.max(0, root.computedBottomRightRadius - root.borderWidth)
        visible: root.showBorder && root.showInnerShadow
    }
    
    // Optional drop shadow (positioned behind the component)
    Rectangle {
        id: dropShadow
        anchors {
            fill: parent
            topMargin: root.shadowOffset
            leftMargin: root.shadowOffset
        }
        color: Qt.rgba(0, 0, 0, 0.1 * root.animationOpacity)
        radius: root.borderRadius
        z: -1
        visible: root.showDropShadow && root.shadowOffset > 0
        topLeftRadius: root.computedTopLeftRadius
        topRightRadius: root.computedTopRightRadius
        bottomLeftRadius: root.computedBottomLeftRadius
        bottomRightRadius: root.computedBottomRightRadius
    }
}
