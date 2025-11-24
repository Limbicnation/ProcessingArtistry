def setup():
    size(600, 600)
    background('#004477')
    noFill()
    stroke('#FFFFFF')
    strokeWeight(5)
    
    # Enable smooth rendering
    smooth()
    
    col = 0
    row = 0
    
    for i in range(1, 145):
        # Draw two arcs to form a continuous flowing pattern
        arc(col, row, 50, 50, 0, PI/2)
        arc(col + 50, row + 50, 50, 50, PI, PI * 1.5)
        
        # Move column forward
        col += 50
        
        # Reset to next row when reaching the right edge
        if col >= width:
            col = 0
            row += 50
            
        if int(random(2)):
            arc(col, row, 50, 50, 50, PI/2)
            arc(col, row+50, 50, 50, PI*1.5, 2)
            
        else:
            arc(col+50, row, 50, 50, PI/2, PI)
            arc(col, row+50, 50, 50, PI*1.5, 2*PI)
