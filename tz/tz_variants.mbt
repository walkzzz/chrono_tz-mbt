// tz_variants.mbt — Tz 枚举与解析（自动生成，勿手改）
// 移植自仓颉 src/base/tz/tz_variants.cj

///|
/// IANA 时区枚举，597 个 variant，每个对应一个 IANA 时区 ID。
pub(all) enum Tz {
  Africa__Abidjan
  Africa__Accra
  Africa__Addis_Ababa
  Africa__Algiers
  Africa__Asmara
  Africa__Asmera
  Africa__Bamako
  Africa__Bangui
  Africa__Banjul
  Africa__Bissau
  Africa__Blantyre
  Africa__Brazzaville
  Africa__Bujumbura
  Africa__Cairo
  Africa__Casablanca
  Africa__Ceuta
  Africa__Conakry
  Africa__Dakar
  Africa__Dar_es_Salaam
  Africa__Djibouti
  Africa__Douala
  Africa__El_Aaiun
  Africa__Freetown
  Africa__Gaborone
  Africa__Harare
  Africa__Johannesburg
  Africa__Juba
  Africa__Kampala
  Africa__Khartoum
  Africa__Kigali
  Africa__Kinshasa
  Africa__Lagos
  Africa__Libreville
  Africa__Lome
  Africa__Luanda
  Africa__Lubumbashi
  Africa__Lusaka
  Africa__Malabo
  Africa__Maputo
  Africa__Maseru
  Africa__Mbabane
  Africa__Mogadishu
  Africa__Monrovia
  Africa__Nairobi
  Africa__Ndjamena
  Africa__Niamey
  Africa__Nouakchott
  Africa__Ouagadougou
  Africa__PortoNovo
  Africa__Sao_Tome
  Africa__Timbuktu
  Africa__Tripoli
  Africa__Tunis
  Africa__Windhoek
  America__Adak
  America__Anchorage
  America__Anguilla
  America__Antigua
  America__Araguaina
  America__Argentina__Buenos_Aires
  America__Argentina__Catamarca
  America__Argentina__ComodRivadavia
  America__Argentina__Cordoba
  America__Argentina__Jujuy
  America__Argentina__La_Rioja
  America__Argentina__Mendoza
  America__Argentina__Rio_Gallegos
  America__Argentina__Salta
  America__Argentina__San_Juan
  America__Argentina__San_Luis
  America__Argentina__Tucuman
  America__Argentina__Ushuaia
  America__Aruba
  America__Asuncion
  America__Atikokan
  America__Atka
  America__Bahia
  America__Bahia_Banderas
  America__Barbados
  America__Belem
  America__Belize
  America__BlancSablon
  America__Boa_Vista
  America__Bogota
  America__Boise
  America__Buenos_Aires
  America__Cambridge_Bay
  America__Campo_Grande
  America__Cancun
  America__Caracas
  America__Catamarca
  America__Cayenne
  America__Cayman
  America__Chicago
  America__Chihuahua
  America__Ciudad_Juarez
  America__Coral_Harbour
  America__Cordoba
  America__Costa_Rica
  America__Coyhaique
  America__Creston
  America__Cuiaba
  America__Curacao
  America__Danmarkshavn
  America__Dawson
  America__Dawson_Creek
  America__Denver
  America__Detroit
  America__Dominica
  America__Edmonton
  America__Eirunepe
  America__El_Salvador
  America__Ensenada
  America__Fort_Nelson
  America__Fort_Wayne
  America__Fortaleza
  America__Glace_Bay
  America__Godthab
  America__Goose_Bay
  America__Grand_Turk
  America__Grenada
  America__Guadeloupe
  America__Guatemala
  America__Guayaquil
  America__Guyana
  America__Halifax
  America__Havana
  America__Hermosillo
  America__Indiana__Indianapolis
  America__Indiana__Knox
  America__Indiana__Marengo
  America__Indiana__Petersburg
  America__Indiana__Tell_City
  America__Indiana__Vevay
  America__Indiana__Vincennes
  America__Indiana__Winamac
  America__Indianapolis
  America__Inuvik
  America__Iqaluit
  America__Jamaica
  America__Jujuy
  America__Juneau
  America__Kentucky__Louisville
  America__Kentucky__Monticello
  America__Knox_IN
  America__Kralendijk
  America__La_Paz
  America__Lima
  America__Los_Angeles
  America__Louisville
  America__Lower_Princes
  America__Maceio
  America__Managua
  America__Manaus
  America__Marigot
  America__Martinique
  America__Matamoros
  America__Mazatlan
  America__Mendoza
  America__Menominee
  America__Merida
  America__Metlakatla
  America__Mexico_City
  America__Miquelon
  America__Moncton
  America__Monterrey
  America__Montevideo
  America__Montreal
  America__Montserrat
  America__Nassau
  America__New_York
  America__Nipigon
  America__Nome
  America__Noronha
  America__North_Dakota__Beulah
  America__North_Dakota__Center
  America__North_Dakota__New_Salem
  America__Nuuk
  America__Ojinaga
  America__Panama
  America__Pangnirtung
  America__Paramaribo
  America__Phoenix
  America__PortauPrince
  America__Port_of_Spain
  America__Porto_Acre
  America__Porto_Velho
  America__Puerto_Rico
  America__Punta_Arenas
  America__Rainy_River
  America__Rankin_Inlet
  America__Recife
  America__Regina
  America__Resolute
  America__Rio_Branco
  America__Rosario
  America__Santa_Isabel
  America__Santarem
  America__Santiago
  America__Santo_Domingo
  America__Sao_Paulo
  America__Scoresbysund
  America__Shiprock
  America__Sitka
  America__St_Barthelemy
  America__St_Johns
  America__St_Kitts
  America__St_Lucia
  America__St_Thomas
  America__St_Vincent
  America__Swift_Current
  America__Tegucigalpa
  America__Thule
  America__Thunder_Bay
  America__Tijuana
  America__Toronto
  America__Tortola
  America__Vancouver
  America__Virgin
  America__Whitehorse
  America__Winnipeg
  America__Yakutat
  America__Yellowknife
  Antarctica__Casey
  Antarctica__Davis
  Antarctica__DumontDUrville
  Antarctica__Macquarie
  Antarctica__Mawson
  Antarctica__McMurdo
  Antarctica__Palmer
  Antarctica__Rothera
  Antarctica__South_Pole
  Antarctica__Syowa
  Antarctica__Troll
  Antarctica__Vostok
  Arctic__Longyearbyen
  Asia__Aden
  Asia__Almaty
  Asia__Amman
  Asia__Anadyr
  Asia__Aqtau
  Asia__Aqtobe
  Asia__Ashgabat
  Asia__Ashkhabad
  Asia__Atyrau
  Asia__Baghdad
  Asia__Bahrain
  Asia__Baku
  Asia__Bangkok
  Asia__Barnaul
  Asia__Beirut
  Asia__Bishkek
  Asia__Brunei
  Asia__Calcutta
  Asia__Chita
  Asia__Choibalsan
  Asia__Chongqing
  Asia__Chungking
  Asia__Colombo
  Asia__Dacca
  Asia__Damascus
  Asia__Dhaka
  Asia__Dili
  Asia__Dubai
  Asia__Dushanbe
  Asia__Famagusta
  Asia__Gaza
  Asia__Harbin
  Asia__Hebron
  Asia__Ho_Chi_Minh
  Asia__Hong_Kong
  Asia__Hovd
  Asia__Irkutsk
  Asia__Istanbul
  Asia__Jakarta
  Asia__Jayapura
  Asia__Jerusalem
  Asia__Kabul
  Asia__Kamchatka
  Asia__Karachi
  Asia__Kashgar
  Asia__Kathmandu
  Asia__Katmandu
  Asia__Khandyga
  Asia__Kolkata
  Asia__Krasnoyarsk
  Asia__Kuala_Lumpur
  Asia__Kuching
  Asia__Kuwait
  Asia__Macao
  Asia__Macau
  Asia__Magadan
  Asia__Makassar
  Asia__Manila
  Asia__Muscat
  Asia__Nicosia
  Asia__Novokuznetsk
  Asia__Novosibirsk
  Asia__Omsk
  Asia__Oral
  Asia__Phnom_Penh
  Asia__Pontianak
  Asia__Pyongyang
  Asia__Qatar
  Asia__Qostanay
  Asia__Qyzylorda
  Asia__Rangoon
  Asia__Riyadh
  Asia__Saigon
  Asia__Sakhalin
  Asia__Samarkand
  Asia__Seoul
  Asia__Shanghai
  Asia__Singapore
  Asia__Srednekolymsk
  Asia__Taipei
  Asia__Tashkent
  Asia__Tbilisi
  Asia__Tehran
  Asia__Tel_Aviv
  Asia__Thimbu
  Asia__Thimphu
  Asia__Tokyo
  Asia__Tomsk
  Asia__Ujung_Pandang
  Asia__Ulaanbaatar
  Asia__Ulan_Bator
  Asia__Urumqi
  Asia__UstNera
  Asia__Vientiane
  Asia__Vladivostok
  Asia__Yakutsk
  Asia__Yangon
  Asia__Yekaterinburg
  Asia__Yerevan
  Atlantic__Azores
  Atlantic__Bermuda
  Atlantic__Canary
  Atlantic__Cape_Verde
  Atlantic__Faeroe
  Atlantic__Faroe
  Atlantic__Jan_Mayen
  Atlantic__Madeira
  Atlantic__Reykjavik
  Atlantic__South_Georgia
  Atlantic__St_Helena
  Atlantic__Stanley
  Australia__ACT
  Australia__Adelaide
  Australia__Brisbane
  Australia__Broken_Hill
  Australia__Canberra
  Australia__Currie
  Australia__Darwin
  Australia__Eucla
  Australia__Hobart
  Australia__LHI
  Australia__Lindeman
  Australia__Lord_Howe
  Australia__Melbourne
  Australia__NSW
  Australia__North
  Australia__Perth
  Australia__Queensland
  Australia__South
  Australia__Sydney
  Australia__Tasmania
  Australia__Victoria
  Australia__West
  Australia__Yancowinna
  Brazil__Acre
  Brazil__DeNoronha
  Brazil__East
  Brazil__West
  CET
  CST6CDT
  Canada__Atlantic
  Canada__Central
  Canada__Eastern
  Canada__Mountain
  Canada__Newfoundland
  Canada__Pacific
  Canada__Saskatchewan
  Canada__Yukon
  Chile__Continental
  Chile__EasterIsland
  Cuba
  EET
  EST
  EST5EDT
  Egypt
  Eire
  Etc__GMT
  Etc__GMTPlus0
  Etc__GMTPlus1
  Etc__GMTPlus10
  Etc__GMTPlus11
  Etc__GMTPlus12
  Etc__GMTPlus2
  Etc__GMTPlus3
  Etc__GMTPlus4
  Etc__GMTPlus5
  Etc__GMTPlus6
  Etc__GMTPlus7
  Etc__GMTPlus8
  Etc__GMTPlus9
  Etc__GMTMinus0
  Etc__GMTMinus1
  Etc__GMTMinus10
  Etc__GMTMinus11
  Etc__GMTMinus12
  Etc__GMTMinus13
  Etc__GMTMinus14
  Etc__GMTMinus2
  Etc__GMTMinus3
  Etc__GMTMinus4
  Etc__GMTMinus5
  Etc__GMTMinus6
  Etc__GMTMinus7
  Etc__GMTMinus8
  Etc__GMTMinus9
  Etc__GMT0
  Etc__Greenwich
  Etc__UCT
  Etc__UTC
  Etc__Universal
  Etc__Zulu
  Europe__Amsterdam
  Europe__Andorra
  Europe__Astrakhan
  Europe__Athens
  Europe__Belfast
  Europe__Belgrade
  Europe__Berlin
  Europe__Bratislava
  Europe__Brussels
  Europe__Bucharest
  Europe__Budapest
  Europe__Busingen
  Europe__Chisinau
  Europe__Copenhagen
  Europe__Dublin
  Europe__Gibraltar
  Europe__Guernsey
  Europe__Helsinki
  Europe__Isle_of_Man
  Europe__Istanbul
  Europe__Jersey
  Europe__Kaliningrad
  Europe__Kiev
  Europe__Kirov
  Europe__Kyiv
  Europe__Lisbon
  Europe__Ljubljana
  Europe__London
  Europe__Luxembourg
  Europe__Madrid
  Europe__Malta
  Europe__Mariehamn
  Europe__Minsk
  Europe__Monaco
  Europe__Moscow
  Europe__Nicosia
  Europe__Oslo
  Europe__Paris
  Europe__Podgorica
  Europe__Prague
  Europe__Riga
  Europe__Rome
  Europe__Samara
  Europe__San_Marino
  Europe__Sarajevo
  Europe__Saratov
  Europe__Simferopol
  Europe__Skopje
  Europe__Sofia
  Europe__Stockholm
  Europe__Tallinn
  Europe__Tirane
  Europe__Tiraspol
  Europe__Ulyanovsk
  Europe__Uzhgorod
  Europe__Vaduz
  Europe__Vatican
  Europe__Vienna
  Europe__Vilnius
  Europe__Volgograd
  Europe__Warsaw
  Europe__Zagreb
  Europe__Zaporozhye
  Europe__Zurich
  GB
  GBEire
  GMT
  GMTPlus0
  GMTMinus0
  GMT0
  Greenwich
  HST
  Hongkong
  Iceland
  Indian__Antananarivo
  Indian__Chagos
  Indian__Christmas
  Indian__Cocos
  Indian__Comoro
  Indian__Kerguelen
  Indian__Mahe
  Indian__Maldives
  Indian__Mauritius
  Indian__Mayotte
  Indian__Reunion
  Iran
  Israel
  Jamaica
  Japan
  Kwajalein
  Libya
  MET
  MST
  MST7MDT
  Mexico__BajaNorte
  Mexico__BajaSur
  Mexico__General
  NZ
  NZCHAT
  Navajo
  PRC
  PST8PDT
  Pacific__Apia
  Pacific__Auckland
  Pacific__Bougainville
  Pacific__Chatham
  Pacific__Chuuk
  Pacific__Easter
  Pacific__Efate
  Pacific__Enderbury
  Pacific__Fakaofo
  Pacific__Fiji
  Pacific__Funafuti
  Pacific__Galapagos
  Pacific__Gambier
  Pacific__Guadalcanal
  Pacific__Guam
  Pacific__Honolulu
  Pacific__Johnston
  Pacific__Kanton
  Pacific__Kiritimati
  Pacific__Kosrae
  Pacific__Kwajalein
  Pacific__Majuro
  Pacific__Marquesas
  Pacific__Midway
  Pacific__Nauru
  Pacific__Niue
  Pacific__Norfolk
  Pacific__Noumea
  Pacific__Pago_Pago
  Pacific__Palau
  Pacific__Pitcairn
  Pacific__Pohnpei
  Pacific__Ponape
  Pacific__Port_Moresby
  Pacific__Rarotonga
  Pacific__Saipan
  Pacific__Samoa
  Pacific__Tahiti
  Pacific__Tarawa
  Pacific__Tongatapu
  Pacific__Truk
  Pacific__Wake
  Pacific__Wallis
  Pacific__Yap
  Poland
  Portugal
  ROC
  ROK
  Singapore
  Turkey
  UCT
  US__Alaska
  US__Aleutian
  US__Arizona
  US__Central
  US__EastIndiana
  US__Eastern
  US__Hawaii
  US__IndianaStarke
  US__Michigan
  US__Mountain
  US__Pacific
  US__Samoa
  UTC
  Universal
  WSU
  WET
  Zulu
} derive(Eq, Debug)

///|
pub extend Tz with Eq::{not_equal, equal}

///|
pub extend Tz with Debug::{to_repr}

///|
/// 返回本时区的 IANA ID（如 "Europe/Paris"）。
pub fn Tz::name(self : Tz) -> String {
  match self {
    Tz::Africa__Abidjan => "Africa/Abidjan"
    Tz::Africa__Accra => "Africa/Accra"
    Tz::Africa__Addis_Ababa => "Africa/Addis_Ababa"
    Tz::Africa__Algiers => "Africa/Algiers"
    Tz::Africa__Asmara => "Africa/Asmara"
    Tz::Africa__Asmera => "Africa/Asmera"
    Tz::Africa__Bamako => "Africa/Bamako"
    Tz::Africa__Bangui => "Africa/Bangui"
    Tz::Africa__Banjul => "Africa/Banjul"
    Tz::Africa__Bissau => "Africa/Bissau"
    Tz::Africa__Blantyre => "Africa/Blantyre"
    Tz::Africa__Brazzaville => "Africa/Brazzaville"
    Tz::Africa__Bujumbura => "Africa/Bujumbura"
    Tz::Africa__Cairo => "Africa/Cairo"
    Tz::Africa__Casablanca => "Africa/Casablanca"
    Tz::Africa__Ceuta => "Africa/Ceuta"
    Tz::Africa__Conakry => "Africa/Conakry"
    Tz::Africa__Dakar => "Africa/Dakar"
    Tz::Africa__Dar_es_Salaam => "Africa/Dar_es_Salaam"
    Tz::Africa__Djibouti => "Africa/Djibouti"
    Tz::Africa__Douala => "Africa/Douala"
    Tz::Africa__El_Aaiun => "Africa/El_Aaiun"
    Tz::Africa__Freetown => "Africa/Freetown"
    Tz::Africa__Gaborone => "Africa/Gaborone"
    Tz::Africa__Harare => "Africa/Harare"
    Tz::Africa__Johannesburg => "Africa/Johannesburg"
    Tz::Africa__Juba => "Africa/Juba"
    Tz::Africa__Kampala => "Africa/Kampala"
    Tz::Africa__Khartoum => "Africa/Khartoum"
    Tz::Africa__Kigali => "Africa/Kigali"
    Tz::Africa__Kinshasa => "Africa/Kinshasa"
    Tz::Africa__Lagos => "Africa/Lagos"
    Tz::Africa__Libreville => "Africa/Libreville"
    Tz::Africa__Lome => "Africa/Lome"
    Tz::Africa__Luanda => "Africa/Luanda"
    Tz::Africa__Lubumbashi => "Africa/Lubumbashi"
    Tz::Africa__Lusaka => "Africa/Lusaka"
    Tz::Africa__Malabo => "Africa/Malabo"
    Tz::Africa__Maputo => "Africa/Maputo"
    Tz::Africa__Maseru => "Africa/Maseru"
    Tz::Africa__Mbabane => "Africa/Mbabane"
    Tz::Africa__Mogadishu => "Africa/Mogadishu"
    Tz::Africa__Monrovia => "Africa/Monrovia"
    Tz::Africa__Nairobi => "Africa/Nairobi"
    Tz::Africa__Ndjamena => "Africa/Ndjamena"
    Tz::Africa__Niamey => "Africa/Niamey"
    Tz::Africa__Nouakchott => "Africa/Nouakchott"
    Tz::Africa__Ouagadougou => "Africa/Ouagadougou"
    Tz::Africa__PortoNovo => "Africa/Porto-Novo"
    Tz::Africa__Sao_Tome => "Africa/Sao_Tome"
    Tz::Africa__Timbuktu => "Africa/Timbuktu"
    Tz::Africa__Tripoli => "Africa/Tripoli"
    Tz::Africa__Tunis => "Africa/Tunis"
    Tz::Africa__Windhoek => "Africa/Windhoek"
    Tz::America__Adak => "America/Adak"
    Tz::America__Anchorage => "America/Anchorage"
    Tz::America__Anguilla => "America/Anguilla"
    Tz::America__Antigua => "America/Antigua"
    Tz::America__Araguaina => "America/Araguaina"
    Tz::America__Argentina__Buenos_Aires => "America/Argentina/Buenos_Aires"
    Tz::America__Argentina__Catamarca => "America/Argentina/Catamarca"
    Tz::America__Argentina__ComodRivadavia => "America/Argentina/ComodRivadavia"
    Tz::America__Argentina__Cordoba => "America/Argentina/Cordoba"
    Tz::America__Argentina__Jujuy => "America/Argentina/Jujuy"
    Tz::America__Argentina__La_Rioja => "America/Argentina/La_Rioja"
    Tz::America__Argentina__Mendoza => "America/Argentina/Mendoza"
    Tz::America__Argentina__Rio_Gallegos => "America/Argentina/Rio_Gallegos"
    Tz::America__Argentina__Salta => "America/Argentina/Salta"
    Tz::America__Argentina__San_Juan => "America/Argentina/San_Juan"
    Tz::America__Argentina__San_Luis => "America/Argentina/San_Luis"
    Tz::America__Argentina__Tucuman => "America/Argentina/Tucuman"
    Tz::America__Argentina__Ushuaia => "America/Argentina/Ushuaia"
    Tz::America__Aruba => "America/Aruba"
    Tz::America__Asuncion => "America/Asuncion"
    Tz::America__Atikokan => "America/Atikokan"
    Tz::America__Atka => "America/Atka"
    Tz::America__Bahia => "America/Bahia"
    Tz::America__Bahia_Banderas => "America/Bahia_Banderas"
    Tz::America__Barbados => "America/Barbados"
    Tz::America__Belem => "America/Belem"
    Tz::America__Belize => "America/Belize"
    Tz::America__BlancSablon => "America/Blanc-Sablon"
    Tz::America__Boa_Vista => "America/Boa_Vista"
    Tz::America__Bogota => "America/Bogota"
    Tz::America__Boise => "America/Boise"
    Tz::America__Buenos_Aires => "America/Buenos_Aires"
    Tz::America__Cambridge_Bay => "America/Cambridge_Bay"
    Tz::America__Campo_Grande => "America/Campo_Grande"
    Tz::America__Cancun => "America/Cancun"
    Tz::America__Caracas => "America/Caracas"
    Tz::America__Catamarca => "America/Catamarca"
    Tz::America__Cayenne => "America/Cayenne"
    Tz::America__Cayman => "America/Cayman"
    Tz::America__Chicago => "America/Chicago"
    Tz::America__Chihuahua => "America/Chihuahua"
    Tz::America__Ciudad_Juarez => "America/Ciudad_Juarez"
    Tz::America__Coral_Harbour => "America/Coral_Harbour"
    Tz::America__Cordoba => "America/Cordoba"
    Tz::America__Costa_Rica => "America/Costa_Rica"
    Tz::America__Coyhaique => "America/Coyhaique"
    Tz::America__Creston => "America/Creston"
    Tz::America__Cuiaba => "America/Cuiaba"
    Tz::America__Curacao => "America/Curacao"
    Tz::America__Danmarkshavn => "America/Danmarkshavn"
    Tz::America__Dawson => "America/Dawson"
    Tz::America__Dawson_Creek => "America/Dawson_Creek"
    Tz::America__Denver => "America/Denver"
    Tz::America__Detroit => "America/Detroit"
    Tz::America__Dominica => "America/Dominica"
    Tz::America__Edmonton => "America/Edmonton"
    Tz::America__Eirunepe => "America/Eirunepe"
    Tz::America__El_Salvador => "America/El_Salvador"
    Tz::America__Ensenada => "America/Ensenada"
    Tz::America__Fort_Nelson => "America/Fort_Nelson"
    Tz::America__Fort_Wayne => "America/Fort_Wayne"
    Tz::America__Fortaleza => "America/Fortaleza"
    Tz::America__Glace_Bay => "America/Glace_Bay"
    Tz::America__Godthab => "America/Godthab"
    Tz::America__Goose_Bay => "America/Goose_Bay"
    Tz::America__Grand_Turk => "America/Grand_Turk"
    Tz::America__Grenada => "America/Grenada"
    Tz::America__Guadeloupe => "America/Guadeloupe"
    Tz::America__Guatemala => "America/Guatemala"
    Tz::America__Guayaquil => "America/Guayaquil"
    Tz::America__Guyana => "America/Guyana"
    Tz::America__Halifax => "America/Halifax"
    Tz::America__Havana => "America/Havana"
    Tz::America__Hermosillo => "America/Hermosillo"
    Tz::America__Indiana__Indianapolis => "America/Indiana/Indianapolis"
    Tz::America__Indiana__Knox => "America/Indiana/Knox"
    Tz::America__Indiana__Marengo => "America/Indiana/Marengo"
    Tz::America__Indiana__Petersburg => "America/Indiana/Petersburg"
    Tz::America__Indiana__Tell_City => "America/Indiana/Tell_City"
    Tz::America__Indiana__Vevay => "America/Indiana/Vevay"
    Tz::America__Indiana__Vincennes => "America/Indiana/Vincennes"
    Tz::America__Indiana__Winamac => "America/Indiana/Winamac"
    Tz::America__Indianapolis => "America/Indianapolis"
    Tz::America__Inuvik => "America/Inuvik"
    Tz::America__Iqaluit => "America/Iqaluit"
    Tz::America__Jamaica => "America/Jamaica"
    Tz::America__Jujuy => "America/Jujuy"
    Tz::America__Juneau => "America/Juneau"
    Tz::America__Kentucky__Louisville => "America/Kentucky/Louisville"
    Tz::America__Kentucky__Monticello => "America/Kentucky/Monticello"
    Tz::America__Knox_IN => "America/Knox_IN"
    Tz::America__Kralendijk => "America/Kralendijk"
    Tz::America__La_Paz => "America/La_Paz"
    Tz::America__Lima => "America/Lima"
    Tz::America__Los_Angeles => "America/Los_Angeles"
    Tz::America__Louisville => "America/Louisville"
    Tz::America__Lower_Princes => "America/Lower_Princes"
    Tz::America__Maceio => "America/Maceio"
    Tz::America__Managua => "America/Managua"
    Tz::America__Manaus => "America/Manaus"
    Tz::America__Marigot => "America/Marigot"
    Tz::America__Martinique => "America/Martinique"
    Tz::America__Matamoros => "America/Matamoros"
    Tz::America__Mazatlan => "America/Mazatlan"
    Tz::America__Mendoza => "America/Mendoza"
    Tz::America__Menominee => "America/Menominee"
    Tz::America__Merida => "America/Merida"
    Tz::America__Metlakatla => "America/Metlakatla"
    Tz::America__Mexico_City => "America/Mexico_City"
    Tz::America__Miquelon => "America/Miquelon"
    Tz::America__Moncton => "America/Moncton"
    Tz::America__Monterrey => "America/Monterrey"
    Tz::America__Montevideo => "America/Montevideo"
    Tz::America__Montreal => "America/Montreal"
    Tz::America__Montserrat => "America/Montserrat"
    Tz::America__Nassau => "America/Nassau"
    Tz::America__New_York => "America/New_York"
    Tz::America__Nipigon => "America/Nipigon"
    Tz::America__Nome => "America/Nome"
    Tz::America__Noronha => "America/Noronha"
    Tz::America__North_Dakota__Beulah => "America/North_Dakota/Beulah"
    Tz::America__North_Dakota__Center => "America/North_Dakota/Center"
    Tz::America__North_Dakota__New_Salem => "America/North_Dakota/New_Salem"
    Tz::America__Nuuk => "America/Nuuk"
    Tz::America__Ojinaga => "America/Ojinaga"
    Tz::America__Panama => "America/Panama"
    Tz::America__Pangnirtung => "America/Pangnirtung"
    Tz::America__Paramaribo => "America/Paramaribo"
    Tz::America__Phoenix => "America/Phoenix"
    Tz::America__PortauPrince => "America/Port-au-Prince"
    Tz::America__Port_of_Spain => "America/Port_of_Spain"
    Tz::America__Porto_Acre => "America/Porto_Acre"
    Tz::America__Porto_Velho => "America/Porto_Velho"
    Tz::America__Puerto_Rico => "America/Puerto_Rico"
    Tz::America__Punta_Arenas => "America/Punta_Arenas"
    Tz::America__Rainy_River => "America/Rainy_River"
    Tz::America__Rankin_Inlet => "America/Rankin_Inlet"
    Tz::America__Recife => "America/Recife"
    Tz::America__Regina => "America/Regina"
    Tz::America__Resolute => "America/Resolute"
    Tz::America__Rio_Branco => "America/Rio_Branco"
    Tz::America__Rosario => "America/Rosario"
    Tz::America__Santa_Isabel => "America/Santa_Isabel"
    Tz::America__Santarem => "America/Santarem"
    Tz::America__Santiago => "America/Santiago"
    Tz::America__Santo_Domingo => "America/Santo_Domingo"
    Tz::America__Sao_Paulo => "America/Sao_Paulo"
    Tz::America__Scoresbysund => "America/Scoresbysund"
    Tz::America__Shiprock => "America/Shiprock"
    Tz::America__Sitka => "America/Sitka"
    Tz::America__St_Barthelemy => "America/St_Barthelemy"
    Tz::America__St_Johns => "America/St_Johns"
    Tz::America__St_Kitts => "America/St_Kitts"
    Tz::America__St_Lucia => "America/St_Lucia"
    Tz::America__St_Thomas => "America/St_Thomas"
    Tz::America__St_Vincent => "America/St_Vincent"
    Tz::America__Swift_Current => "America/Swift_Current"
    Tz::America__Tegucigalpa => "America/Tegucigalpa"
    Tz::America__Thule => "America/Thule"
    Tz::America__Thunder_Bay => "America/Thunder_Bay"
    Tz::America__Tijuana => "America/Tijuana"
    Tz::America__Toronto => "America/Toronto"
    Tz::America__Tortola => "America/Tortola"
    Tz::America__Vancouver => "America/Vancouver"
    Tz::America__Virgin => "America/Virgin"
    Tz::America__Whitehorse => "America/Whitehorse"
    Tz::America__Winnipeg => "America/Winnipeg"
    Tz::America__Yakutat => "America/Yakutat"
    Tz::America__Yellowknife => "America/Yellowknife"
    Tz::Antarctica__Casey => "Antarctica/Casey"
    Tz::Antarctica__Davis => "Antarctica/Davis"
    Tz::Antarctica__DumontDUrville => "Antarctica/DumontDUrville"
    Tz::Antarctica__Macquarie => "Antarctica/Macquarie"
    Tz::Antarctica__Mawson => "Antarctica/Mawson"
    Tz::Antarctica__McMurdo => "Antarctica/McMurdo"
    Tz::Antarctica__Palmer => "Antarctica/Palmer"
    Tz::Antarctica__Rothera => "Antarctica/Rothera"
    Tz::Antarctica__South_Pole => "Antarctica/South_Pole"
    Tz::Antarctica__Syowa => "Antarctica/Syowa"
    Tz::Antarctica__Troll => "Antarctica/Troll"
    Tz::Antarctica__Vostok => "Antarctica/Vostok"
    Tz::Arctic__Longyearbyen => "Arctic/Longyearbyen"
    Tz::Asia__Aden => "Asia/Aden"
    Tz::Asia__Almaty => "Asia/Almaty"
    Tz::Asia__Amman => "Asia/Amman"
    Tz::Asia__Anadyr => "Asia/Anadyr"
    Tz::Asia__Aqtau => "Asia/Aqtau"
    Tz::Asia__Aqtobe => "Asia/Aqtobe"
    Tz::Asia__Ashgabat => "Asia/Ashgabat"
    Tz::Asia__Ashkhabad => "Asia/Ashkhabad"
    Tz::Asia__Atyrau => "Asia/Atyrau"
    Tz::Asia__Baghdad => "Asia/Baghdad"
    Tz::Asia__Bahrain => "Asia/Bahrain"
    Tz::Asia__Baku => "Asia/Baku"
    Tz::Asia__Bangkok => "Asia/Bangkok"
    Tz::Asia__Barnaul => "Asia/Barnaul"
    Tz::Asia__Beirut => "Asia/Beirut"
    Tz::Asia__Bishkek => "Asia/Bishkek"
    Tz::Asia__Brunei => "Asia/Brunei"
    Tz::Asia__Calcutta => "Asia/Calcutta"
    Tz::Asia__Chita => "Asia/Chita"
    Tz::Asia__Choibalsan => "Asia/Choibalsan"
    Tz::Asia__Chongqing => "Asia/Chongqing"
    Tz::Asia__Chungking => "Asia/Chungking"
    Tz::Asia__Colombo => "Asia/Colombo"
    Tz::Asia__Dacca => "Asia/Dacca"
    Tz::Asia__Damascus => "Asia/Damascus"
    Tz::Asia__Dhaka => "Asia/Dhaka"
    Tz::Asia__Dili => "Asia/Dili"
    Tz::Asia__Dubai => "Asia/Dubai"
    Tz::Asia__Dushanbe => "Asia/Dushanbe"
    Tz::Asia__Famagusta => "Asia/Famagusta"
    Tz::Asia__Gaza => "Asia/Gaza"
    Tz::Asia__Harbin => "Asia/Harbin"
    Tz::Asia__Hebron => "Asia/Hebron"
    Tz::Asia__Ho_Chi_Minh => "Asia/Ho_Chi_Minh"
    Tz::Asia__Hong_Kong => "Asia/Hong_Kong"
    Tz::Asia__Hovd => "Asia/Hovd"
    Tz::Asia__Irkutsk => "Asia/Irkutsk"
    Tz::Asia__Istanbul => "Asia/Istanbul"
    Tz::Asia__Jakarta => "Asia/Jakarta"
    Tz::Asia__Jayapura => "Asia/Jayapura"
    Tz::Asia__Jerusalem => "Asia/Jerusalem"
    Tz::Asia__Kabul => "Asia/Kabul"
    Tz::Asia__Kamchatka => "Asia/Kamchatka"
    Tz::Asia__Karachi => "Asia/Karachi"
    Tz::Asia__Kashgar => "Asia/Kashgar"
    Tz::Asia__Kathmandu => "Asia/Kathmandu"
    Tz::Asia__Katmandu => "Asia/Katmandu"
    Tz::Asia__Khandyga => "Asia/Khandyga"
    Tz::Asia__Kolkata => "Asia/Kolkata"
    Tz::Asia__Krasnoyarsk => "Asia/Krasnoyarsk"
    Tz::Asia__Kuala_Lumpur => "Asia/Kuala_Lumpur"
    Tz::Asia__Kuching => "Asia/Kuching"
    Tz::Asia__Kuwait => "Asia/Kuwait"
    Tz::Asia__Macao => "Asia/Macao"
    Tz::Asia__Macau => "Asia/Macau"
    Tz::Asia__Magadan => "Asia/Magadan"
    Tz::Asia__Makassar => "Asia/Makassar"
    Tz::Asia__Manila => "Asia/Manila"
    Tz::Asia__Muscat => "Asia/Muscat"
    Tz::Asia__Nicosia => "Asia/Nicosia"
    Tz::Asia__Novokuznetsk => "Asia/Novokuznetsk"
    Tz::Asia__Novosibirsk => "Asia/Novosibirsk"
    Tz::Asia__Omsk => "Asia/Omsk"
    Tz::Asia__Oral => "Asia/Oral"
    Tz::Asia__Phnom_Penh => "Asia/Phnom_Penh"
    Tz::Asia__Pontianak => "Asia/Pontianak"
    Tz::Asia__Pyongyang => "Asia/Pyongyang"
    Tz::Asia__Qatar => "Asia/Qatar"
    Tz::Asia__Qostanay => "Asia/Qostanay"
    Tz::Asia__Qyzylorda => "Asia/Qyzylorda"
    Tz::Asia__Rangoon => "Asia/Rangoon"
    Tz::Asia__Riyadh => "Asia/Riyadh"
    Tz::Asia__Saigon => "Asia/Saigon"
    Tz::Asia__Sakhalin => "Asia/Sakhalin"
    Tz::Asia__Samarkand => "Asia/Samarkand"
    Tz::Asia__Seoul => "Asia/Seoul"
    Tz::Asia__Shanghai => "Asia/Shanghai"
    Tz::Asia__Singapore => "Asia/Singapore"
    Tz::Asia__Srednekolymsk => "Asia/Srednekolymsk"
    Tz::Asia__Taipei => "Asia/Taipei"
    Tz::Asia__Tashkent => "Asia/Tashkent"
    Tz::Asia__Tbilisi => "Asia/Tbilisi"
    Tz::Asia__Tehran => "Asia/Tehran"
    Tz::Asia__Tel_Aviv => "Asia/Tel_Aviv"
    Tz::Asia__Thimbu => "Asia/Thimbu"
    Tz::Asia__Thimphu => "Asia/Thimphu"
    Tz::Asia__Tokyo => "Asia/Tokyo"
    Tz::Asia__Tomsk => "Asia/Tomsk"
    Tz::Asia__Ujung_Pandang => "Asia/Ujung_Pandang"
    Tz::Asia__Ulaanbaatar => "Asia/Ulaanbaatar"
    Tz::Asia__Ulan_Bator => "Asia/Ulan_Bator"
    Tz::Asia__Urumqi => "Asia/Urumqi"
    Tz::Asia__UstNera => "Asia/Ust-Nera"
    Tz::Asia__Vientiane => "Asia/Vientiane"
    Tz::Asia__Vladivostok => "Asia/Vladivostok"
    Tz::Asia__Yakutsk => "Asia/Yakutsk"
    Tz::Asia__Yangon => "Asia/Yangon"
    Tz::Asia__Yekaterinburg => "Asia/Yekaterinburg"
    Tz::Asia__Yerevan => "Asia/Yerevan"
    Tz::Atlantic__Azores => "Atlantic/Azores"
    Tz::Atlantic__Bermuda => "Atlantic/Bermuda"
    Tz::Atlantic__Canary => "Atlantic/Canary"
    Tz::Atlantic__Cape_Verde => "Atlantic/Cape_Verde"
    Tz::Atlantic__Faeroe => "Atlantic/Faeroe"
    Tz::Atlantic__Faroe => "Atlantic/Faroe"
    Tz::Atlantic__Jan_Mayen => "Atlantic/Jan_Mayen"
    Tz::Atlantic__Madeira => "Atlantic/Madeira"
    Tz::Atlantic__Reykjavik => "Atlantic/Reykjavik"
    Tz::Atlantic__South_Georgia => "Atlantic/South_Georgia"
    Tz::Atlantic__St_Helena => "Atlantic/St_Helena"
    Tz::Atlantic__Stanley => "Atlantic/Stanley"
    Tz::Australia__ACT => "Australia/ACT"
    Tz::Australia__Adelaide => "Australia/Adelaide"
    Tz::Australia__Brisbane => "Australia/Brisbane"
    Tz::Australia__Broken_Hill => "Australia/Broken_Hill"
    Tz::Australia__Canberra => "Australia/Canberra"
    Tz::Australia__Currie => "Australia/Currie"
    Tz::Australia__Darwin => "Australia/Darwin"
    Tz::Australia__Eucla => "Australia/Eucla"
    Tz::Australia__Hobart => "Australia/Hobart"
    Tz::Australia__LHI => "Australia/LHI"
    Tz::Australia__Lindeman => "Australia/Lindeman"
    Tz::Australia__Lord_Howe => "Australia/Lord_Howe"
    Tz::Australia__Melbourne => "Australia/Melbourne"
    Tz::Australia__NSW => "Australia/NSW"
    Tz::Australia__North => "Australia/North"
    Tz::Australia__Perth => "Australia/Perth"
    Tz::Australia__Queensland => "Australia/Queensland"
    Tz::Australia__South => "Australia/South"
    Tz::Australia__Sydney => "Australia/Sydney"
    Tz::Australia__Tasmania => "Australia/Tasmania"
    Tz::Australia__Victoria => "Australia/Victoria"
    Tz::Australia__West => "Australia/West"
    Tz::Australia__Yancowinna => "Australia/Yancowinna"
    Tz::Brazil__Acre => "Brazil/Acre"
    Tz::Brazil__DeNoronha => "Brazil/DeNoronha"
    Tz::Brazil__East => "Brazil/East"
    Tz::Brazil__West => "Brazil/West"
    Tz::CET => "CET"
    Tz::CST6CDT => "CST6CDT"
    Tz::Canada__Atlantic => "Canada/Atlantic"
    Tz::Canada__Central => "Canada/Central"
    Tz::Canada__Eastern => "Canada/Eastern"
    Tz::Canada__Mountain => "Canada/Mountain"
    Tz::Canada__Newfoundland => "Canada/Newfoundland"
    Tz::Canada__Pacific => "Canada/Pacific"
    Tz::Canada__Saskatchewan => "Canada/Saskatchewan"
    Tz::Canada__Yukon => "Canada/Yukon"
    Tz::Chile__Continental => "Chile/Continental"
    Tz::Chile__EasterIsland => "Chile/EasterIsland"
    Tz::Cuba => "Cuba"
    Tz::EET => "EET"
    Tz::EST => "EST"
    Tz::EST5EDT => "EST5EDT"
    Tz::Egypt => "Egypt"
    Tz::Eire => "Eire"
    Tz::Etc__GMT => "Etc/GMT"
    Tz::Etc__GMTPlus0 => "Etc/GMT+0"
    Tz::Etc__GMTPlus1 => "Etc/GMT+1"
    Tz::Etc__GMTPlus10 => "Etc/GMT+10"
    Tz::Etc__GMTPlus11 => "Etc/GMT+11"
    Tz::Etc__GMTPlus12 => "Etc/GMT+12"
    Tz::Etc__GMTPlus2 => "Etc/GMT+2"
    Tz::Etc__GMTPlus3 => "Etc/GMT+3"
    Tz::Etc__GMTPlus4 => "Etc/GMT+4"
    Tz::Etc__GMTPlus5 => "Etc/GMT+5"
    Tz::Etc__GMTPlus6 => "Etc/GMT+6"
    Tz::Etc__GMTPlus7 => "Etc/GMT+7"
    Tz::Etc__GMTPlus8 => "Etc/GMT+8"
    Tz::Etc__GMTPlus9 => "Etc/GMT+9"
    Tz::Etc__GMTMinus0 => "Etc/GMT-0"
    Tz::Etc__GMTMinus1 => "Etc/GMT-1"
    Tz::Etc__GMTMinus10 => "Etc/GMT-10"
    Tz::Etc__GMTMinus11 => "Etc/GMT-11"
    Tz::Etc__GMTMinus12 => "Etc/GMT-12"
    Tz::Etc__GMTMinus13 => "Etc/GMT-13"
    Tz::Etc__GMTMinus14 => "Etc/GMT-14"
    Tz::Etc__GMTMinus2 => "Etc/GMT-2"
    Tz::Etc__GMTMinus3 => "Etc/GMT-3"
    Tz::Etc__GMTMinus4 => "Etc/GMT-4"
    Tz::Etc__GMTMinus5 => "Etc/GMT-5"
    Tz::Etc__GMTMinus6 => "Etc/GMT-6"
    Tz::Etc__GMTMinus7 => "Etc/GMT-7"
    Tz::Etc__GMTMinus8 => "Etc/GMT-8"
    Tz::Etc__GMTMinus9 => "Etc/GMT-9"
    Tz::Etc__GMT0 => "Etc/GMT0"
    Tz::Etc__Greenwich => "Etc/Greenwich"
    Tz::Etc__UCT => "Etc/UCT"
    Tz::Etc__UTC => "Etc/UTC"
    Tz::Etc__Universal => "Etc/Universal"
    Tz::Etc__Zulu => "Etc/Zulu"
    Tz::Europe__Amsterdam => "Europe/Amsterdam"
    Tz::Europe__Andorra => "Europe/Andorra"
    Tz::Europe__Astrakhan => "Europe/Astrakhan"
    Tz::Europe__Athens => "Europe/Athens"
    Tz::Europe__Belfast => "Europe/Belfast"
    Tz::Europe__Belgrade => "Europe/Belgrade"
    Tz::Europe__Berlin => "Europe/Berlin"
    Tz::Europe__Bratislava => "Europe/Bratislava"
    Tz::Europe__Brussels => "Europe/Brussels"
    Tz::Europe__Bucharest => "Europe/Bucharest"
    Tz::Europe__Budapest => "Europe/Budapest"
    Tz::Europe__Busingen => "Europe/Busingen"
    Tz::Europe__Chisinau => "Europe/Chisinau"
    Tz::Europe__Copenhagen => "Europe/Copenhagen"
    Tz::Europe__Dublin => "Europe/Dublin"
    Tz::Europe__Gibraltar => "Europe/Gibraltar"
    Tz::Europe__Guernsey => "Europe/Guernsey"
    Tz::Europe__Helsinki => "Europe/Helsinki"
    Tz::Europe__Isle_of_Man => "Europe/Isle_of_Man"
    Tz::Europe__Istanbul => "Europe/Istanbul"
    Tz::Europe__Jersey => "Europe/Jersey"
    Tz::Europe__Kaliningrad => "Europe/Kaliningrad"
    Tz::Europe__Kiev => "Europe/Kiev"
    Tz::Europe__Kirov => "Europe/Kirov"
    Tz::Europe__Kyiv => "Europe/Kyiv"
    Tz::Europe__Lisbon => "Europe/Lisbon"
    Tz::Europe__Ljubljana => "Europe/Ljubljana"
    Tz::Europe__London => "Europe/London"
    Tz::Europe__Luxembourg => "Europe/Luxembourg"
    Tz::Europe__Madrid => "Europe/Madrid"
    Tz::Europe__Malta => "Europe/Malta"
    Tz::Europe__Mariehamn => "Europe/Mariehamn"
    Tz::Europe__Minsk => "Europe/Minsk"
    Tz::Europe__Monaco => "Europe/Monaco"
    Tz::Europe__Moscow => "Europe/Moscow"
    Tz::Europe__Nicosia => "Europe/Nicosia"
    Tz::Europe__Oslo => "Europe/Oslo"
    Tz::Europe__Paris => "Europe/Paris"
    Tz::Europe__Podgorica => "Europe/Podgorica"
    Tz::Europe__Prague => "Europe/Prague"
    Tz::Europe__Riga => "Europe/Riga"
    Tz::Europe__Rome => "Europe/Rome"
    Tz::Europe__Samara => "Europe/Samara"
    Tz::Europe__San_Marino => "Europe/San_Marino"
    Tz::Europe__Sarajevo => "Europe/Sarajevo"
    Tz::Europe__Saratov => "Europe/Saratov"
    Tz::Europe__Simferopol => "Europe/Simferopol"
    Tz::Europe__Skopje => "Europe/Skopje"
    Tz::Europe__Sofia => "Europe/Sofia"
    Tz::Europe__Stockholm => "Europe/Stockholm"
    Tz::Europe__Tallinn => "Europe/Tallinn"
    Tz::Europe__Tirane => "Europe/Tirane"
    Tz::Europe__Tiraspol => "Europe/Tiraspol"
    Tz::Europe__Ulyanovsk => "Europe/Ulyanovsk"
    Tz::Europe__Uzhgorod => "Europe/Uzhgorod"
    Tz::Europe__Vaduz => "Europe/Vaduz"
    Tz::Europe__Vatican => "Europe/Vatican"
    Tz::Europe__Vienna => "Europe/Vienna"
    Tz::Europe__Vilnius => "Europe/Vilnius"
    Tz::Europe__Volgograd => "Europe/Volgograd"
    Tz::Europe__Warsaw => "Europe/Warsaw"
    Tz::Europe__Zagreb => "Europe/Zagreb"
    Tz::Europe__Zaporozhye => "Europe/Zaporozhye"
    Tz::Europe__Zurich => "Europe/Zurich"
    Tz::GB => "GB"
    Tz::GBEire => "GB-Eire"
    Tz::GMT => "GMT"
    Tz::GMTPlus0 => "GMT+0"
    Tz::GMTMinus0 => "GMT-0"
    Tz::GMT0 => "GMT0"
    Tz::Greenwich => "Greenwich"
    Tz::HST => "HST"
    Tz::Hongkong => "Hongkong"
    Tz::Iceland => "Iceland"
    Tz::Indian__Antananarivo => "Indian/Antananarivo"
    Tz::Indian__Chagos => "Indian/Chagos"
    Tz::Indian__Christmas => "Indian/Christmas"
    Tz::Indian__Cocos => "Indian/Cocos"
    Tz::Indian__Comoro => "Indian/Comoro"
    Tz::Indian__Kerguelen => "Indian/Kerguelen"
    Tz::Indian__Mahe => "Indian/Mahe"
    Tz::Indian__Maldives => "Indian/Maldives"
    Tz::Indian__Mauritius => "Indian/Mauritius"
    Tz::Indian__Mayotte => "Indian/Mayotte"
    Tz::Indian__Reunion => "Indian/Reunion"
    Tz::Iran => "Iran"
    Tz::Israel => "Israel"
    Tz::Jamaica => "Jamaica"
    Tz::Japan => "Japan"
    Tz::Kwajalein => "Kwajalein"
    Tz::Libya => "Libya"
    Tz::MET => "MET"
    Tz::MST => "MST"
    Tz::MST7MDT => "MST7MDT"
    Tz::Mexico__BajaNorte => "Mexico/BajaNorte"
    Tz::Mexico__BajaSur => "Mexico/BajaSur"
    Tz::Mexico__General => "Mexico/General"
    Tz::NZ => "NZ"
    Tz::NZCHAT => "NZ-CHAT"
    Tz::Navajo => "Navajo"
    Tz::PRC => "PRC"
    Tz::PST8PDT => "PST8PDT"
    Tz::Pacific__Apia => "Pacific/Apia"
    Tz::Pacific__Auckland => "Pacific/Auckland"
    Tz::Pacific__Bougainville => "Pacific/Bougainville"
    Tz::Pacific__Chatham => "Pacific/Chatham"
    Tz::Pacific__Chuuk => "Pacific/Chuuk"
    Tz::Pacific__Easter => "Pacific/Easter"
    Tz::Pacific__Efate => "Pacific/Efate"
    Tz::Pacific__Enderbury => "Pacific/Enderbury"
    Tz::Pacific__Fakaofo => "Pacific/Fakaofo"
    Tz::Pacific__Fiji => "Pacific/Fiji"
    Tz::Pacific__Funafuti => "Pacific/Funafuti"
    Tz::Pacific__Galapagos => "Pacific/Galapagos"
    Tz::Pacific__Gambier => "Pacific/Gambier"
    Tz::Pacific__Guadalcanal => "Pacific/Guadalcanal"
    Tz::Pacific__Guam => "Pacific/Guam"
    Tz::Pacific__Honolulu => "Pacific/Honolulu"
    Tz::Pacific__Johnston => "Pacific/Johnston"
    Tz::Pacific__Kanton => "Pacific/Kanton"
    Tz::Pacific__Kiritimati => "Pacific/Kiritimati"
    Tz::Pacific__Kosrae => "Pacific/Kosrae"
    Tz::Pacific__Kwajalein => "Pacific/Kwajalein"
    Tz::Pacific__Majuro => "Pacific/Majuro"
    Tz::Pacific__Marquesas => "Pacific/Marquesas"
    Tz::Pacific__Midway => "Pacific/Midway"
    Tz::Pacific__Nauru => "Pacific/Nauru"
    Tz::Pacific__Niue => "Pacific/Niue"
    Tz::Pacific__Norfolk => "Pacific/Norfolk"
    Tz::Pacific__Noumea => "Pacific/Noumea"
    Tz::Pacific__Pago_Pago => "Pacific/Pago_Pago"
    Tz::Pacific__Palau => "Pacific/Palau"
    Tz::Pacific__Pitcairn => "Pacific/Pitcairn"
    Tz::Pacific__Pohnpei => "Pacific/Pohnpei"
    Tz::Pacific__Ponape => "Pacific/Ponape"
    Tz::Pacific__Port_Moresby => "Pacific/Port_Moresby"
    Tz::Pacific__Rarotonga => "Pacific/Rarotonga"
    Tz::Pacific__Saipan => "Pacific/Saipan"
    Tz::Pacific__Samoa => "Pacific/Samoa"
    Tz::Pacific__Tahiti => "Pacific/Tahiti"
    Tz::Pacific__Tarawa => "Pacific/Tarawa"
    Tz::Pacific__Tongatapu => "Pacific/Tongatapu"
    Tz::Pacific__Truk => "Pacific/Truk"
    Tz::Pacific__Wake => "Pacific/Wake"
    Tz::Pacific__Wallis => "Pacific/Wallis"
    Tz::Pacific__Yap => "Pacific/Yap"
    Tz::Poland => "Poland"
    Tz::Portugal => "Portugal"
    Tz::ROC => "ROC"
    Tz::ROK => "ROK"
    Tz::Singapore => "Singapore"
    Tz::Turkey => "Turkey"
    Tz::UCT => "UCT"
    Tz::US__Alaska => "US/Alaska"
    Tz::US__Aleutian => "US/Aleutian"
    Tz::US__Arizona => "US/Arizona"
    Tz::US__Central => "US/Central"
    Tz::US__EastIndiana => "US/East-Indiana"
    Tz::US__Eastern => "US/Eastern"
    Tz::US__Hawaii => "US/Hawaii"
    Tz::US__IndianaStarke => "US/Indiana-Starke"
    Tz::US__Michigan => "US/Michigan"
    Tz::US__Mountain => "US/Mountain"
    Tz::US__Pacific => "US/Pacific"
    Tz::US__Samoa => "US/Samoa"
    Tz::UTC => "UTC"
    Tz::Universal => "Universal"
    Tz::WSU => "W-SU"
    Tz::WET => "WET"
    Tz::Zulu => "Zulu"
  }
}

///|

///|
/// NAME_TO_TZ 二分查找表（IANA ID 升序 → Tz variant）。
let name_to_tz : Array[(String, Tz)] = [
  ("Africa/Abidjan", Tz::Africa__Abidjan),
  ("Africa/Accra", Tz::Africa__Accra),
  ("Africa/Addis_Ababa", Tz::Africa__Addis_Ababa),
  ("Africa/Algiers", Tz::Africa__Algiers),
  ("Africa/Asmara", Tz::Africa__Asmara),
  ("Africa/Asmera", Tz::Africa__Asmera),
  ("Africa/Bamako", Tz::Africa__Bamako),
  ("Africa/Bangui", Tz::Africa__Bangui),
  ("Africa/Banjul", Tz::Africa__Banjul),
  ("Africa/Bissau", Tz::Africa__Bissau),
  ("Africa/Blantyre", Tz::Africa__Blantyre),
  ("Africa/Brazzaville", Tz::Africa__Brazzaville),
  ("Africa/Bujumbura", Tz::Africa__Bujumbura),
  ("Africa/Cairo", Tz::Africa__Cairo),
  ("Africa/Casablanca", Tz::Africa__Casablanca),
  ("Africa/Ceuta", Tz::Africa__Ceuta),
  ("Africa/Conakry", Tz::Africa__Conakry),
  ("Africa/Dakar", Tz::Africa__Dakar),
  ("Africa/Dar_es_Salaam", Tz::Africa__Dar_es_Salaam),
  ("Africa/Djibouti", Tz::Africa__Djibouti),
  ("Africa/Douala", Tz::Africa__Douala),
  ("Africa/El_Aaiun", Tz::Africa__El_Aaiun),
  ("Africa/Freetown", Tz::Africa__Freetown),
  ("Africa/Gaborone", Tz::Africa__Gaborone),
  ("Africa/Harare", Tz::Africa__Harare),
  ("Africa/Johannesburg", Tz::Africa__Johannesburg),
  ("Africa/Juba", Tz::Africa__Juba),
  ("Africa/Kampala", Tz::Africa__Kampala),
  ("Africa/Khartoum", Tz::Africa__Khartoum),
  ("Africa/Kigali", Tz::Africa__Kigali),
  ("Africa/Kinshasa", Tz::Africa__Kinshasa),
  ("Africa/Lagos", Tz::Africa__Lagos),
  ("Africa/Libreville", Tz::Africa__Libreville),
  ("Africa/Lome", Tz::Africa__Lome),
  ("Africa/Luanda", Tz::Africa__Luanda),
  ("Africa/Lubumbashi", Tz::Africa__Lubumbashi),
  ("Africa/Lusaka", Tz::Africa__Lusaka),
  ("Africa/Malabo", Tz::Africa__Malabo),
  ("Africa/Maputo", Tz::Africa__Maputo),
  ("Africa/Maseru", Tz::Africa__Maseru),
  ("Africa/Mbabane", Tz::Africa__Mbabane),
  ("Africa/Mogadishu", Tz::Africa__Mogadishu),
  ("Africa/Monrovia", Tz::Africa__Monrovia),
  ("Africa/Nairobi", Tz::Africa__Nairobi),
  ("Africa/Ndjamena", Tz::Africa__Ndjamena),
  ("Africa/Niamey", Tz::Africa__Niamey),
  ("Africa/Nouakchott", Tz::Africa__Nouakchott),
  ("Africa/Ouagadougou", Tz::Africa__Ouagadougou),
  ("Africa/Porto-Novo", Tz::Africa__PortoNovo),
  ("Africa/Sao_Tome", Tz::Africa__Sao_Tome),
  ("Africa/Timbuktu", Tz::Africa__Timbuktu),
  ("Africa/Tripoli", Tz::Africa__Tripoli),
  ("Africa/Tunis", Tz::Africa__Tunis),
  ("Africa/Windhoek", Tz::Africa__Windhoek),
  ("America/Adak", Tz::America__Adak),
  ("America/Anchorage", Tz::America__Anchorage),
  ("America/Anguilla", Tz::America__Anguilla),
  ("America/Antigua", Tz::America__Antigua),
  ("America/Araguaina", Tz::America__Araguaina),
  ("America/Argentina/Buenos_Aires", Tz::America__Argentina__Buenos_Aires),
  ("America/Argentina/Catamarca", Tz::America__Argentina__Catamarca),
  ("America/Argentina/ComodRivadavia", Tz::America__Argentina__ComodRivadavia),
  ("America/Argentina/Cordoba", Tz::America__Argentina__Cordoba),
  ("America/Argentina/Jujuy", Tz::America__Argentina__Jujuy),
  ("America/Argentina/La_Rioja", Tz::America__Argentina__La_Rioja),
  ("America/Argentina/Mendoza", Tz::America__Argentina__Mendoza),
  ("America/Argentina/Rio_Gallegos", Tz::America__Argentina__Rio_Gallegos),
  ("America/Argentina/Salta", Tz::America__Argentina__Salta),
  ("America/Argentina/San_Juan", Tz::America__Argentina__San_Juan),
  ("America/Argentina/San_Luis", Tz::America__Argentina__San_Luis),
  ("America/Argentina/Tucuman", Tz::America__Argentina__Tucuman),
  ("America/Argentina/Ushuaia", Tz::America__Argentina__Ushuaia),
  ("America/Aruba", Tz::America__Aruba),
  ("America/Asuncion", Tz::America__Asuncion),
  ("America/Atikokan", Tz::America__Atikokan),
  ("America/Atka", Tz::America__Atka),
  ("America/Bahia", Tz::America__Bahia),
  ("America/Bahia_Banderas", Tz::America__Bahia_Banderas),
  ("America/Barbados", Tz::America__Barbados),
  ("America/Belem", Tz::America__Belem),
  ("America/Belize", Tz::America__Belize),
  ("America/Blanc-Sablon", Tz::America__BlancSablon),
  ("America/Boa_Vista", Tz::America__Boa_Vista),
  ("America/Bogota", Tz::America__Bogota),
  ("America/Boise", Tz::America__Boise),
  ("America/Buenos_Aires", Tz::America__Buenos_Aires),
  ("America/Cambridge_Bay", Tz::America__Cambridge_Bay),
  ("America/Campo_Grande", Tz::America__Campo_Grande),
  ("America/Cancun", Tz::America__Cancun),
  ("America/Caracas", Tz::America__Caracas),
  ("America/Catamarca", Tz::America__Catamarca),
  ("America/Cayenne", Tz::America__Cayenne),
  ("America/Cayman", Tz::America__Cayman),
  ("America/Chicago", Tz::America__Chicago),
  ("America/Chihuahua", Tz::America__Chihuahua),
  ("America/Ciudad_Juarez", Tz::America__Ciudad_Juarez),
  ("America/Coral_Harbour", Tz::America__Coral_Harbour),
  ("America/Cordoba", Tz::America__Cordoba),
  ("America/Costa_Rica", Tz::America__Costa_Rica),
  ("America/Coyhaique", Tz::America__Coyhaique),
  ("America/Creston", Tz::America__Creston),
  ("America/Cuiaba", Tz::America__Cuiaba),
  ("America/Curacao", Tz::America__Curacao),
  ("America/Danmarkshavn", Tz::America__Danmarkshavn),
  ("America/Dawson", Tz::America__Dawson),
  ("America/Dawson_Creek", Tz::America__Dawson_Creek),
  ("America/Denver", Tz::America__Denver),
  ("America/Detroit", Tz::America__Detroit),
  ("America/Dominica", Tz::America__Dominica),
  ("America/Edmonton", Tz::America__Edmonton),
  ("America/Eirunepe", Tz::America__Eirunepe),
  ("America/El_Salvador", Tz::America__El_Salvador),
  ("America/Ensenada", Tz::America__Ensenada),
  ("America/Fort_Nelson", Tz::America__Fort_Nelson),
  ("America/Fort_Wayne", Tz::America__Fort_Wayne),
  ("America/Fortaleza", Tz::America__Fortaleza),
  ("America/Glace_Bay", Tz::America__Glace_Bay),
  ("America/Godthab", Tz::America__Godthab),
  ("America/Goose_Bay", Tz::America__Goose_Bay),
  ("America/Grand_Turk", Tz::America__Grand_Turk),
  ("America/Grenada", Tz::America__Grenada),
  ("America/Guadeloupe", Tz::America__Guadeloupe),
  ("America/Guatemala", Tz::America__Guatemala),
  ("America/Guayaquil", Tz::America__Guayaquil),
  ("America/Guyana", Tz::America__Guyana),
  ("America/Halifax", Tz::America__Halifax),
  ("America/Havana", Tz::America__Havana),
  ("America/Hermosillo", Tz::America__Hermosillo),
  ("America/Indiana/Indianapolis", Tz::America__Indiana__Indianapolis),
  ("America/Indiana/Knox", Tz::America__Indiana__Knox),
  ("America/Indiana/Marengo", Tz::America__Indiana__Marengo),
  ("America/Indiana/Petersburg", Tz::America__Indiana__Petersburg),
  ("America/Indiana/Tell_City", Tz::America__Indiana__Tell_City),
  ("America/Indiana/Vevay", Tz::America__Indiana__Vevay),
  ("America/Indiana/Vincennes", Tz::America__Indiana__Vincennes),
  ("America/Indiana/Winamac", Tz::America__Indiana__Winamac),
  ("America/Indianapolis", Tz::America__Indianapolis),
  ("America/Inuvik", Tz::America__Inuvik),
  ("America/Iqaluit", Tz::America__Iqaluit),
  ("America/Jamaica", Tz::America__Jamaica),
  ("America/Jujuy", Tz::America__Jujuy),
  ("America/Juneau", Tz::America__Juneau),
  ("America/Kentucky/Louisville", Tz::America__Kentucky__Louisville),
  ("America/Kentucky/Monticello", Tz::America__Kentucky__Monticello),
  ("America/Knox_IN", Tz::America__Knox_IN),
  ("America/Kralendijk", Tz::America__Kralendijk),
  ("America/La_Paz", Tz::America__La_Paz),
  ("America/Lima", Tz::America__Lima),
  ("America/Los_Angeles", Tz::America__Los_Angeles),
  ("America/Louisville", Tz::America__Louisville),
  ("America/Lower_Princes", Tz::America__Lower_Princes),
  ("America/Maceio", Tz::America__Maceio),
  ("America/Managua", Tz::America__Managua),
  ("America/Manaus", Tz::America__Manaus),
  ("America/Marigot", Tz::America__Marigot),
  ("America/Martinique", Tz::America__Martinique),
  ("America/Matamoros", Tz::America__Matamoros),
  ("America/Mazatlan", Tz::America__Mazatlan),
  ("America/Mendoza", Tz::America__Mendoza),
  ("America/Menominee", Tz::America__Menominee),
  ("America/Merida", Tz::America__Merida),
  ("America/Metlakatla", Tz::America__Metlakatla),
  ("America/Mexico_City", Tz::America__Mexico_City),
  ("America/Miquelon", Tz::America__Miquelon),
  ("America/Moncton", Tz::America__Moncton),
  ("America/Monterrey", Tz::America__Monterrey),
  ("America/Montevideo", Tz::America__Montevideo),
  ("America/Montreal", Tz::America__Montreal),
  ("America/Montserrat", Tz::America__Montserrat),
  ("America/Nassau", Tz::America__Nassau),
  ("America/New_York", Tz::America__New_York),
  ("America/Nipigon", Tz::America__Nipigon),
  ("America/Nome", Tz::America__Nome),
  ("America/Noronha", Tz::America__Noronha),
  ("America/North_Dakota/Beulah", Tz::America__North_Dakota__Beulah),
  ("America/North_Dakota/Center", Tz::America__North_Dakota__Center),
  ("America/North_Dakota/New_Salem", Tz::America__North_Dakota__New_Salem),
  ("America/Nuuk", Tz::America__Nuuk),
  ("America/Ojinaga", Tz::America__Ojinaga),
  ("America/Panama", Tz::America__Panama),
  ("America/Pangnirtung", Tz::America__Pangnirtung),
  ("America/Paramaribo", Tz::America__Paramaribo),
  ("America/Phoenix", Tz::America__Phoenix),
  ("America/Port-au-Prince", Tz::America__PortauPrince),
  ("America/Port_of_Spain", Tz::America__Port_of_Spain),
  ("America/Porto_Acre", Tz::America__Porto_Acre),
  ("America/Porto_Velho", Tz::America__Porto_Velho),
  ("America/Puerto_Rico", Tz::America__Puerto_Rico),
  ("America/Punta_Arenas", Tz::America__Punta_Arenas),
  ("America/Rainy_River", Tz::America__Rainy_River),
  ("America/Rankin_Inlet", Tz::America__Rankin_Inlet),
  ("America/Recife", Tz::America__Recife),
  ("America/Regina", Tz::America__Regina),
  ("America/Resolute", Tz::America__Resolute),
  ("America/Rio_Branco", Tz::America__Rio_Branco),
  ("America/Rosario", Tz::America__Rosario),
  ("America/Santa_Isabel", Tz::America__Santa_Isabel),
  ("America/Santarem", Tz::America__Santarem),
  ("America/Santiago", Tz::America__Santiago),
  ("America/Santo_Domingo", Tz::America__Santo_Domingo),
  ("America/Sao_Paulo", Tz::America__Sao_Paulo),
  ("America/Scoresbysund", Tz::America__Scoresbysund),
  ("America/Shiprock", Tz::America__Shiprock),
  ("America/Sitka", Tz::America__Sitka),
  ("America/St_Barthelemy", Tz::America__St_Barthelemy),
  ("America/St_Johns", Tz::America__St_Johns),
  ("America/St_Kitts", Tz::America__St_Kitts),
  ("America/St_Lucia", Tz::America__St_Lucia),
  ("America/St_Thomas", Tz::America__St_Thomas),
  ("America/St_Vincent", Tz::America__St_Vincent),
  ("America/Swift_Current", Tz::America__Swift_Current),
  ("America/Tegucigalpa", Tz::America__Tegucigalpa),
  ("America/Thule", Tz::America__Thule),
  ("America/Thunder_Bay", Tz::America__Thunder_Bay),
  ("America/Tijuana", Tz::America__Tijuana),
  ("America/Toronto", Tz::America__Toronto),
  ("America/Tortola", Tz::America__Tortola),
  ("America/Vancouver", Tz::America__Vancouver),
  ("America/Virgin", Tz::America__Virgin),
  ("America/Whitehorse", Tz::America__Whitehorse),
  ("America/Winnipeg", Tz::America__Winnipeg),
  ("America/Yakutat", Tz::America__Yakutat),
  ("America/Yellowknife", Tz::America__Yellowknife),
  ("Antarctica/Casey", Tz::Antarctica__Casey),
  ("Antarctica/Davis", Tz::Antarctica__Davis),
  ("Antarctica/DumontDUrville", Tz::Antarctica__DumontDUrville),
  ("Antarctica/Macquarie", Tz::Antarctica__Macquarie),
  ("Antarctica/Mawson", Tz::Antarctica__Mawson),
  ("Antarctica/McMurdo", Tz::Antarctica__McMurdo),
  ("Antarctica/Palmer", Tz::Antarctica__Palmer),
  ("Antarctica/Rothera", Tz::Antarctica__Rothera),
  ("Antarctica/South_Pole", Tz::Antarctica__South_Pole),
  ("Antarctica/Syowa", Tz::Antarctica__Syowa),
  ("Antarctica/Troll", Tz::Antarctica__Troll),
  ("Antarctica/Vostok", Tz::Antarctica__Vostok),
  ("Arctic/Longyearbyen", Tz::Arctic__Longyearbyen),
  ("Asia/Aden", Tz::Asia__Aden),
  ("Asia/Almaty", Tz::Asia__Almaty),
  ("Asia/Amman", Tz::Asia__Amman),
  ("Asia/Anadyr", Tz::Asia__Anadyr),
  ("Asia/Aqtau", Tz::Asia__Aqtau),
  ("Asia/Aqtobe", Tz::Asia__Aqtobe),
  ("Asia/Ashgabat", Tz::Asia__Ashgabat),
  ("Asia/Ashkhabad", Tz::Asia__Ashkhabad),
  ("Asia/Atyrau", Tz::Asia__Atyrau),
  ("Asia/Baghdad", Tz::Asia__Baghdad),
  ("Asia/Bahrain", Tz::Asia__Bahrain),
  ("Asia/Baku", Tz::Asia__Baku),
  ("Asia/Bangkok", Tz::Asia__Bangkok),
  ("Asia/Barnaul", Tz::Asia__Barnaul),
  ("Asia/Beirut", Tz::Asia__Beirut),
  ("Asia/Bishkek", Tz::Asia__Bishkek),
  ("Asia/Brunei", Tz::Asia__Brunei),
  ("Asia/Calcutta", Tz::Asia__Calcutta),
  ("Asia/Chita", Tz::Asia__Chita),
  ("Asia/Choibalsan", Tz::Asia__Choibalsan),
  ("Asia/Chongqing", Tz::Asia__Chongqing),
  ("Asia/Chungking", Tz::Asia__Chungking),
  ("Asia/Colombo", Tz::Asia__Colombo),
  ("Asia/Dacca", Tz::Asia__Dacca),
  ("Asia/Damascus", Tz::Asia__Damascus),
  ("Asia/Dhaka", Tz::Asia__Dhaka),
  ("Asia/Dili", Tz::Asia__Dili),
  ("Asia/Dubai", Tz::Asia__Dubai),
  ("Asia/Dushanbe", Tz::Asia__Dushanbe),
  ("Asia/Famagusta", Tz::Asia__Famagusta),
  ("Asia/Gaza", Tz::Asia__Gaza),
  ("Asia/Harbin", Tz::Asia__Harbin),
  ("Asia/Hebron", Tz::Asia__Hebron),
  ("Asia/Ho_Chi_Minh", Tz::Asia__Ho_Chi_Minh),
  ("Asia/Hong_Kong", Tz::Asia__Hong_Kong),
  ("Asia/Hovd", Tz::Asia__Hovd),
  ("Asia/Irkutsk", Tz::Asia__Irkutsk),
  ("Asia/Istanbul", Tz::Asia__Istanbul),
  ("Asia/Jakarta", Tz::Asia__Jakarta),
  ("Asia/Jayapura", Tz::Asia__Jayapura),
  ("Asia/Jerusalem", Tz::Asia__Jerusalem),
  ("Asia/Kabul", Tz::Asia__Kabul),
  ("Asia/Kamchatka", Tz::Asia__Kamchatka),
  ("Asia/Karachi", Tz::Asia__Karachi),
  ("Asia/Kashgar", Tz::Asia__Kashgar),
  ("Asia/Kathmandu", Tz::Asia__Kathmandu),
  ("Asia/Katmandu", Tz::Asia__Katmandu),
  ("Asia/Khandyga", Tz::Asia__Khandyga),
  ("Asia/Kolkata", Tz::Asia__Kolkata),
  ("Asia/Krasnoyarsk", Tz::Asia__Krasnoyarsk),
  ("Asia/Kuala_Lumpur", Tz::Asia__Kuala_Lumpur),
  ("Asia/Kuching", Tz::Asia__Kuching),
  ("Asia/Kuwait", Tz::Asia__Kuwait),
  ("Asia/Macao", Tz::Asia__Macao),
  ("Asia/Macau", Tz::Asia__Macau),
  ("Asia/Magadan", Tz::Asia__Magadan),
  ("Asia/Makassar", Tz::Asia__Makassar),
  ("Asia/Manila", Tz::Asia__Manila),
  ("Asia/Muscat", Tz::Asia__Muscat),
  ("Asia/Nicosia", Tz::Asia__Nicosia),
  ("Asia/Novokuznetsk", Tz::Asia__Novokuznetsk),
  ("Asia/Novosibirsk", Tz::Asia__Novosibirsk),
  ("Asia/Omsk", Tz::Asia__Omsk),
  ("Asia/Oral", Tz::Asia__Oral),
  ("Asia/Phnom_Penh", Tz::Asia__Phnom_Penh),
  ("Asia/Pontianak", Tz::Asia__Pontianak),
  ("Asia/Pyongyang", Tz::Asia__Pyongyang),
  ("Asia/Qatar", Tz::Asia__Qatar),
  ("Asia/Qostanay", Tz::Asia__Qostanay),
  ("Asia/Qyzylorda", Tz::Asia__Qyzylorda),
  ("Asia/Rangoon", Tz::Asia__Rangoon),
  ("Asia/Riyadh", Tz::Asia__Riyadh),
  ("Asia/Saigon", Tz::Asia__Saigon),
  ("Asia/Sakhalin", Tz::Asia__Sakhalin),
  ("Asia/Samarkand", Tz::Asia__Samarkand),
  ("Asia/Seoul", Tz::Asia__Seoul),
  ("Asia/Shanghai", Tz::Asia__Shanghai),
  ("Asia/Singapore", Tz::Asia__Singapore),
  ("Asia/Srednekolymsk", Tz::Asia__Srednekolymsk),
  ("Asia/Taipei", Tz::Asia__Taipei),
  ("Asia/Tashkent", Tz::Asia__Tashkent),
  ("Asia/Tbilisi", Tz::Asia__Tbilisi),
  ("Asia/Tehran", Tz::Asia__Tehran),
  ("Asia/Tel_Aviv", Tz::Asia__Tel_Aviv),
  ("Asia/Thimbu", Tz::Asia__Thimbu),
  ("Asia/Thimphu", Tz::Asia__Thimphu),
  ("Asia/Tokyo", Tz::Asia__Tokyo),
  ("Asia/Tomsk", Tz::Asia__Tomsk),
  ("Asia/Ujung_Pandang", Tz::Asia__Ujung_Pandang),
  ("Asia/Ulaanbaatar", Tz::Asia__Ulaanbaatar),
  ("Asia/Ulan_Bator", Tz::Asia__Ulan_Bator),
  ("Asia/Urumqi", Tz::Asia__Urumqi),
  ("Asia/Ust-Nera", Tz::Asia__UstNera),
  ("Asia/Vientiane", Tz::Asia__Vientiane),
  ("Asia/Vladivostok", Tz::Asia__Vladivostok),
  ("Asia/Yakutsk", Tz::Asia__Yakutsk),
  ("Asia/Yangon", Tz::Asia__Yangon),
  ("Asia/Yekaterinburg", Tz::Asia__Yekaterinburg),
  ("Asia/Yerevan", Tz::Asia__Yerevan),
  ("Atlantic/Azores", Tz::Atlantic__Azores),
  ("Atlantic/Bermuda", Tz::Atlantic__Bermuda),
  ("Atlantic/Canary", Tz::Atlantic__Canary),
  ("Atlantic/Cape_Verde", Tz::Atlantic__Cape_Verde),
  ("Atlantic/Faeroe", Tz::Atlantic__Faeroe),
  ("Atlantic/Faroe", Tz::Atlantic__Faroe),
  ("Atlantic/Jan_Mayen", Tz::Atlantic__Jan_Mayen),
  ("Atlantic/Madeira", Tz::Atlantic__Madeira),
  ("Atlantic/Reykjavik", Tz::Atlantic__Reykjavik),
  ("Atlantic/South_Georgia", Tz::Atlantic__South_Georgia),
  ("Atlantic/St_Helena", Tz::Atlantic__St_Helena),
  ("Atlantic/Stanley", Tz::Atlantic__Stanley),
  ("Australia/ACT", Tz::Australia__ACT),
  ("Australia/Adelaide", Tz::Australia__Adelaide),
  ("Australia/Brisbane", Tz::Australia__Brisbane),
  ("Australia/Broken_Hill", Tz::Australia__Broken_Hill),
  ("Australia/Canberra", Tz::Australia__Canberra),
  ("Australia/Currie", Tz::Australia__Currie),
  ("Australia/Darwin", Tz::Australia__Darwin),
  ("Australia/Eucla", Tz::Australia__Eucla),
  ("Australia/Hobart", Tz::Australia__Hobart),
  ("Australia/LHI", Tz::Australia__LHI),
  ("Australia/Lindeman", Tz::Australia__Lindeman),
  ("Australia/Lord_Howe", Tz::Australia__Lord_Howe),
  ("Australia/Melbourne", Tz::Australia__Melbourne),
  ("Australia/NSW", Tz::Australia__NSW),
  ("Australia/North", Tz::Australia__North),
  ("Australia/Perth", Tz::Australia__Perth),
  ("Australia/Queensland", Tz::Australia__Queensland),
  ("Australia/South", Tz::Australia__South),
  ("Australia/Sydney", Tz::Australia__Sydney),
  ("Australia/Tasmania", Tz::Australia__Tasmania),
  ("Australia/Victoria", Tz::Australia__Victoria),
  ("Australia/West", Tz::Australia__West),
  ("Australia/Yancowinna", Tz::Australia__Yancowinna),
  ("Brazil/Acre", Tz::Brazil__Acre),
  ("Brazil/DeNoronha", Tz::Brazil__DeNoronha),
  ("Brazil/East", Tz::Brazil__East),
  ("Brazil/West", Tz::Brazil__West),
  ("CET", Tz::CET),
  ("CST6CDT", Tz::CST6CDT),
  ("Canada/Atlantic", Tz::Canada__Atlantic),
  ("Canada/Central", Tz::Canada__Central),
  ("Canada/Eastern", Tz::Canada__Eastern),
  ("Canada/Mountain", Tz::Canada__Mountain),
  ("Canada/Newfoundland", Tz::Canada__Newfoundland),
  ("Canada/Pacific", Tz::Canada__Pacific),
  ("Canada/Saskatchewan", Tz::Canada__Saskatchewan),
  ("Canada/Yukon", Tz::Canada__Yukon),
  ("Chile/Continental", Tz::Chile__Continental),
  ("Chile/EasterIsland", Tz::Chile__EasterIsland),
  ("Cuba", Tz::Cuba),
  ("EET", Tz::EET),
  ("EST", Tz::EST),
  ("EST5EDT", Tz::EST5EDT),
  ("Egypt", Tz::Egypt),
  ("Eire", Tz::Eire),
  ("Etc/GMT", Tz::Etc__GMT),
  ("Etc/GMT+0", Tz::Etc__GMTPlus0),
  ("Etc/GMT+1", Tz::Etc__GMTPlus1),
  ("Etc/GMT+10", Tz::Etc__GMTPlus10),
  ("Etc/GMT+11", Tz::Etc__GMTPlus11),
  ("Etc/GMT+12", Tz::Etc__GMTPlus12),
  ("Etc/GMT+2", Tz::Etc__GMTPlus2),
  ("Etc/GMT+3", Tz::Etc__GMTPlus3),
  ("Etc/GMT+4", Tz::Etc__GMTPlus4),
  ("Etc/GMT+5", Tz::Etc__GMTPlus5),
  ("Etc/GMT+6", Tz::Etc__GMTPlus6),
  ("Etc/GMT+7", Tz::Etc__GMTPlus7),
  ("Etc/GMT+8", Tz::Etc__GMTPlus8),
  ("Etc/GMT+9", Tz::Etc__GMTPlus9),
  ("Etc/GMT-0", Tz::Etc__GMTMinus0),
  ("Etc/GMT-1", Tz::Etc__GMTMinus1),
  ("Etc/GMT-10", Tz::Etc__GMTMinus10),
  ("Etc/GMT-11", Tz::Etc__GMTMinus11),
  ("Etc/GMT-12", Tz::Etc__GMTMinus12),
  ("Etc/GMT-13", Tz::Etc__GMTMinus13),
  ("Etc/GMT-14", Tz::Etc__GMTMinus14),
  ("Etc/GMT-2", Tz::Etc__GMTMinus2),
  ("Etc/GMT-3", Tz::Etc__GMTMinus3),
  ("Etc/GMT-4", Tz::Etc__GMTMinus4),
  ("Etc/GMT-5", Tz::Etc__GMTMinus5),
  ("Etc/GMT-6", Tz::Etc__GMTMinus6),
  ("Etc/GMT-7", Tz::Etc__GMTMinus7),
  ("Etc/GMT-8", Tz::Etc__GMTMinus8),
  ("Etc/GMT-9", Tz::Etc__GMTMinus9),
  ("Etc/GMT0", Tz::Etc__GMT0),
  ("Etc/Greenwich", Tz::Etc__Greenwich),
  ("Etc/UCT", Tz::Etc__UCT),
  ("Etc/UTC", Tz::Etc__UTC),
  ("Etc/Universal", Tz::Etc__Universal),
  ("Etc/Zulu", Tz::Etc__Zulu),
  ("Europe/Amsterdam", Tz::Europe__Amsterdam),
  ("Europe/Andorra", Tz::Europe__Andorra),
  ("Europe/Astrakhan", Tz::Europe__Astrakhan),
  ("Europe/Athens", Tz::Europe__Athens),
  ("Europe/Belfast", Tz::Europe__Belfast),
  ("Europe/Belgrade", Tz::Europe__Belgrade),
  ("Europe/Berlin", Tz::Europe__Berlin),
  ("Europe/Bratislava", Tz::Europe__Bratislava),
  ("Europe/Brussels", Tz::Europe__Brussels),
  ("Europe/Bucharest", Tz::Europe__Bucharest),
  ("Europe/Budapest", Tz::Europe__Budapest),
  ("Europe/Busingen", Tz::Europe__Busingen),
  ("Europe/Chisinau", Tz::Europe__Chisinau),
  ("Europe/Copenhagen", Tz::Europe__Copenhagen),
  ("Europe/Dublin", Tz::Europe__Dublin),
  ("Europe/Gibraltar", Tz::Europe__Gibraltar),
  ("Europe/Guernsey", Tz::Europe__Guernsey),
  ("Europe/Helsinki", Tz::Europe__Helsinki),
  ("Europe/Isle_of_Man", Tz::Europe__Isle_of_Man),
  ("Europe/Istanbul", Tz::Europe__Istanbul),
  ("Europe/Jersey", Tz::Europe__Jersey),
  ("Europe/Kaliningrad", Tz::Europe__Kaliningrad),
  ("Europe/Kiev", Tz::Europe__Kiev),
  ("Europe/Kirov", Tz::Europe__Kirov),
  ("Europe/Kyiv", Tz::Europe__Kyiv),
  ("Europe/Lisbon", Tz::Europe__Lisbon),
  ("Europe/Ljubljana", Tz::Europe__Ljubljana),
  ("Europe/London", Tz::Europe__London),
  ("Europe/Luxembourg", Tz::Europe__Luxembourg),
  ("Europe/Madrid", Tz::Europe__Madrid),
  ("Europe/Malta", Tz::Europe__Malta),
  ("Europe/Mariehamn", Tz::Europe__Mariehamn),
  ("Europe/Minsk", Tz::Europe__Minsk),
  ("Europe/Monaco", Tz::Europe__Monaco),
  ("Europe/Moscow", Tz::Europe__Moscow),
  ("Europe/Nicosia", Tz::Europe__Nicosia),
  ("Europe/Oslo", Tz::Europe__Oslo),
  ("Europe/Paris", Tz::Europe__Paris),
  ("Europe/Podgorica", Tz::Europe__Podgorica),
  ("Europe/Prague", Tz::Europe__Prague),
  ("Europe/Riga", Tz::Europe__Riga),
  ("Europe/Rome", Tz::Europe__Rome),
  ("Europe/Samara", Tz::Europe__Samara),
  ("Europe/San_Marino", Tz::Europe__San_Marino),
  ("Europe/Sarajevo", Tz::Europe__Sarajevo),
  ("Europe/Saratov", Tz::Europe__Saratov),
  ("Europe/Simferopol", Tz::Europe__Simferopol),
  ("Europe/Skopje", Tz::Europe__Skopje),
  ("Europe/Sofia", Tz::Europe__Sofia),
  ("Europe/Stockholm", Tz::Europe__Stockholm),
  ("Europe/Tallinn", Tz::Europe__Tallinn),
  ("Europe/Tirane", Tz::Europe__Tirane),
  ("Europe/Tiraspol", Tz::Europe__Tiraspol),
  ("Europe/Ulyanovsk", Tz::Europe__Ulyanovsk),
  ("Europe/Uzhgorod", Tz::Europe__Uzhgorod),
  ("Europe/Vaduz", Tz::Europe__Vaduz),
  ("Europe/Vatican", Tz::Europe__Vatican),
  ("Europe/Vienna", Tz::Europe__Vienna),
  ("Europe/Vilnius", Tz::Europe__Vilnius),
  ("Europe/Volgograd", Tz::Europe__Volgograd),
  ("Europe/Warsaw", Tz::Europe__Warsaw),
  ("Europe/Zagreb", Tz::Europe__Zagreb),
  ("Europe/Zaporozhye", Tz::Europe__Zaporozhye),
  ("Europe/Zurich", Tz::Europe__Zurich),
  ("GB", Tz::GB),
  ("GB-Eire", Tz::GBEire),
  ("GMT", Tz::GMT),
  ("GMT+0", Tz::GMTPlus0),
  ("GMT-0", Tz::GMTMinus0),
  ("GMT0", Tz::GMT0),
  ("Greenwich", Tz::Greenwich),
  ("HST", Tz::HST),
  ("Hongkong", Tz::Hongkong),
  ("Iceland", Tz::Iceland),
  ("Indian/Antananarivo", Tz::Indian__Antananarivo),
  ("Indian/Chagos", Tz::Indian__Chagos),
  ("Indian/Christmas", Tz::Indian__Christmas),
  ("Indian/Cocos", Tz::Indian__Cocos),
  ("Indian/Comoro", Tz::Indian__Comoro),
  ("Indian/Kerguelen", Tz::Indian__Kerguelen),
  ("Indian/Mahe", Tz::Indian__Mahe),
  ("Indian/Maldives", Tz::Indian__Maldives),
  ("Indian/Mauritius", Tz::Indian__Mauritius),
  ("Indian/Mayotte", Tz::Indian__Mayotte),
  ("Indian/Reunion", Tz::Indian__Reunion),
  ("Iran", Tz::Iran),
  ("Israel", Tz::Israel),
  ("Jamaica", Tz::Jamaica),
  ("Japan", Tz::Japan),
  ("Kwajalein", Tz::Kwajalein),
  ("Libya", Tz::Libya),
  ("MET", Tz::MET),
  ("MST", Tz::MST),
  ("MST7MDT", Tz::MST7MDT),
  ("Mexico/BajaNorte", Tz::Mexico__BajaNorte),
  ("Mexico/BajaSur", Tz::Mexico__BajaSur),
  ("Mexico/General", Tz::Mexico__General),
  ("NZ", Tz::NZ),
  ("NZ-CHAT", Tz::NZCHAT),
  ("Navajo", Tz::Navajo),
  ("PRC", Tz::PRC),
  ("PST8PDT", Tz::PST8PDT),
  ("Pacific/Apia", Tz::Pacific__Apia),
  ("Pacific/Auckland", Tz::Pacific__Auckland),
  ("Pacific/Bougainville", Tz::Pacific__Bougainville),
  ("Pacific/Chatham", Tz::Pacific__Chatham),
  ("Pacific/Chuuk", Tz::Pacific__Chuuk),
  ("Pacific/Easter", Tz::Pacific__Easter),
  ("Pacific/Efate", Tz::Pacific__Efate),
  ("Pacific/Enderbury", Tz::Pacific__Enderbury),
  ("Pacific/Fakaofo", Tz::Pacific__Fakaofo),
  ("Pacific/Fiji", Tz::Pacific__Fiji),
  ("Pacific/Funafuti", Tz::Pacific__Funafuti),
  ("Pacific/Galapagos", Tz::Pacific__Galapagos),
  ("Pacific/Gambier", Tz::Pacific__Gambier),
  ("Pacific/Guadalcanal", Tz::Pacific__Guadalcanal),
  ("Pacific/Guam", Tz::Pacific__Guam),
  ("Pacific/Honolulu", Tz::Pacific__Honolulu),
  ("Pacific/Johnston", Tz::Pacific__Johnston),
  ("Pacific/Kanton", Tz::Pacific__Kanton),
  ("Pacific/Kiritimati", Tz::Pacific__Kiritimati),
  ("Pacific/Kosrae", Tz::Pacific__Kosrae),
  ("Pacific/Kwajalein", Tz::Pacific__Kwajalein),
  ("Pacific/Majuro", Tz::Pacific__Majuro),
  ("Pacific/Marquesas", Tz::Pacific__Marquesas),
  ("Pacific/Midway", Tz::Pacific__Midway),
  ("Pacific/Nauru", Tz::Pacific__Nauru),
  ("Pacific/Niue", Tz::Pacific__Niue),
  ("Pacific/Norfolk", Tz::Pacific__Norfolk),
  ("Pacific/Noumea", Tz::Pacific__Noumea),
  ("Pacific/Pago_Pago", Tz::Pacific__Pago_Pago),
  ("Pacific/Palau", Tz::Pacific__Palau),
  ("Pacific/Pitcairn", Tz::Pacific__Pitcairn),
  ("Pacific/Pohnpei", Tz::Pacific__Pohnpei),
  ("Pacific/Ponape", Tz::Pacific__Ponape),
  ("Pacific/Port_Moresby", Tz::Pacific__Port_Moresby),
  ("Pacific/Rarotonga", Tz::Pacific__Rarotonga),
  ("Pacific/Saipan", Tz::Pacific__Saipan),
  ("Pacific/Samoa", Tz::Pacific__Samoa),
  ("Pacific/Tahiti", Tz::Pacific__Tahiti),
  ("Pacific/Tarawa", Tz::Pacific__Tarawa),
  ("Pacific/Tongatapu", Tz::Pacific__Tongatapu),
  ("Pacific/Truk", Tz::Pacific__Truk),
  ("Pacific/Wake", Tz::Pacific__Wake),
  ("Pacific/Wallis", Tz::Pacific__Wallis),
  ("Pacific/Yap", Tz::Pacific__Yap),
  ("Poland", Tz::Poland),
  ("Portugal", Tz::Portugal),
  ("ROC", Tz::ROC),
  ("ROK", Tz::ROK),
  ("Singapore", Tz::Singapore),
  ("Turkey", Tz::Turkey),
  ("UCT", Tz::UCT),
  ("US/Alaska", Tz::US__Alaska),
  ("US/Aleutian", Tz::US__Aleutian),
  ("US/Arizona", Tz::US__Arizona),
  ("US/Central", Tz::US__Central),
  ("US/East-Indiana", Tz::US__EastIndiana),
  ("US/Eastern", Tz::US__Eastern),
  ("US/Hawaii", Tz::US__Hawaii),
  ("US/Indiana-Starke", Tz::US__IndianaStarke),
  ("US/Michigan", Tz::US__Michigan),
  ("US/Mountain", Tz::US__Mountain),
  ("US/Pacific", Tz::US__Pacific),
  ("US/Samoa", Tz::US__Samoa),
  ("UTC", Tz::UTC),
  ("Universal", Tz::Universal),
  ("W-SU", Tz::WSU),
  ("WET", Tz::WET),
  ("Zulu", Tz::Zulu),
]

///|
/// 字典序（字节序）字符串比较：a < b 返回 true。
/// MoonBit 内置 String 的 `<` 是长度优先比较，不适用于按字典序排列的表。
fn str_dict_lt(a : String, b : String) -> Bool {
  let la = a.length()
  let lb = b.length()
  let min_len = if la < lb { la } else { lb }
  for i in 0..<min_len {
    if a[i] < b[i] {
      return true
    }
    if a[i] > b[i] {
      return false
    }
  }
  la < lb
}

///|
/// 解析 IANA 时区 ID 为 Tz variant（二分查找，未找到返回 None）。
///
/// 在按 IANA ID 升序排列的 name_to_tz 表上二分查找，O(log n)。
pub fn Tz::from_str(s : String) -> Tz? {
  let mut lo = 0
  let mut hi = name_to_tz.length()
  while lo < hi {
    let mid = lo + (hi - lo) / 2
    let key = name_to_tz[mid].0
    if s == key {
      return Some(name_to_tz[mid].1)
    }
    if str_dict_lt(s, key) {
      hi = mid
    } else {
      lo = mid + 1
    }
  }
  None
}

///|
/// 返回全部 597 个时区，按 IANA ID 升序排列。
pub fn Tz::all() -> Array[Tz] {
  let result = Array::make(name_to_tz.length(), Tz::UTC)
  for i in 0..<name_to_tz.length() {
    result[i] = name_to_tz[i].1
  }
  result
}

///|
/// 返回全部 597 个时区的 IANA ID，按升序排列。
pub fn Tz::all_names() -> Array[String] {
  let result = Array::make(name_to_tz.length(), "")
  for i in 0..<name_to_tz.length() {
    result[i] = name_to_tz[i].0
  }
  result
}
