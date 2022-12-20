## Makes a flowchart on how patients are selected for M&M

ofi_diagram <- function() {

  out <- grViz("digraph flowchart {
  
  
    ## the real nodes
    node [shape = rectangle, width = 6, fontsize = 18] 
      1 [label = '@@1']
      2 [label = '@@2']
      3 [label = '@@3']
      4 [label = '@@4']
      5 [label = '@@5']
      m1 [label = '@@6']
      m2 [label = '@@7']
      s1 [label = '@@8']
      s2 [label = '@@9']

    
    ## the fake nodes to create arrows halfway
    node [shape=none, width=0, height=0, label='']
    p1 -> 4; p2 -> 5;
      {rank=same; 3 -> s1}
      {rank=same; 4 -> s2}

    edge [dir=none]
    1 -> 2; 2 -> 3; 3 -> p1; 4 -> p2; 5 -> m1; 5 -> m2;
  }

  [1]: 'Trauma team activation'
  [2]: 'Inclusion in trauma registry according to SweTrau criteria'
  [3]: 'Audit filters and primary review by experienced nurse'
  [4]: 'Secondary review by another experienced nurse'
  [5]: 'Selected for multidisciplinary M&M conference'
  [6]: 'Opportunity for improvement found'
  [7]: 'No opportunity for improvement found'
  [8]: 'Case not selected for M&M review'
  [9]: 'Case not selected for M&M review'
  
  ")
  return(out)
}

save_ofi_png <- function(out) {
  out %>% export_svg() %>% charToRaw() %>% rsvg::rsvg_png("images/ofi.png")
}







