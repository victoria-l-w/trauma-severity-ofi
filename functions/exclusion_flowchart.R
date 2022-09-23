exclusion_flowchart <- function(inclusion.counts) {
  
  exclusion.flowchart <- grViz("digraph flowchart {
    ## the real nodes
    node [shape = rectangle, width = 8, fontsize = 18] 
      1 [label = '@@1']
      2 [label = '@@2']
      3 [label = '@@3']
      4 [label = '@@4']
      5 [label = '@@5']
      m1 [label = '@@6']
      m2 [label = '@@7']
      m3 [label = '@@8']
      m4 [label = '@@9']
    
    ## the fake nodes to create arrows halfway
    node [shape=none, width=0, height=0, label='']
    p1 -> 2; p2 -> 3; p3 -> 4; p4 -> 5;
      {rank=same; p1 -> m1}
      {rank=same; p2 -> m2}
      {rank=same; p3 -> m3}
      {rank=same; p4 -> m4}

    edge [dir=none]
    1 -> p1; 2 -> p2; 3 -> p3; 4 -> p4;
  }

  [1]: paste0(inclusion.counts[1,2], ' patients in trauma registry')
  [2]: paste0(inclusion.counts[2,2], ' patients')
  [3]: paste0(inclusion.counts[3,2], ' patients')
  [4]: paste0(inclusion.counts[4,2], ' patients')
  [5]: paste0(inclusion.counts[5,2], ' patients included')
  [6]: paste0('Excluded due to no outcome from M&M review \\n(n =  ', inclusion.counts[2,3], ')')
  [7]: paste0('Excluded due to <15 years of age \\n(n = ', inclusion.counts[3,3], ')')
  [8]: paste0('Excluded due to DOA \\n(n = ', inclusion.counts[4,3], ')')
  [9]: paste0('Excluded due to lacking necessary parameters for analysis \\n(n = ', inclusion.counts[5,3], ')')
                               
                               ")
  return(exclusion.flowchart)
}