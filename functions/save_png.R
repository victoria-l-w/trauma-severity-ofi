save_png <- function(diagram = diagram, name = "") {
  if(name == "") {
    message("No filename given for export to png")
  }
  diagram %>% export_svg() %>% charToRaw() %>% rsvg::rsvg_png(paste0("images/", name, ".png"))
}