import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Simple hand-written localisation class.
/// Add new keys here and reference them throughout the app via
/// `AppStrings.of(context).someKey`.
class AppStrings {
  const AppStrings._(this._lang);

  final String _lang;

  // ── Factory / delegate ────────────────────────────────────────────────────

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings) ??
      const AppStrings._('en');

  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();

  // ── Supported locales ─────────────────────────────────────────────────────

  static const List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage('en', 'English',    '🇬🇧'),
    SupportedLanguage('de', 'Deutsch',    '🇩🇪'),
    SupportedLanguage('fr', 'Français',   '🇫🇷'),
    SupportedLanguage('es', 'Español',    '🇪🇸'),
    SupportedLanguage('tr', 'Türkçe',     '🇹🇷'),
    SupportedLanguage('ja', '日本語',      '🇯🇵'),
    SupportedLanguage('ru', 'Русский',    '🇷🇺'),
    SupportedLanguage('it', 'Italiano',   '🇮🇹'),
    SupportedLanguage('pt', 'Português',  '🇧🇷'),
    SupportedLanguage('hi', 'हिन्दी',      '🇮🇳'),
  ];

  static List<Locale> get supportedLocales =>
      supportedLanguages.map((l) => Locale(l.code)).toList();

  // ── Helper ────────────────────────────────────────────────────────────────

  String _t(Map<String, String> m) => m[_lang] ?? m['en']!;

  // ── StartScreen ───────────────────────────────────────────────────────────

  String get lightBeamPuzzle => _t({
        'en': 'A light-beam puzzle',
        'de': 'Ein Lichtstrahl-Puzzle',
        'fr': 'Un puzzle de rayons lumineux',
        'es': 'Un puzzle de rayos de luz',
        'tr': 'Bir ışın huzmesi bulmacası',
        'ja': '光線パズル',
        'ru': 'Головоломка со световыми лучами',
        'it': 'Un puzzle di raggi di luce',
        'pt': 'Um puzzle de raios de luz',
        'hi': 'एक प्रकाश-किरण पहेली',
      });

  String levelsSolved(int n, int total) {
    final template = _t({
      'en': '$n / $total LEVELS SOLVED',
      'de': '$n / $total LEVEL GELÖST',
      'fr': '$n / $total NIVEAUX RÉSOLUS',
      'es': '$n / $total NIVELES RESUELTOS',
      'tr': '$n / $total BÖLÜM ÇÖZÜLDÜ',
      'ja': '$n / $total ステージクリア',
      'ru': '$n / $total УРОВНЕЙ ПРОЙДЕНО',
      'it': '$n / $total LIVELLI RISOLTI',
      'pt': '$n / $total NÍVEIS RESOLVIDOS',
      'hi': '$n / $total स्तर हल किए',
    });
    return template;
  }

  String get play => _t({
        'en': 'PLAY',
        'de': 'SPIELEN',
        'fr': 'JOUER',
        'es': 'JUGAR',
        'tr': 'OYNA',
        'ja': 'プレイ',
        'ru': 'ИГРАТЬ',
        'it': 'GIOCA',
        'pt': 'JOGAR',
        'hi': 'खेलें',
      });

  String get settings => _t({
        'en': 'SETTINGS',
        'de': 'EINSTELLUNGEN',
        'fr': 'PARAMÈTRES',
        'es': 'AJUSTES',
        'tr': 'AYARLAR',
        'ja': '設定',
        'ru': 'НАСТРОЙКИ',
        'it': 'IMPOSTAZIONI',
        'pt': 'CONFIGURAÇÕES',
        'hi': 'सेटिंग्स',
      });

  // ── LevelSelectScreen ─────────────────────────────────────────────────────

  String get selectLevel => _t({
        'en': 'SELECT LEVEL',
        'de': 'LEVEL AUSWÄHLEN',
        'fr': 'CHOISIR UN NIVEAU',
        'es': 'SELECCIONAR NIVEL',
        'tr': 'BÖLÜM SEÇ',
        'ja': 'ステージ選択',
        'ru': 'ВЫБОР УРОВНЯ',
        'it': 'SCEGLI LIVELLO',
        'pt': 'SELECIONAR NÍVEL',
        'hi': 'स्तर चुनें',
      });

  // ── GameScreen ────────────────────────────────────────────────────────────

  String levelN(int n) => _t({
        'en': 'LEVEL $n',
        'de': 'LEVEL $n',
        'fr': 'NIVEAU $n',
        'es': 'NIVEL $n',
        'tr': 'BÖLÜM $n',
        'ja': 'ステージ$n',
        'ru': 'УРОВЕНЬ $n',
        'it': 'LIVELLO $n',
        'pt': 'NÍVEL $n',
        'hi': 'स्तर $n',
      });

  String get resetLevel => _t({
        'en': 'Reset level',
        'de': 'Level zurücksetzen',
        'fr': 'Réinitialiser le niveau',
        'es': 'Reiniciar nivel',
        'tr': 'Bölümü sıfırla',
        'ja': 'リセット',
        'ru': 'Сбросить уровень',
        'it': 'Reimposta livello',
        'pt': 'Reiniciar nível',
        'hi': 'स्तर रीसेट करें',
      });

  // ── WinDialog ─────────────────────────────────────────────────────────────

  String get levelComplete => _t({
        'en': 'LEVEL COMPLETE',
        'de': 'LEVEL ABGESCHLOSSEN',
        'fr': 'NIVEAU TERMINÉ',
        'es': 'NIVEL COMPLETADO',
        'tr': 'BÖLÜM TAMAMLANDI',
        'ja': 'ステージクリア',
        'ru': 'УРОВЕНЬ ПРОЙДЕН',
        'it': 'LIVELLO COMPLETATO',
        'pt': 'NÍVEL CONCLUÍDO',
        'hi': 'स्तर पूर्ण',
      });

  String get allReceiversActivated => _t({
        'en': 'All receivers activated!',
        'de': 'Alle Empfänger aktiviert!',
        'fr': 'Tous les récepteurs activés !',
        'es': '¡Todos los receptores activados!',
        'tr': 'Tüm alıcılar aktif!',
        'ja': '全レシーバー起動！',
        'ru': 'Все получатели активированы!',
        'it': 'Tutti i ricevitori attivati!',
        'pt': 'Todos os receptores ativados!',
        'hi': 'सभी रिसीवर सक्रिय!',
      });

  String get replay => _t({
        'en': 'REPLAY',
        'de': 'NOCHMAL',
        'fr': 'REJOUER',
        'es': 'REPETIR',
        'tr': 'TEKRAR',
        'ja': 'もう一度',
        'ru': 'ЗАНОВО',
        'it': 'RIGIOCA',
        'pt': 'REPETIR',
        'hi': 'फिर खेलें',
      });

  String get next => _t({
        'en': 'NEXT',
        'de': 'WEITER',
        'fr': 'SUIVANT',
        'es': 'SIGUIENTE',
        'tr': 'İLERİ',
        'ja': '次へ',
        'ru': 'ДАЛЬШЕ',
        'it': 'AVANTI',
        'pt': 'PRÓXIMO',
        'hi': 'अगला',
      });

  String get menu => _t({
        'en': 'MENU',
        'de': 'MENÜ',
        'fr': 'MENU',
        'es': 'MENÚ',
        'tr': 'MENÜ',
        'ja': 'メニュー',
        'ru': 'МЕНЮ',
        'it': 'MENU',
        'pt': 'MENU',
        'hi': 'मेनू',
      });

  // ── SettingsScreen ────────────────────────────────────────────────────────

  String get receiverEffect => _t({
        'en': 'RECEIVER EFFECT',
        'de': 'EMPFÄNGER-EFFEKT',
        'fr': 'EFFET DE RÉCEPTEUR',
        'es': 'EFECTO DE RECEPTOR',
        'tr': 'ALICI ETKİSİ',
        'ja': 'レシーバーエフェクト',
        'ru': 'ЭФФЕКТ ПОЛУЧАТЕЛЯ',
        'it': 'EFFETTO RICEVITORE',
        'pt': 'EFEITO DO RECEPTOR',
        'hi': 'रिसीवर प्रभाव',
      });

  String get particleExplosion => _t({
        'en': 'Particle Explosion',
        'de': 'Partikel-Explosion',
        'fr': 'Explosion de particules',
        'es': 'Explosión de partículas',
        'tr': 'Parçacık Patlaması',
        'ja': 'パーティクル爆発',
        'ru': 'Взрыв частиц',
        'it': 'Esplosione di particelle',
        'pt': 'Explosão de partículas',
        'hi': 'कण विस्फोट',
      });

  String get particleExplosionDesc => _t({
        'en': 'Sparks burst when a receiver is hit',
        'de': 'Funken sprühen, wenn ein Empfänger getroffen wird',
        'fr': 'Des étincelles jaillissent quand un récepteur est touché',
        'es': 'Chispas explotan cuando se activa un receptor',
        'tr': 'Alıcıya ulaşınca kıvılcımlar saçılır',
        'ja': 'レシーバーが起動すると火花が散る',
        'ru': 'Искры вспыхивают при активации получателя',
        'it': 'Scintille esplodono quando un ricevitore viene colpito',
        'pt': 'Faíscas explodem quando um receptor é atingido',
        'hi': 'रिसीवर हिट होने पर चिंगारी फूटती है',
      });

  String get softGlow => _t({
        'en': 'Soft Glow',
        'de': 'Sanftes Leuchten',
        'fr': 'Lueur douce',
        'es': 'Brillo suave',
        'tr': 'Yumuşak Parıltı',
        'ja': 'ソフトグロー',
        'ru': 'Мягкое свечение',
        'it': 'Bagliore morbido',
        'pt': 'Brilho suave',
        'hi': 'नरम चमक',
      });

  String get softGlowDesc => _t({
        'en': 'Receiver pulses with a gentle aura',
        'de': 'Empfänger pulsiert mit einer sanften Aura',
        'fr': 'Le récepteur pulse avec une douce aura',
        'es': 'El receptor pulsa con una suave aura',
        'tr': 'Alıcı hafif bir parıltıyla titreşir',
        'ja': 'レシーバーが優しいオーラで脈打つ',
        'ru': 'Получатель пульсирует с мягким ореолом',
        'it': 'Il ricevitore pulsa con una dolce aura',
        'pt': 'O receptor pulsa com uma aura suave',
        'hi': 'रिसीवर एक सौम्य आभा के साथ स्पंदित होता है',
      });

  String get effectNone => _t({
        'en': 'None',
        'de': 'Kein Effekt',
        'fr': 'Aucun',
        'es': 'Ninguno',
        'tr': 'Yok',
        'ja': 'なし',
        'ru': 'Нет',
        'it': 'Nessuno',
        'pt': 'Nenhum',
        'hi': 'कोई नहीं',
      });

  String get effectNoneDesc => _t({
        'en': 'Minimalist – no extra animation',
        'de': 'Minimalistisch – keine zusätzliche Animation',
        'fr': 'Minimaliste – aucune animation supplémentaire',
        'es': 'Minimalista – sin animación extra',
        'tr': 'Minimalist – ekstra animasyon yok',
        'ja': 'ミニマル – アニメーションなし',
        'ru': 'Минималист – без анимации',
        'it': 'Minimalista – nessuna animazione extra',
        'pt': 'Minimalista – sem animação extra',
        'hi': 'न्यूनतम – कोई अतिरिक्त एनिमेशन नहीं',
      });

  String get lightColors => _t({
        'en': 'LIGHT COLORS',
        'de': 'LICHTFARBEN',
        'fr': 'COULEURS DE LUMIÈRE',
        'es': 'COLORES DE LUZ',
        'tr': 'IŞIK RENKLERİ',
        'ja': '光の色',
        'ru': 'ЦВЕТА СВЕТА',
        'it': 'COLORI DI LUCE',
        'pt': 'CORES DE LUZ',
        'hi': 'प्रकाश रंग',
      });

  String get sameColor => _t({
        'en': 'Same Color',
        'de': 'Gleiche Farbe',
        'fr': 'Même couleur',
        'es': 'Mismo color',
        'tr': 'Aynı Renk',
        'ja': '同じ色',
        'ru': 'Один цвет',
        'it': 'Stesso colore',
        'pt': 'Mesma cor',
        'hi': 'एक रंग',
      });

  String get sameColorDesc => _t({
        'en': 'All beams glow in one color',
        'de': 'Alle Strahlen leuchten in einer Farbe',
        'fr': 'Tous les rayons brillent en une seule couleur',
        'es': 'Todos los rayos brillan en un solo color',
        'tr': 'Tüm ışınlar tek renkte parlar',
        'ja': 'すべてのビームが同じ色で光る',
        'ru': 'Все лучи светятся одним цветом',
        'it': 'Tutti i raggi brillano in un solo colore',
        'pt': 'Todos os raios brilham em uma cor',
        'hi': 'सभी किरणें एक रंग में चमकती हैं',
      });

  String get mixedColors => _t({
        'en': 'Mixed Colors',
        'de': 'Verschiedene Farben',
        'fr': 'Couleurs variées',
        'es': 'Colores mixtos',
        'tr': 'Farklı Renkler',
        'ja': '様々な色',
        'ru': 'Разные цвета',
        'it': 'Colori misti',
        'pt': 'Cores variadas',
        'hi': 'मिश्रित रंग',
      });

  String get mixedColorsDesc => _t({
        'en': 'Each emitter radiates a different color',
        'de': 'Jeder Emitter strahlt in einer anderen Farbe',
        'fr': 'Chaque émetteur rayonne une couleur différente',
        'es': 'Cada emisor irradia un color diferente',
        'tr': 'Her emitör farklı bir renk yayar',
        'ja': '各エミッターが異なる色で輝く',
        'ru': 'Каждый излучатель светится своим цветом',
        'it': 'Ogni emettitore irradia un colore diverso',
        'pt': 'Cada emissor irradia uma cor diferente',
        'hi': 'प्रत्येक एमिटर एक अलग रंग विकीर्ण करता है',
      });

  String get language => _t({
        'en': 'LANGUAGE',
        'de': 'SPRACHE',
        'fr': 'LANGUE',
        'es': 'IDIOMA',
        'tr': 'DİL',
        'ja': '言語',
        'ru': 'ЯЗЫК',
        'it': 'LINGUA',
        'pt': 'IDIOMA',
        'hi': 'भाषा',
      });

  // ── IntroScreen ───────────────────────────────────────────────────────────

  String get skip => _t({
        'en': 'SKIP',
        'de': 'ÜBERSPRINGEN',
        'fr': 'IGNORER',
        'es': 'OMITIR',
        'tr': 'ATLA',
        'ja': 'スキップ',
        'ru': 'ПРОПУСТИТЬ',
        'it': 'SALTA',
        'pt': 'PULAR',
        'hi': 'छोड़ें',
      });

  String get welcomeDescription => _t({
        'en': 'Guide light beams through mirrors and splitters\nto activate all receivers.',
        'de': 'Leite Lichtstrahlen durch Spiegel und Teiler,\num alle Empfänger zu aktivieren.',
        'fr': 'Guidez les rayons lumineux à travers des miroirs et des séparateurs\npour activer tous les récepteurs.',
        'es': 'Guía los rayos de luz a través de espejos y divisores\npara activar todos los receptores.',
        'tr': 'Aynalar ve bölücüler aracılığıyla ışık hüzmelerini yönlendirerek\ntüm alıcıları aktifleştir.',
        'ja': 'ミラーとスプリッターを通して光線を導き\nすべてのレシーバーを起動させよう。',
        'ru': 'Направляйте световые лучи через зеркала и делители,\nчтобы активировать все приёмники.',
        'it': 'Guida i raggi di luce attraverso specchi e divisori\nper attivare tutti i ricevitori.',
        'pt': 'Guie raios de luz através de espelhos e divisores\npara ativar todos os receptores.',
        'hi': 'सभी रिसीवर को सक्रिय करने के लिए\nदर्पण और स्प्लिटर के माध्यम से प्रकाश किरणों को निर्देशित करें।',
      });

  String get swipeToLearn => _t({
        'en': 'Swipe or tap NEXT to learn the elements →',
        'de': 'Wische oder tippe WEITER, um die Elemente kennenzulernen →',
        'fr': 'Glissez ou appuyez sur SUIVANT pour découvrir les éléments →',
        'es': 'Desliza o pulsa SIGUIENTE para aprender los elementos →',
        'tr': 'Elementleri öğrenmek için kaydır veya İLERİ\'ye dokun →',
        'ja': '要素を学ぶには次へスワイプまたはタップ →',
        'ru': 'Свайпните или нажмите ДАЛЕЕ, чтобы узнать об элементах →',
        'it': 'Scorri o tocca AVANTI per conoscere gli elementi →',
        'pt': 'Deslize ou toque em PRÓXIMO para aprender os elementos →',
        'hi': 'तत्वों को जानने के लिए स्वाइप करें या अगला टैप करें →',
      });

  String get emitterTitle => _t({
        'en': 'EMITTER',
        'de': 'EMITTER',
        'fr': 'ÉMETTEUR',
        'es': 'EMISOR',
        'tr': 'EMİTÖR',
        'ja': 'エミッター',
        'ru': 'ИЗЛУЧАТЕЛЬ',
        'it': 'EMETTITORE',
        'pt': 'EMISSOR',
        'hi': 'एमिटर',
      });

  String get emitterDesc => _t({
        'en': 'Fires a beam of light in a fixed direction.\nIts direction is set by the level — it cannot be rotated.',
        'de': 'Schießt einen Lichtstrahl in eine feste Richtung.\nDie Richtung wird vom Level bestimmt — er kann nicht gedreht werden.',
        'fr': 'Émet un rayon de lumière dans une direction fixe.\nSa direction est définie par le niveau — il ne peut pas être tourné.',
        'es': 'Dispara un rayo de luz en una dirección fija.\nSu dirección la marca el nivel — no puede girarse.',
        'tr': 'Sabit bir yönde ışık ışını fırlatır.\nYönü seviye tarafından belirlenir — döndürülemez.',
        'ja': '固定された方向に光線を放つ。\n向きはレベルで決まっており、回転できない。',
        'ru': 'Испускает луч света в фиксированном направлении.\nНаправление задаётся уровнем — вращать нельзя.',
        'it': 'Emette un raggio di luce in una direzione fissa.\nLa sua direzione è impostata dal livello — non può essere ruotato.',
        'pt': 'Dispara um raio de luz em uma direção fixa.\nSua direção é definida pelo nível — não pode ser girado.',
        'hi': 'एक निश्चित दिशा में प्रकाश की किरण दागता है।\nइसकी दिशा स्तर द्वारा निर्धारित होती है — इसे घुमाया नहीं जा सकता।',
      });

  String get mirrorTitle => _t({
        'en': 'MIRROR',
        'de': 'SPIEGEL',
        'fr': 'MIROIR',
        'es': 'ESPEJO',
        'tr': 'AYNA',
        'ja': 'ミラー',
        'ru': 'ЗЕРКАЛО',
        'it': 'SPECCHIO',
        'pt': 'ESPELHO',
        'hi': 'दर्पण',
      });

  String get mirrorDesc => _t({
        'en': 'Reflects the beam in a new direction.\nTAP a mirror to rotate it 90° and change its angle.',
        'de': 'Reflektiert den Strahl in eine neue Richtung.\nTIPPE auf einen Spiegel, um ihn um 90° zu drehen.',
        'fr': 'Réfléchit le rayon dans une nouvelle direction.\nAPPUYEZ sur un miroir pour le faire pivoter de 90°.',
        'es': 'Refleja el rayo en una nueva dirección.\nTOCA un espejo para girarlo 90° y cambiar su ángulo.',
        'tr': 'Işını yeni bir yöne yansıtır.\nBir aynaya DOKUN ve onu 90° döndür.',
        'ja': 'ビームを新しい方向に反射する。\nミラーをタップして90°回転させよう。',
        'ru': 'Отражает луч в новом направлении.\nНАЖМИТЕ на зеркало, чтобы повернуть его на 90°.',
        'it': 'Riflette il raggio in una nuova direzione.\nTOCCA uno specchio per ruotarlo di 90°.',
        'pt': 'Reflete o raio em uma nova direção.\nTOQUE em um espelho para girá-lo 90°.',
        'hi': 'किरण को नई दिशा में परावर्तित करता है।\nएक दर्पण को 90° घुमाने के लिए TAP करें।',
      });

  String get splitterTitle => _t({
        'en': 'SPLITTER',
        'de': 'TEILER',
        'fr': 'SÉPARATEUR',
        'es': 'DIVISOR',
        'tr': 'BÖLÜCÜ',
        'ja': 'スプリッター',
        'ru': 'ДЕЛИТЕЛЬ',
        'it': 'DIVISORE',
        'pt': 'DIVISOR',
        'hi': 'स्प्लिटर',
      });

  String get splitterDesc => _t({
        'en': 'Splits the beam into two paths at once.\nTAP to toggle between horizontal and vertical mode.',
        'de': 'Teilt den Strahl gleichzeitig in zwei Pfade auf.\nTIPPE, um zwischen horizontalem und vertikalem Modus zu wechseln.',
        'fr': 'Divise le rayon en deux chemins simultanément.\nAPPUYEZ pour basculer entre mode horizontal et vertical.',
        'es': 'Divide el rayo en dos caminos a la vez.\nTOCA para alternar entre modo horizontal y vertical.',
        'tr': 'Işını aynı anda iki yola böler.\nYatay ve dikey mod arasında geçiş yapmak için DOKUN.',
        'ja': 'ビームを同時に2つの経路に分割する。\nタップして水平・垂直を切り替えよう。',
        'ru': 'Разделяет луч на два пути одновременно.\nНАЖМИТЕ для переключения режима.',
        'it': 'Divide il raggio in due percorsi contemporaneamente.\nTOCCA per passare tra modalità orizzontale e verticale.',
        'pt': 'Divide o raio em dois caminhos ao mesmo tempo.\nTOQUE para alternar entre modo horizontal e vertical.',
        'hi': 'एक साथ किरण को दो रास्तों में विभाजित करता है।\nक्षैतिज और ऊर्ध्वाधर मोड के बीच स्विच करने के लिए TAP करें।',
      });

  String get receiverTitle => _t({
        'en': 'RECEIVER',
        'de': 'EMPFÄNGER',
        'fr': 'RÉCEPTEUR',
        'es': 'RECEPTOR',
        'tr': 'ALICI',
        'ja': 'レシーバー',
        'ru': 'ПОЛУЧАТЕЛЬ',
        'it': 'RICEVITORE',
        'pt': 'RECEPTOR',
        'hi': 'रिसीवर',
      });

  String get receiverDesc => _t({
        'en': 'Must be hit by a beam of light to activate.\nLight up ALL receivers to complete the level!',
        'de': 'Muss von einem Lichtstrahl getroffen werden, um zu aktivieren.\nErleuchte ALLE Empfänger, um das Level abzuschließen!',
        'fr': 'Doit être touché par un rayon de lumière pour s\'activer.\nÉclairez TOUS les récepteurs pour terminer le niveau !',
        'es': 'Debe ser golpeado por un rayo de luz para activarse.\n¡Ilumina TODOS los receptores para completar el nivel!',
        'tr': 'Aktif olmak için bir ışın hüzmesine çarpması gerekir.\nLeveli tamamlamak için TÜM alıcıları ışıklandır!',
        'ja': '光線を当てると起動する。\nすべてのレシーバーを点灯させてステージをクリアしよう！',
        'ru': 'Должен быть активирован световым лучом.\nПодсветите ВСЕ получатели, чтобы завершить уровень!',
        'it': 'Deve essere colpito da un raggio di luce per attivarsi.\nIllumina TUTTI i ricevitori per completare il livello!',
        'pt': 'Deve ser atingido por um raio de luz para ativar.\nIlumine TODOS os receptores para completar o nível!',
        'hi': 'सक्रिय होने के लिए प्रकाश की किरण से टकराना चाहिए।\nस्तर पूरा करने के लिए सभी रिसीवर जलाएं!',
      });

  String get gameHint => _t({
        'en': 'TAP to rotate  •  Use mirrors to guide the beam',
        'de': 'TIPPEN zum Drehen  •  Spiegel lenken den Strahl',
        'fr': 'APPUYEZ pour tourner  •  Guidez le rayon avec les miroirs',
        'es': 'TOCA para girar  •  Usa espejos para guiar el rayo',
        'tr': 'DOKUNARAK döndür  •  Işını yönlendirmek için ayna kullan',
        'ja': 'タップで回転  •  ミラーでビームを導こう',
        'ru': 'НАЖМИТЕ для поворота  •  Используйте зеркала',
        'it': 'TOCCA per ruotare  •  Usa gli specchi per guidare il raggio',
        'pt': 'TOQUE para girar  •  Use espelhos para guiar o raio',
        'hi': 'TAP करें घुमाने के लिए  •  किरण को दर्पण से निर्देशित करें',
      });

  String get placementHint => _t({
        'en': 'TAP slot to place  •  TAP piece to rotate  •  HOLD to remove',
        'de': 'Feld antippen zum Platzieren  •  Tippen zum Drehen  •  Halten zum Entfernen',
        'fr': 'Appuyez pour placer  •  Appuyez pour tourner  •  Maintenez pour retirer',
        'es': 'Toca para colocar  •  Toca para girar  •  Mantén para quitar',
        'tr': 'Yerleştirmek için dokun  •  Döndürmek için dokun  •  Kaldırmak için basılı tut',
        'ja': 'タップで配置  •  タップで回転  •  長押しで削除',
        'ru': 'Нажмите для размещения  •  Нажмите для поворота  •  Удерживайте для удаления',
        'it': 'Tocca per posizionare  •  Tocca per ruotare  •  Tieni premuto per rimuovere',
        'pt': 'Toque para colocar  •  Toque para girar  •  Segure para remover',
        'hi': 'TAP करें रखने के लिए  •  TAP करें घुमाने के लिए  •  HOLD करें हटाने के लिए',
      });

  String get letsPlay => _t({
        'en': "LET'S PLAY!",
        'de': "LOS GEHT'S!",
        'fr': "C'EST PARTI !",
        'es': "¡A JUGAR!",
        'tr': "HADI OYNA!",
        'ja': "さあ、プレイしよう！",
        'ru': "ИГРАТЬ!",
        'it': "GIOCHIAMO!",
        'pt': "VAMOS JOGAR!",
        'hi': "चलो खेलें!",
      });

  String get nextArrow => _t({
        'en': 'NEXT  →',
        'de': 'WEITER  →',
        'fr': 'SUIVANT  →',
        'es': 'SIGUIENTE  →',
        'tr': 'İLERİ  →',
        'ja': '次へ  →',
        'ru': 'ДАЛЕЕ  →',
        'it': 'AVANTI  →',
        'pt': 'PRÓXIMO  →',
        'hi': 'अगला  →',
      });
}

// ── Supported language descriptor ─────────────────────────────────────────────

class SupportedLanguage {
  final String code;
  final String name;
  final String flag;

  const SupportedLanguage(this.code, this.name, this.flag);
}

// ── Delegate ──────────────────────────────────────────────────────────────────

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture(AppStrings._(locale.languageCode));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
