'use strict'

###*
 # @ngdoc function
 # @name emilienkoTreeApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the emilienkoTreeApp
###
angular.module 'emilienkoTreeApp'
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
    $scope.respuestas = {}
    acetazolamida = 
        recomendado: (respuestas) ->
            !@prohibido(respuestas) and !@noRecomendado(respuestas)
        noRecomendado: (respuestas) ->
            !@prohibido(respuestas) and 
            (respuestas.insuficiencia_heptica or
            respuestas.diabetes or
            respuestas.insuficiencia_renal or
            respuestas.gota__hiperuricemia or
            respuestas.clculos_urinarios or
            respuestas.farma_carbamazepina or
            respuestas.farma_eslicarbazepina or
            respuestas.farma_fenitona or
            respuestas.farma_fenobarbital or
            respuestas.farma_primidona or
            respuestas.farma_pseudoefedrina or
            respuestas.farma_timololoftlmico)
        prohibido: (respuestas) ->
            respuestas.embarazo or
            respuestas.alergia_acetazolamida or
            respuestas.acidosis_metablica or
            respuestas.depresin or
            respuestas.farma_cidoacetilsaliclico or
            respuestas.farma_ciclosporina or
            respuestas.farma_digoxina or
            respuestas.farma_lisdexanfetamina or
            respuestas.farma_carbonatodelitio or
            respuestas.farma_metildigoxina or
            respuestas.farma_topiramato or
            respuestas.farma_zonisamida
        sinergias: (respuestas) ->
            [respuestas.edema, respuestas.epilepsia, respuestas.glaucoma].reduce((total, respuesta) ->
                total + (if respuesta then 1 else 0)
            , 0)
    amitriptilina = 
        recomendado: (respuestas) ->
            !@prohibido(respuestas) and !@noRecomendado(respuestas)
        noRecomendado: (respuestas) ->
            !@prohibido(respuestas) and 
            (respuestas.arritmia_o_bloqueo_cardiaco or
            respuestas.insuficiencia_heptica or
            respuestas.hipertiroidismo or
            respuestas.epilepsia or
            respuestas.glaucoma or
            respuestas.esquizofrenia or
            respuestas.trastorno_bipolar or
            respuestas.tendencia_suicida or
            respuestas.hipertrofia_prosttica_o_uropata_obstructiva or
            respuestas.angina or
            respuestas.estrenimiento or
            respuestas.fotosensibilidad or
            respuestas.feocromocitoma or
            respuestas.farma_altizida or
            respuestas.farma_baclofeno or
            respuestas.farma_bendroflumetiazida or
            respuestas.farma_biperideno or
            respuestas.farma_bumetanida or
            respuestas.farma_bupropin or
            respuestas.farma_citalopram or
            respuestas.farma_clortalidona or
            respuestas.farma_diazepam or
            respuestas.farma_disulfiram or
            respuestas.farma_escopolamina or
            respuestas.farma_estradiol or
            respuestas.farma_estriol or
            respuestas.farma_etinilestradiol or
            respuestas.farma_fluconazol or
            respuestas.farma_furosemida or
            respuestas.farma_granisetrn or
            respuestas.farma_hidroclorotiazida or
            respuestas.farma_hiprico or
            respuestas.farma_indapamida or
            respuestas.farma_josamicina or
            respuestas.farma_levodopa or
            respuestas.farma_morfina or
            respuestas.farma_ondansetrn or
            respuestas.farma_palonosetrn or
            respuestas.farma_piretanida or
            respuestas.farma_prociclinida or
            respuestas.farma_sertralina or
            respuestas.farma_sulfacrato or
            respuestas.farma_terbinafina or
            respuestas.farma_torasemida or
            respuestas.farma_trihexifenilo or
            respuestas.farma_xipamida or
            respuestas.farma_escitalopram or
            respuestas.farma_fenilefrinanasal or
            respuestas.farma_formoterol or
            respuestas.farma_metildopa or
            respuestas.farma_mirabegron or
            respuestas.farma_nafazolinanasal or
            respuestas.farma_oximetazolinanasal or
            respuestas.farma_nilotinib or
            respuestas.farma_paroxetina or
            respuestas.farma_ritonavir or
            respuestas.farma_tramazolinanasal or
            respuestas.farma_xilometazolinanasal or
            respuestas.farma_estrgenosconjugados)
        prohibido: (respuestas) ->
            respuestas.embarazo or
            respuestas.alergia_amitriptilina or
            respuestas.infarto_de_miocardio or
            respuestas.alcohol or
            respuestas.farma_adenosina or
            respuestas.farma_trixidodearsnico or
            respuestas.farma_atomoxetina or
            respuestas.farma_atropina or
            respuestas.farma_carbamazepina or
            respuestas.farma_clonidina or
            respuestas.farma_clorpromacina or
            respuestas.farma_clozapina or
            respuestas.farma_droperidol or
            respuestas.farma_epinefrina or
            respuestas.farma_eslicarbazepina or
            respuestas.farma_epinefrina or
            respuestas.farma_fenilefrinanasal or
            respuestas.farma_fenobarbital or
            respuestas.farma_flufenacina or
            respuestas.farma_fluoxetina or
            respuestas.farma_fluvoxamina or
            respuestas.farma_haloperidol or
            respuestas.farma_levomepromazina or
            respuestas.farma_linezolid or
            respuestas.farma_carbonatodelitio or
            respuestas.farma_moclobemida or
            respuestas.farma_norepinefrina or
            respuestas.farma_perfenazina or
            respuestas.farma_periciazina or
            respuestas.farma_pimozida or
            respuestas.farma_rasagilina or
            respuestas.farma_saquinavir or
            respuestas.farma_selegilina or
            respuestas.farma_sotalol or
            respuestas.farma_sunitinib or
            respuestas.farma_tacrolimus or
            respuestas.farma_tranilcipromina or
            respuestas.farma_valproato or
            respuestas.farma_valpromida
        sinergias: (respuestas) ->
            [respuestas.depresin, respuestas.dolor_neuroptico, respuestas.eneuresis_nocturna].reduce((total, respuesta) ->
                total + (if respuesta then 1 else 0)
            , 0)
    flunarizina = 
        recomendado: (respuestas) ->
            !@prohibido(respuestas) and !@noRecomendado(respuestas)
        noRecomendado: (respuestas) ->
            !@prohibido(respuestas) and 
            (respuestas.insuficiencia_heptica or
            respuestas.farma_carbamazepina or
            respuestas.farma_ciproterona or
            respuestas.farma_eslicarbazepina or
            respuestas.farma_fenitona or
            respuestas.farma_valproato)
        prohibido: (respuestas) ->
            respuestas.embarazo or
            respuestas.alergia_flunarizina or
            respuestas.parkinson or
            respuestas.depresin or
            respuestas.alcohol or
            respuestas.farma_etinilestradiol
        sinergias: (respuestas) ->
            [].reduce((total, respuesta) ->
                total + (if respuesta then 1 else 0)
            , 0)
    propranolol = 
        recomendado: (respuestas) ->
            !@prohibido(respuestas) and !@noRecomendado(respuestas)
        noRecomendado: (respuestas) ->
            !@prohibido(respuestas) and 
            (respuestas.COMarteriopatia or
            respuestas.arteriopata_perifrica or
            respuestas.psoriasis or
            respuestas.insuficiencia_heptica or
            respuestas.hipertiroidismo or
            respuestas.diabetes or
            respuestas.insuficiencia_renal or
            respuestas.miastenia_gravis or
            respuestas.depresin or
            respuestas.feocromocitoma or
            respuestas.farma_abiraterona or
            respuestas.farma_aceclofenaco or
            respuestas.farma_acenocumarol or
            respuestas.farma_cidoacetilsaliclico or
            respuestas.farma_amiodarona or
            respuestas.farma_cidoascrbico or
            respuestas.farma_celecoxib or
            respuestas.farma_colestipol or
            respuestas.farma_colestiramina or
            respuestas.farma_dexibuprofeno or
            respuestas.farma_dexketoprofeno or
            respuestas.farma_diazepam or
            respuestas.farma_diclofenaco or
            respuestas.farma_diltiazem or
            respuestas.farma_dronedarona or
            respuestas.farma_ergotamina or
            respuestas.farma_estradiol or
            respuestas.farma_estriol or
            respuestas.farma_estrgenosconjugados or
            respuestas.farma_etinilestradiol or
            respuestas.farma_etoricoxib or
            respuestas.farma_fenobarbital or
            respuestas.farma_flecainida or
            respuestas.farma_flurbiprofeno or
            respuestas.farma_fluvoxamina or
            respuestas.farma_heparina or
            respuestas.farma_hidralazina or
            respuestas.farma_ibuprofeno or
            respuestas.farma_imipramina or
            respuestas.farma_indometacina or
            respuestas.farma_isonixina or
            respuestas.farma_ketoprofeno or
            respuestas.farma_ketorolaco or
            respuestas.farma_lornoxicam or
            respuestas.farma_maprotilina or
            respuestas.farma_cidomefenmico or
            respuestas.farma_meloxicam or
            respuestas.farma_nabumetona or
            respuestas.farma_naproxeno or
            respuestas.farma_neostigmina or
            respuestas.farma_nifedipino or
            respuestas.farma_cidoniflmico or
            respuestas.farma_paracetamol or
            respuestas.farma_parecoxib or
            respuestas.farma_bromurodepiridostigmina or
            respuestas.farma_piroxicam or
            respuestas.farma_promestrieno or
            respuestas.farma_propafenona or
            respuestas.farma_rifampicina or
            respuestas.farma_rizatriptn or
            respuestas.farma_clorurodesuxametonio or
            respuestas.farma_tenoxicam or
            respuestas.farma_teofilina or
            respuestas.farma_terbinafina or
            respuestas.farma_tiopentalsdico or
            respuestas.farma_verapamilo or
            respuestas.farma_warfarina or
            respuestas.farma_acarbosa or
            respuestas.farma_agomelatina or
            respuestas.farma_albiglutida or
            respuestas.farma_algeldrato or
            respuestas.farma_almasilato or
            respuestas.farma_alprostadilo or
            respuestas.farma_canaglifozina or
            respuestas.farma_citalopram or
            respuestas.farma_codena or
            respuestas.farma_dapaglifozina or
            respuestas.farma_empaglifozina or
            respuestas.farma_escitalopram or
            respuestas.farma_exenatida or
            respuestas.farma_fampridina or
            respuestas.farma_fenilefrinanasal or
            respuestas.farma_fentanilo or
            respuestas.farma_galantamina or
            respuestas.farma_glibenclamida or
            respuestas.farma_gliclazida or
            respuestas.farma_glimepirida or
            respuestas.farma_glipizida or
            respuestas.farma_glisentida or
            respuestas.farma_gomaguar or
            respuestas.farma_haloperidol or
            respuestas.farma_imatinib or
            respuestas.farma_insulina or
            respuestas.farma_linagliptina or
            respuestas.farma_liraglutida or
            respuestas.farma_lixisenatida or
            respuestas.farma_carbonatodemagnesio or
            respuestas.farma_hidrxidodemagnesio or
            respuestas.farma_xidodemagnesio or
            respuestas.farma_trisilicatodemagnesio or
            respuestas.farma_metadona or
            respuestas.farma_metformina or
            respuestas.farma_miglitol or
            respuestas.farma_modafilino or
            respuestas.farma_morfina or
            respuestas.farma_nafazolinanasal or
            respuestas.farma_nateglinida or
            respuestas.farma_nisoldipino or
            respuestas.farma_opio or
            respuestas.farma_oximetazolinanasal or
            respuestas.farma_petidina or
            respuestas.farma_pioglitazona or
            respuestas.farma_pixantrona or
            respuestas.farma_ranolazina or
            respuestas.farma_repaglinida or
            respuestas.farma_saxagliptina or
            respuestas.farma_sitagliptina or
            respuestas.farma_tramazolinanasal or
            respuestas.farma_vemurafenib or
            respuestas.farma_vildagliptina or
            respuestas.farma_xilometazolinanasal)
        prohibido: (respuestas) ->
            respuestas.embarazo or
            respuestas.alergia_propranolol or
            respuestas.hipotension or
            respuestas.bradicardia or
            respuestas.arritmia_o_bloqueo_cardiaco or
            respuestas.acidosis_metablica or
            respuestas.asma or
            respuestas.farma_bambuterol or
            respuestas.farma_clonidina or
            respuestas.farma_clorazepatodipotsico or
            respuestas.farma_clordiacepxido or
            respuestas.farma_clorpromacina or
            respuestas.farma_disopiramida or
            respuestas.farma_dopamina or
            respuestas.farma_epinefrina or
            respuestas.farma_fenilefrinanasal or
            respuestas.farma_fingolimod or
            respuestas.farma_fluoxetina or
            respuestas.farma_formoterol or
            respuestas.farma_hidroclorotiazida or
            respuestas.farma_indacaterol or
            respuestas.farma_lidocana or
            respuestas.farma_medazepam or
            respuestas.farma_metacolina or
            respuestas.farma_nimodipino or
            respuestas.farma_olodaterol or
            respuestas.farma_pinazepam or
            respuestas.farma_prazosina or
            respuestas.farma_procainamida or
            respuestas.farma_salbutamol or
            respuestas.farma_salmeterol or
            respuestas.farma_terbutalina or
            respuestas.farma_vilanterol
        sinergias: (respuestas) ->
            [respuestas.angina, respuestas.ansiedad, respuestas.arritmia_cardiaca, respuestas.hipertensin_arterial, respuestas.tirotoxicosis, respuestas.miocardiopata_hipertrfica, respuestas.temblor_esencial, respuestas.varices_esofgicas].reduce((total, respuesta) ->
                total + (if respuesta then 1 else 0)
            , 0)
    topiramato = 
        recomendado: (respuestas) ->
            !@prohibido(respuestas) and !@noRecomendado(respuestas)
        noRecomendado: (respuestas) ->
            !@prohibido(respuestas) and 
            (respuestas.fotosensibilidad or
            respuestas.insuficiencia_heptica or
            respuestas.acidosis_metablica or
            respuestas.insuficiencia_renal or
            respuestas.glaucoma or
            respuestas.tendencia_suicida or
            respuestas.depresin or
            respuestas.alteraciones_cognitivas or
            respuestas.clculos_urinarios or
            respuestas.farma_carbamazepina or
            respuestas.farma_digoxina or
            respuestas.farma_eslicarbazepina or
            respuestas.farma_etinilestradiol or
            respuestas.farma_fenitona or
            respuestas.farma_fenobarbital or
            respuestas.farma_glibenclamida or
            respuestas.farma_hidroclorotiazida or
            respuestas.farma_carbonatodelitio or
            respuestas.farma_metformina or
            respuestas.farma_pioglitazona or
            respuestas.farma_valproato or
            respuestas.farma_primidona)
        prohibido: (respuestas) ->
            respuestas.embarazo or
            respuestas.alergia_topiramato or
            respuestas.alcohol or
            respuestas.farma_acetazolamida or
            respuestas.farma_cidoascrbico or
            respuestas.farma_carbonatodecalcio or
            respuestas.farma_clorurodecalcio or
            respuestas.farma_fosfatodecalcio or
            respuestas.farma_lactatodecalcio or
            respuestas.farma_pidolatodecalcio or
            respuestas.farma_clopidogrel or
            respuestas.farma_gluconatodecalcio or
            respuestas.farma_saquinavir or
            respuestas.farma_triamtereno or
            respuestas.farma_zonisamida
        sinergias: (respuestas) ->
            [respuestas.epilepsia].reduce((total, respuesta) ->
                total + (if respuesta then 1 else 0)
            , 0)
    valproato = 
        recomendado: (respuestas) ->
            !@prohibido(respuestas) and !@noRecomendado(respuestas)
        noRecomendado: (respuestas) ->
            !@prohibido(respuestas) and 
            (respuestas.porfiria or
            respuestas.dolor_abdominal or
            respuestas.pancreatitis or
            respuestas.aplasia_medular or
            respuestas.insuficiencia_renal or
            respuestas.tendencia_suicida or
            respuestas.depresin or
            respuestas.lupus or
            respuestas.farma_acenocumarol or
            respuestas.farma_cidoacetilsaliclico or
            respuestas.farma_aciclovir or
            respuestas.farma_bleomicina or
            respuestas.farma_cisplatino or
            respuestas.farma_clonacepam or
            respuestas.farma_clorpromacina or
            respuestas.farma_colestiramina or
            respuestas.farma_diazepam or
            respuestas.farma_doxorubicina or
            respuestas.farma_etosuximida or
            respuestas.farma_flunarizina or
            respuestas.farma_lamotrigina or
            respuestas.farma_lorazepam or
            respuestas.farma_metotrexato or
            respuestas.farma_naproxeno or
            respuestas.farma_orlistat or
            respuestas.farma_oxcarbazepina or
            respuestas.farma_oxibatosdico or
            respuestas.farma_rufinamida or
            respuestas.farma_topiramato or
            respuestas.farma_vinblastina or
            respuestas.farma_warfarina or
            respuestas.farma_zidovudina or
            respuestas.farma_alprazolam or
            respuestas.farma_bromazepam or
            respuestas.farma_clorazepatodipotsico or
            respuestas.farma_clordiacepxido or
            respuestas.farma_clotiazepam or
            respuestas.farma_fenilbutiratosdico or
            respuestas.farma_flurazepam or
            respuestas.farma_lormetazepam or
            respuestas.farma_medazepam or
            respuestas.farma_oxazepam or
            respuestas.farma_pinazepam or
            respuestas.farma_triazolam or
            respuestas.farma_zolpidem)
        prohibido: (respuestas) ->
            respuestas.embarazo or
            respuestas.alergia_valproato or
            respuestas.insuficiencia_heptica or
            respuestas.hepatitis_aguda_o_crnica or
            respuestas.farma_amitriptilina or
            respuestas.farma_carbamazepina or
            respuestas.farma_clobazam or
            respuestas.farma_clomipramina or
            respuestas.farma_clozapina or
            respuestas.farma_ertapenem or
            respuestas.farma_eslicarbazepina or
            respuestas.farma_fenitona or
            respuestas.farma_fenobarbital or
            respuestas.farma_imipenem or
            respuestas.farma_meropenem or
            respuestas.farma_nimodipino or
            respuestas.farma_nortriptilina or
            respuestas.farma_primidona
        sinergias: (respuestas) ->
            [respuestas.ausencias, respuestas.epilepsia, respuestas.tics, respuestas.trastorno_bipolar].reduce((total, respuesta) ->
                total + (if respuesta then 1 else 0)
            , 0)
    $scope.tratamientos= 
        propranolol: propranolol
        acetazolamida: acetazolamida
        amitriptilina: amitriptilina
        flunarizina: flunarizina
        topiramato: topiramato
        valproato: valproato
    $scope.tratamientos_por_precio = [amitriptilina, acetazolamida, propranolol, flunarizina, valproato, topiramato]
    $scope.mostrar_evaluacion_completa = false
    $scope.visible = (tratamiento) -> 
      tratamiento == $scope.recomendado()
    $scope.recomendado = () ->
      $scope.tratamientosAdecuados()[0]
    $scope.tratamientosAdecuados = () ->
      $scope.tratamientos_por_precio.filter((tratamiento) ->
        not tratamiento.prohibido($scope.respuestas)
      ).sort((a, b) ->
        a_recomendado = a.recomendado($scope.respuestas)
        if a_recomendado == b.recomendado($scope.respuestas)
          b.sinergias($scope.respuestas) - a.sinergias($scope.respuestas)
        else
          if a_recomendado then -1 else 1
      )
    $scope.empateResueltoPorPrecio = () ->
      tratamientosAdecuados = $scope.tratamientosAdecuados()
      return false if tratamientosAdecuados.length < 2
      recomendado = tratamientosAdecuados[0]
      segundo_mejor = tratamientosAdecuados[1]
      (recomendado.recomendado($scope.respuestas) == segundo_mejor.recomendado($scope.respuestas)) and (recomendado.sinergias($scope.respuestas) == segundo_mejor.sinergias($scope.respuestas))