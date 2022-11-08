scores
------
`.t` -> `.t`/`.n`/`.p`.

- **model**: `results[['t'][['model']]`
- **OR** 
  - **value**: `results[['t'][['or']]`
  - **CI lower bound**: `results[['t'][['or.ci.lo']]`
  - **CI upper bound**: `results[['t'][['or.ci.hi']]`
  - **p-value**: `results[['t'][['or.p']]`
- **ROC**: `plot(results[['t'][['roc']])`
- **AUC**
  - **value**: `results[['t'][['auc']]`
  - **CI lower bound**: `results[['t'][['auc.ci.lo']]`
  - **CI upper bound**: `results[['t'][['auc.ci.hi']]`
- **ICI**
  - **value**: `results[['t'][['ici']]`
  - **CI lower bound**: `results[['t'][['ici.ci']][[1]]`
  - **CI upper bound**: `results[['t'][['ici.ci']][[2]]`  
- **accuracy**
  - **plottable**: `results[['t'][['acc']]`
  - **max accuracy**: `results[['t'][['acc.nrs']][[1]]`
  - **cutoff**: `results[['t'][['acc.nrs']][[2]]`
  - **CI lower bound**: `results[['t'][['acc.ci']][[1]]`
  - **CI upper bound**: `results[['t'][['acc.ci']][[2]]`  

delta
------
`xx` -> `tn`/`tp`/`np`

- **AUC delta**
  - **value**: `results[['delta']][['auc']][['xx']][[1]]`
  - **CI lower bound**: `results[['delta']][['auc']][['xx']][[2]]`
  - **CI upper bound**: `results[['delta']][['auc']][['xx']][[3]]`
  - **p**: `results[['delta']][['auc']][['xx']][[4]]`
- **accuracy delta**
  - **value**: ``
  - **CI lower bound**: ``
  - **CI upper bound**: ``
- **ICI delta**
  - **value**: ``
  - **CI lower bound**: ``
  - **CI upper bound**: ``
