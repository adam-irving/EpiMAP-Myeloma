**********
	*SIM SCT
**********

	*Patient matrix	
		mata: `=m' = mCore , mLO , mCom
		mata: r`=m' = rmCore
		mata: c`=m' = cmCore \ cmLO \ cmCom 
		mata: `=m'[.,`=c'RN] = runiform(`=Obs',1)	
		mata: _matrix_list(`=m', r`=m', c`=m')
		
	*Determine outcome
		forvalues i = 1/`=Obs'{
			*Calculate xb
				*Age
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',cAge] * `=b'[1,1])
				*Age2
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',cAge]^2 * `=b'[1,2])
				*Male 
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',cMale] * `=b'[1,3])
				*ECOGcc
					mata {
						if 		(`=m'[`i',cECOGc] == 1) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,5] 
						else if (`=m'[`i',cECOGc] == 2) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,6] 
					}
				*ISS
					mata {
						if 		(`=m'[`i',cISS] == 2) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,8]
						else if (`=m'[`i',cISS] == 3) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,9]
					}
				*BCR
					mata {
						if		(`=m'[`i',cBCR] == 2) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,11]
						else if	(`=m'[`i',cBCR] == 3) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,12] 
						else if	(`=m'[`i',cBCR] == 4) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,13] 
						else if	(`=m'[`i',cBCR] == 5) `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,14]  
					}
				*Age70
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',15] * `=b'[1,15])
				*Age75
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',16] * `=b'[1,16])
				*CMCard
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',17] * `=b'[1,17])
				*CMPulm
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',18] * `=b'[1,18])	
				*CMDiab
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',19] * `=b'[1,19])
				*CMLive
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',20] * `=b'[1,20])
				*CMPNeur
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',21] * `=b'[1,21])
				*CMMali
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + (`=m'[`i',22] * `=b'[1,22])
				*cons
					mata: `=m'[`i',`=c'XB] = `=m'[`i',`=c'XB] + `=b'[1,23]
	
			*Calculate probability: p = 1/(1 + e^-xb)
				mata: `=m'[`i',`=c'PR] = 1:/(1:+exp(-`=m'[`i',`=c'XB]))	

			*Compare with RN - filter out CR_L1 == 7 & BCR_L1 == 6
				mata {
					if 		(mMOR[`i',`=OMC'-1] == 0 & `=m'[`i',`=c'PR] > `=m'[`i',`=c'RN] & `=m'[`i',cCR] != 7 & `=m'[`i',cBCR] != 6) `=m'[`i',`=c'OC] = 1
					else if (mMOR[`i',`=OMC'-1] != 0 | `=m'[`i',`=c'PR] < `=m'[`i',`=c'RN] | `=m'[`i',cCR] == 7 | `=m'[`i',cBCR] == 6) `=m'[`i',`=c'OC] = 0
				}
					
			*Update mCore
				mata: mCore[`i',cSCT] = `=m'[`i',`=c'OC]
		}
