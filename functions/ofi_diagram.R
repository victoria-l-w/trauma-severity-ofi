## Makes a flowchart on how patients are selected for M&M

ofi_diagram <- function() {
  
ofi_diagram <- DiagrammeR::grViz("digraph flowchart {
  # node definitions with substituted label text
  node [fontname = Helvetica, shape = rectangle]        
  tab1 [label = '@@1']
  tab2 [label = '@@2']
  tab3 [label = '@@3']
  tab4 [label = '@@4']
  tab5 [label = '@@5']
  tab6 [label = '@@6']
  tab7 [label = '@@7'] 
  
  # edge definitions with the node IDs
  tab1 -> tab2 -> tab3 -> tab4 -> tab5;
  tab5 -> tab6;
  tab5 -> tab7;
}

  [1]: 'Trauma team activation'
  [2]: 'Inclusion in registry according to SweTrau criteria described in 3.3.3'
  [3]: 'Audit filters and primary review by experienced nurseand audit filters'
  [4]: 'Secondary review by another experienced nurse'
  [5]: 'Multidisciplinary morbidity and mortality conference'
  [6]: 'Opportunities for improvement found'
  [7]: 'No opportunities for improvement found'
") 

## %>% DiagrammeRsvg::export_svg() %>% charToRaw() %>% rsvg::rsvg_pdf("swetrau_flowchart.pdf")
## Cannot to install DiagrammeRsvg b/c can't install v8 b/c "fatal error: v8.h: no such file or directory"
}
  


