return unless CLIENT
import SetDrawColor, DrawRect from surface
export class ExamplePanel extends VGUI
    @ColorIdle: Color 255, 0, 0
    @ColorHovered: Color 0, 255, 0
    @Paint: (w, h) =>
        color = @ColorIdle
        color = @ColorHovered if @IsHovered!
        SetDrawColor color
        DrawRect 0, 0, w, h