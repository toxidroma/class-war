return unless CLIENT
class ClassWar extends FONT
    font: 'Arial'
    weight: 500
    size: 13

class Bold extends ClassWar
    weight: 1000

class Italic extends ClassWar
    italic: true

class Drunk extends Italic
    blursize: 4
    size: 42