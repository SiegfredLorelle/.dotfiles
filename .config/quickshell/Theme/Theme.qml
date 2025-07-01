pragma Singleton
import QtQuick

QtObject {
    // Colors
    readonly property color secondaryColor: "#236376"
    readonly property color secondaryLightColor: "#4A8296" // Lighter shade 1
    readonly property color secondaryLighterColor: "#72A1B3" // Lighter shade 2
    readonly property color primaryColor: "#E6C871"
    readonly property color primaryLightColor: "#EDD69B" // Lighter shade 1
    readonly property color primaryLighterColor: "#F3E3C5" // Lighter shade 2
    
    // Fonts
    readonly property string primaryFont: "JetBrainsMono Nerd Font"
    readonly property string iconFont: "Material Symbols Rounded"
    
    // Font Sizes
    readonly property int normalFontSize: 9
    readonly property int mediumFontSize: 11
    readonly property int largeFontSize: 14
    readonly property int iconSize: 16
    
    // Spacing & Dimensions
    readonly property int smallSpacing: 2
    readonly property int normalSpacing: 4
    readonly property int largeSpacing: 8
    readonly property int borderRadius: 10
    readonly property int barGap: 14
}
