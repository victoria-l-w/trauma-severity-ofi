scores
------
`.t` -> `.t`/`.n`/`.p`.

- **model**: `x[['model']]`
- **OR** 
  - value: `x[['or']]`
  - CI lower bound: `x[['or.ci.lo']]`
  - CI upper bound: `x[['or.ci.hi']]`
  - p-value: `x[['or.p']]`
- **ROC**: `plot(x[['roc']])`
- **AUC**
  - value: `x[['auc']]`
  - CI lower bound: `x[['auc.ci.lo']]`
  - CI upper bound: `x[['auc.ci.hi']]`
- **ICI**
  - value: `x[['ici']]`
  - CI lower bound: `x[['ici.ci']][1]`
  - CI upper bound: `x[['ici.ci']][2]`  
- **accuracy**
  - plottable: `x[['acc']]`
  - max accuracy: `x[['acc.max']]`
  - cutoff: `x[['acc.co']]`
  - CI lower bound: `x[['acc.ci']][1]`
  - CI upper bound: `x[['acc.ci']][2]`  

delta
------
`xx` -> `tn`/`tp`/`np`

- **AUC delta**
  - value: `d[['auc']][['xx']][1]`
  - CI lower bound: `d[['auc']]['xx']][2]`
  - CI upper bound: `d[['auc']]['xx']][3]`
  - p: `d[['auc']][['xx']][4]`
- **accuracy delta**
  - value: `d[['acc']][['xx']]`
  - CI lower bound: `d[['acc']][['xx.ci']][1]`
  - CI upper bound: `d[['acc']][['xx.ci']][2]`
- **ICI delta**
  - value: `d[['ici']][['xx']]`
  - CI lower bound: `d[['ici']][['xx.ci']][1]`
  - CI upper bound: `d[['ici']][['xx.ci']][2]`

exclusion
---------
- **starting value**: `exclusion[1,2]`
- **ofi**
  - included: `exclusion[2,2]`
  - excluded: `exclusion[2,3]`
- **age**
  - included: `exclusion[3,2]`
  - excluded: `exclusion[3,3]`
- **doa**
  - included: `exclusion[4,2]`
  - excluded: `exclusion[4,3]`
- **parameters**
  - included: `exclusion[5,2]`
  - excluded: `exclusion[5,3]`
- **total**
  - included: `exclusion[6,2]`
  - excluded: `exclusion[6,3]`
- **excluded post-ofi**: `exclusion[7,3]`

missing data
------------
- **age**: na.data[['age']]
- **gcs**: na.data[['gcs']]
- **asa**: na.data[['asa']]
- **rr**: na.data[['rr']]
- **sbp**: na.data[['sbp']]
- **iss**: na.data[['iss']]
- **niss**: : na.data[['niss']]
- **dominant injury**: na.data[['dominj']]
- **gender**: na.data[['gender']]

descriptive data
---------------
- **age**
  - value: `dd['age']`
  - iqr lower bound: `dd['age.lo']`
  - iqr upper bound: `dd['age.hi']`
- **iss**
  - value: `dd['iss']`
  - iqr lower bound: `dd['iss.lo']`
  - iqr upper bound: `dd['iss.hi']`
- **triss**
  - value: `dd['t.med']`
  - iqr lower bound: `dd['t.lo']`
  - iqr upper bound: `dd['t.hi']`
- **normit**
  - value: `dd['n.med']`
  - iqr lower bound: `dd['n.lo']`
  - iqr upper bound: `dd['n.hi']`
- **ps**
  - value: `dd['p.med']`
  - iqr lower bound: `dd['p.lo']`
  - iqr upper bound: `dd['p.hi']`
- **ofi**
  - no. true: `dd['ofi.true']`
  - no. false: `dd['ofi.false']`
  - % true: `dd['ofi.pc']`
  - % ofi in deceased: `dd['ofi.mort']`
- **% male**: `dd['male']`
- **% blunt**: `dd['blunt']`
- **survival**
  - no. missing data: `dd['survival.na']`
  - % 30-day mortality: `dd['mort']`
- **icu**
  - no. missing data: `dd['care.na']`
  - % icu stay: `dd['icu']`
