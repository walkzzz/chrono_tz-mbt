///|
/// tz_impl.mbt — Tz 的 TimeZone 实现（timespans 自动生成，勿手改）
/// 移植自仓颉 src/base/tz/tz_impl.cj + moon-chrono_tz/tz/tz_impl.mbt。

///|
/// 返回本时区的预计算过渡表（Tz variant → FixedTimespanSet 映射）。
pub fn Tz::timespans(self : Tz) -> @core.FixedTimespanSet {
  match self {
    Tz::Africa__Abidjan => @data.africa__abidjan
    Tz::Africa__Accra => @data.africa__abidjan
    Tz::Africa__Addis_Ababa => @data.africa__nairobi
    Tz::Africa__Algiers => @data.africa__algiers
    Tz::Africa__Asmara => @data.africa__nairobi
    Tz::Africa__Asmera => @data.africa__nairobi
    Tz::Africa__Bamako => @data.africa__abidjan
    Tz::Africa__Bangui => @data.africa__lagos
    Tz::Africa__Banjul => @data.africa__abidjan
    Tz::Africa__Bissau => @data.africa__bissau
    Tz::Africa__Blantyre => @data.africa__maputo
    Tz::Africa__Brazzaville => @data.africa__lagos
    Tz::Africa__Bujumbura => @data.africa__maputo
    Tz::Africa__Cairo => @data.africa__cairo
    Tz::Africa__Casablanca => @data.africa__casablanca
    Tz::Africa__Ceuta => @data.africa__ceuta
    Tz::Africa__Conakry => @data.africa__abidjan
    Tz::Africa__Dakar => @data.africa__abidjan
    Tz::Africa__Dar_es_Salaam => @data.africa__nairobi
    Tz::Africa__Djibouti => @data.africa__nairobi
    Tz::Africa__Douala => @data.africa__lagos
    Tz::Africa__El_Aaiun => @data.africa__el_aaiun
    Tz::Africa__Freetown => @data.africa__abidjan
    Tz::Africa__Gaborone => @data.africa__maputo
    Tz::Africa__Harare => @data.africa__maputo
    Tz::Africa__Johannesburg => @data.africa__johannesburg
    Tz::Africa__Juba => @data.africa__juba
    Tz::Africa__Kampala => @data.africa__nairobi
    Tz::Africa__Khartoum => @data.africa__khartoum
    Tz::Africa__Kigali => @data.africa__maputo
    Tz::Africa__Kinshasa => @data.africa__lagos
    Tz::Africa__Lagos => @data.africa__lagos
    Tz::Africa__Libreville => @data.africa__lagos
    Tz::Africa__Lome => @data.africa__abidjan
    Tz::Africa__Luanda => @data.africa__lagos
    Tz::Africa__Lubumbashi => @data.africa__maputo
    Tz::Africa__Lusaka => @data.africa__maputo
    Tz::Africa__Malabo => @data.africa__lagos
    Tz::Africa__Maputo => @data.africa__maputo
    Tz::Africa__Maseru => @data.africa__johannesburg
    Tz::Africa__Mbabane => @data.africa__johannesburg
    Tz::Africa__Mogadishu => @data.africa__nairobi
    Tz::Africa__Monrovia => @data.africa__monrovia
    Tz::Africa__Nairobi => @data.africa__nairobi
    Tz::Africa__Ndjamena => @data.africa__ndjamena
    Tz::Africa__Niamey => @data.africa__lagos
    Tz::Africa__Nouakchott => @data.africa__abidjan
    Tz::Africa__Ouagadougou => @data.africa__abidjan
    Tz::Africa__PortoNovo => @data.africa__lagos
    Tz::Africa__Sao_Tome => @data.africa__sao_tome
    Tz::Africa__Timbuktu => @data.africa__abidjan
    Tz::Africa__Tripoli => @data.africa__tripoli
    Tz::Africa__Tunis => @data.africa__tunis
    Tz::Africa__Windhoek => @data.africa__windhoek
    Tz::America__Adak => @data.america__adak
    Tz::America__Anchorage => @data.america__anchorage
    Tz::America__Anguilla => @data.america__puerto_rico
    Tz::America__Antigua => @data.america__puerto_rico
    Tz::America__Araguaina => @data.america__araguaina
    Tz::America__Argentina__Buenos_Aires =>
      @data.america__argentina__buenos_aires
    Tz::America__Argentina__Catamarca => @data.america__argentina__catamarca
    Tz::America__Argentina__ComodRivadavia =>
      @data.america__argentina__catamarca
    Tz::America__Argentina__Cordoba => @data.america__argentina__cordoba
    Tz::America__Argentina__Jujuy => @data.america__argentina__jujuy
    Tz::America__Argentina__La_Rioja => @data.america__argentina__la_rioja
    Tz::America__Argentina__Mendoza => @data.america__argentina__mendoza
    Tz::America__Argentina__Rio_Gallegos =>
      @data.america__argentina__rio_gallegos
    Tz::America__Argentina__Salta => @data.america__argentina__salta
    Tz::America__Argentina__San_Juan => @data.america__argentina__san_juan
    Tz::America__Argentina__San_Luis => @data.america__argentina__san_luis
    Tz::America__Argentina__Tucuman => @data.america__argentina__tucuman
    Tz::America__Argentina__Ushuaia => @data.america__argentina__ushuaia
    Tz::America__Aruba => @data.america__puerto_rico
    Tz::America__Asuncion => @data.america__asuncion
    Tz::America__Atikokan => @data.america__panama
    Tz::America__Atka => @data.america__adak
    Tz::America__Bahia => @data.america__bahia
    Tz::America__Bahia_Banderas => @data.america__bahia_banderas
    Tz::America__Barbados => @data.america__barbados
    Tz::America__Belem => @data.america__belem
    Tz::America__Belize => @data.america__belize
    Tz::America__BlancSablon => @data.america__puerto_rico
    Tz::America__Boa_Vista => @data.america__boa_vista
    Tz::America__Bogota => @data.america__bogota
    Tz::America__Boise => @data.america__boise
    Tz::America__Buenos_Aires => @data.america__argentina__buenos_aires
    Tz::America__Cambridge_Bay => @data.america__cambridge_bay
    Tz::America__Campo_Grande => @data.america__campo_grande
    Tz::America__Cancun => @data.america__cancun
    Tz::America__Caracas => @data.america__caracas
    Tz::America__Catamarca => @data.america__argentina__catamarca
    Tz::America__Cayenne => @data.america__cayenne
    Tz::America__Cayman => @data.america__panama
    Tz::America__Chicago => @data.america__chicago
    Tz::America__Chihuahua => @data.america__chihuahua
    Tz::America__Ciudad_Juarez => @data.america__ciudad_juarez
    Tz::America__Coral_Harbour => @data.america__panama
    Tz::America__Cordoba => @data.america__argentina__cordoba
    Tz::America__Costa_Rica => @data.america__costa_rica
    Tz::America__Coyhaique => @data.america__coyhaique
    Tz::America__Creston => @data.america__phoenix
    Tz::America__Cuiaba => @data.america__cuiaba
    Tz::America__Curacao => @data.america__puerto_rico
    Tz::America__Danmarkshavn => @data.america__danmarkshavn
    Tz::America__Dawson => @data.america__dawson
    Tz::America__Dawson_Creek => @data.america__dawson_creek
    Tz::America__Denver => @data.america__denver
    Tz::America__Detroit => @data.america__detroit
    Tz::America__Dominica => @data.america__puerto_rico
    Tz::America__Edmonton => @data.america__edmonton
    Tz::America__Eirunepe => @data.america__eirunepe
    Tz::America__El_Salvador => @data.america__el_salvador
    Tz::America__Ensenada => @data.america__tijuana
    Tz::America__Fort_Nelson => @data.america__fort_nelson
    Tz::America__Fort_Wayne => @data.america__indiana__indianapolis
    Tz::America__Fortaleza => @data.america__fortaleza
    Tz::America__Glace_Bay => @data.america__glace_bay
    Tz::America__Godthab => @data.america__nuuk
    Tz::America__Goose_Bay => @data.america__goose_bay
    Tz::America__Grand_Turk => @data.america__grand_turk
    Tz::America__Grenada => @data.america__puerto_rico
    Tz::America__Guadeloupe => @data.america__puerto_rico
    Tz::America__Guatemala => @data.america__guatemala
    Tz::America__Guayaquil => @data.america__guayaquil
    Tz::America__Guyana => @data.america__guyana
    Tz::America__Halifax => @data.america__halifax
    Tz::America__Havana => @data.america__havana
    Tz::America__Hermosillo => @data.america__hermosillo
    Tz::America__Indiana__Indianapolis => @data.america__indiana__indianapolis
    Tz::America__Indiana__Knox => @data.america__indiana__knox
    Tz::America__Indiana__Marengo => @data.america__indiana__marengo
    Tz::America__Indiana__Petersburg => @data.america__indiana__petersburg
    Tz::America__Indiana__Tell_City => @data.america__indiana__tell_city
    Tz::America__Indiana__Vevay => @data.america__indiana__vevay
    Tz::America__Indiana__Vincennes => @data.america__indiana__vincennes
    Tz::America__Indiana__Winamac => @data.america__indiana__winamac
    Tz::America__Indianapolis => @data.america__indiana__indianapolis
    Tz::America__Inuvik => @data.america__inuvik
    Tz::America__Iqaluit => @data.america__iqaluit
    Tz::America__Jamaica => @data.america__jamaica
    Tz::America__Jujuy => @data.america__argentina__jujuy
    Tz::America__Juneau => @data.america__juneau
    Tz::America__Kentucky__Louisville => @data.america__kentucky__louisville
    Tz::America__Kentucky__Monticello => @data.america__kentucky__monticello
    Tz::America__Knox_IN => @data.america__indiana__knox
    Tz::America__Kralendijk => @data.america__puerto_rico
    Tz::America__La_Paz => @data.america__la_paz
    Tz::America__Lima => @data.america__lima
    Tz::America__Los_Angeles => @data.america__los_angeles
    Tz::America__Louisville => @data.america__kentucky__louisville
    Tz::America__Lower_Princes => @data.america__puerto_rico
    Tz::America__Maceio => @data.america__maceio
    Tz::America__Managua => @data.america__managua
    Tz::America__Manaus => @data.america__manaus
    Tz::America__Marigot => @data.america__puerto_rico
    Tz::America__Martinique => @data.america__martinique
    Tz::America__Matamoros => @data.america__matamoros
    Tz::America__Mazatlan => @data.america__mazatlan
    Tz::America__Mendoza => @data.america__argentina__mendoza
    Tz::America__Menominee => @data.america__menominee
    Tz::America__Merida => @data.america__merida
    Tz::America__Metlakatla => @data.america__metlakatla
    Tz::America__Mexico_City => @data.america__mexico_city
    Tz::America__Miquelon => @data.america__miquelon
    Tz::America__Moncton => @data.america__moncton
    Tz::America__Monterrey => @data.america__monterrey
    Tz::America__Montevideo => @data.america__montevideo
    Tz::America__Montreal => @data.america__toronto
    Tz::America__Montserrat => @data.america__puerto_rico
    Tz::America__Nassau => @data.america__toronto
    Tz::America__New_York => @data.america__new_york
    Tz::America__Nipigon => @data.america__toronto
    Tz::America__Nome => @data.america__nome
    Tz::America__Noronha => @data.america__noronha
    Tz::America__North_Dakota__Beulah => @data.america__north_dakota__beulah
    Tz::America__North_Dakota__Center => @data.america__north_dakota__center
    Tz::America__North_Dakota__New_Salem =>
      @data.america__north_dakota__new_salem
    Tz::America__Nuuk => @data.america__nuuk
    Tz::America__Ojinaga => @data.america__ojinaga
    Tz::America__Panama => @data.america__panama
    Tz::America__Pangnirtung => @data.america__iqaluit
    Tz::America__Paramaribo => @data.america__paramaribo
    Tz::America__Phoenix => @data.america__phoenix
    Tz::America__PortauPrince => @data.america__portauprince
    Tz::America__Port_of_Spain => @data.america__puerto_rico
    Tz::America__Porto_Acre => @data.america__rio_branco
    Tz::America__Porto_Velho => @data.america__porto_velho
    Tz::America__Puerto_Rico => @data.america__puerto_rico
    Tz::America__Punta_Arenas => @data.america__punta_arenas
    Tz::America__Rainy_River => @data.america__winnipeg
    Tz::America__Rankin_Inlet => @data.america__rankin_inlet
    Tz::America__Recife => @data.america__recife
    Tz::America__Regina => @data.america__regina
    Tz::America__Resolute => @data.america__resolute
    Tz::America__Rio_Branco => @data.america__rio_branco
    Tz::America__Rosario => @data.america__argentina__cordoba
    Tz::America__Santa_Isabel => @data.america__tijuana
    Tz::America__Santarem => @data.america__santarem
    Tz::America__Santiago => @data.america__santiago
    Tz::America__Santo_Domingo => @data.america__santo_domingo
    Tz::America__Sao_Paulo => @data.america__sao_paulo
    Tz::America__Scoresbysund => @data.america__scoresbysund
    Tz::America__Shiprock => @data.america__denver
    Tz::America__Sitka => @data.america__sitka
    Tz::America__St_Barthelemy => @data.america__puerto_rico
    Tz::America__St_Johns => @data.america__st_johns
    Tz::America__St_Kitts => @data.america__puerto_rico
    Tz::America__St_Lucia => @data.america__puerto_rico
    Tz::America__St_Thomas => @data.america__puerto_rico
    Tz::America__St_Vincent => @data.america__puerto_rico
    Tz::America__Swift_Current => @data.america__swift_current
    Tz::America__Tegucigalpa => @data.america__tegucigalpa
    Tz::America__Thule => @data.america__thule
    Tz::America__Thunder_Bay => @data.america__toronto
    Tz::America__Tijuana => @data.america__tijuana
    Tz::America__Toronto => @data.america__toronto
    Tz::America__Tortola => @data.america__puerto_rico
    Tz::America__Vancouver => @data.america__vancouver
    Tz::America__Virgin => @data.america__puerto_rico
    Tz::America__Whitehorse => @data.america__whitehorse
    Tz::America__Winnipeg => @data.america__winnipeg
    Tz::America__Yakutat => @data.america__yakutat
    Tz::America__Yellowknife => @data.america__edmonton
    Tz::Antarctica__Casey => @data.antarctica__casey
    Tz::Antarctica__Davis => @data.antarctica__davis
    Tz::Antarctica__DumontDUrville => @data.pacific__port_moresby
    Tz::Antarctica__Macquarie => @data.antarctica__macquarie
    Tz::Antarctica__Mawson => @data.antarctica__mawson
    Tz::Antarctica__McMurdo => @data.pacific__auckland
    Tz::Antarctica__Palmer => @data.antarctica__palmer
    Tz::Antarctica__Rothera => @data.antarctica__rothera
    Tz::Antarctica__South_Pole => @data.pacific__auckland
    Tz::Antarctica__Syowa => @data.asia__riyadh
    Tz::Antarctica__Troll => @data.antarctica__troll
    Tz::Antarctica__Vostok => @data.antarctica__vostok
    Tz::Arctic__Longyearbyen => @data.europe__berlin
    Tz::Asia__Aden => @data.asia__riyadh
    Tz::Asia__Almaty => @data.asia__almaty
    Tz::Asia__Amman => @data.asia__amman
    Tz::Asia__Anadyr => @data.asia__anadyr
    Tz::Asia__Aqtau => @data.asia__aqtau
    Tz::Asia__Aqtobe => @data.asia__aqtobe
    Tz::Asia__Ashgabat => @data.asia__ashgabat
    Tz::Asia__Ashkhabad => @data.asia__ashgabat
    Tz::Asia__Atyrau => @data.asia__atyrau
    Tz::Asia__Baghdad => @data.asia__baghdad
    Tz::Asia__Bahrain => @data.asia__qatar
    Tz::Asia__Baku => @data.asia__baku
    Tz::Asia__Bangkok => @data.asia__bangkok
    Tz::Asia__Barnaul => @data.asia__barnaul
    Tz::Asia__Beirut => @data.asia__beirut
    Tz::Asia__Bishkek => @data.asia__bishkek
    Tz::Asia__Brunei => @data.asia__kuching
    Tz::Asia__Calcutta => @data.asia__kolkata
    Tz::Asia__Chita => @data.asia__chita
    Tz::Asia__Choibalsan => @data.asia__ulaanbaatar
    Tz::Asia__Chongqing => @data.asia__shanghai
    Tz::Asia__Chungking => @data.asia__shanghai
    Tz::Asia__Colombo => @data.asia__colombo
    Tz::Asia__Dacca => @data.asia__dhaka
    Tz::Asia__Damascus => @data.asia__damascus
    Tz::Asia__Dhaka => @data.asia__dhaka
    Tz::Asia__Dili => @data.asia__dili
    Tz::Asia__Dubai => @data.asia__dubai
    Tz::Asia__Dushanbe => @data.asia__dushanbe
    Tz::Asia__Famagusta => @data.asia__famagusta
    Tz::Asia__Gaza => @data.asia__gaza
    Tz::Asia__Harbin => @data.asia__shanghai
    Tz::Asia__Hebron => @data.asia__hebron
    Tz::Asia__Ho_Chi_Minh => @data.asia__ho_chi_minh
    Tz::Asia__Hong_Kong => @data.asia__hong_kong
    Tz::Asia__Hovd => @data.asia__hovd
    Tz::Asia__Irkutsk => @data.asia__irkutsk
    Tz::Asia__Istanbul => @data.europe__istanbul
    Tz::Asia__Jakarta => @data.asia__jakarta
    Tz::Asia__Jayapura => @data.asia__jayapura
    Tz::Asia__Jerusalem => @data.asia__jerusalem
    Tz::Asia__Kabul => @data.asia__kabul
    Tz::Asia__Kamchatka => @data.asia__kamchatka
    Tz::Asia__Karachi => @data.asia__karachi
    Tz::Asia__Kashgar => @data.asia__urumqi
    Tz::Asia__Kathmandu => @data.asia__kathmandu
    Tz::Asia__Katmandu => @data.asia__kathmandu
    Tz::Asia__Khandyga => @data.asia__khandyga
    Tz::Asia__Kolkata => @data.asia__kolkata
    Tz::Asia__Krasnoyarsk => @data.asia__krasnoyarsk
    Tz::Asia__Kuala_Lumpur => @data.asia__singapore
    Tz::Asia__Kuching => @data.asia__kuching
    Tz::Asia__Kuwait => @data.asia__riyadh
    Tz::Asia__Macao => @data.asia__macau
    Tz::Asia__Macau => @data.asia__macau
    Tz::Asia__Magadan => @data.asia__magadan
    Tz::Asia__Makassar => @data.asia__makassar
    Tz::Asia__Manila => @data.asia__manila
    Tz::Asia__Muscat => @data.asia__dubai
    Tz::Asia__Nicosia => @data.asia__nicosia
    Tz::Asia__Novokuznetsk => @data.asia__novokuznetsk
    Tz::Asia__Novosibirsk => @data.asia__novosibirsk
    Tz::Asia__Omsk => @data.asia__omsk
    Tz::Asia__Oral => @data.asia__oral
    Tz::Asia__Phnom_Penh => @data.asia__bangkok
    Tz::Asia__Pontianak => @data.asia__pontianak
    Tz::Asia__Pyongyang => @data.asia__pyongyang
    Tz::Asia__Qatar => @data.asia__qatar
    Tz::Asia__Qostanay => @data.asia__qostanay
    Tz::Asia__Qyzylorda => @data.asia__qyzylorda
    Tz::Asia__Rangoon => @data.asia__yangon
    Tz::Asia__Riyadh => @data.asia__riyadh
    Tz::Asia__Saigon => @data.asia__ho_chi_minh
    Tz::Asia__Sakhalin => @data.asia__sakhalin
    Tz::Asia__Samarkand => @data.asia__samarkand
    Tz::Asia__Seoul => @data.asia__seoul
    Tz::Asia__Shanghai => @data.asia__shanghai
    Tz::Asia__Singapore => @data.asia__singapore
    Tz::Asia__Srednekolymsk => @data.asia__srednekolymsk
    Tz::Asia__Taipei => @data.asia__taipei
    Tz::Asia__Tashkent => @data.asia__tashkent
    Tz::Asia__Tbilisi => @data.asia__tbilisi
    Tz::Asia__Tehran => @data.asia__tehran
    Tz::Asia__Tel_Aviv => @data.asia__jerusalem
    Tz::Asia__Thimbu => @data.asia__thimphu
    Tz::Asia__Thimphu => @data.asia__thimphu
    Tz::Asia__Tokyo => @data.asia__tokyo
    Tz::Asia__Tomsk => @data.asia__tomsk
    Tz::Asia__Ujung_Pandang => @data.asia__makassar
    Tz::Asia__Ulaanbaatar => @data.asia__ulaanbaatar
    Tz::Asia__Ulan_Bator => @data.asia__ulaanbaatar
    Tz::Asia__Urumqi => @data.asia__urumqi
    Tz::Asia__UstNera => @data.asia__ustnera
    Tz::Asia__Vientiane => @data.asia__bangkok
    Tz::Asia__Vladivostok => @data.asia__vladivostok
    Tz::Asia__Yakutsk => @data.asia__yakutsk
    Tz::Asia__Yangon => @data.asia__yangon
    Tz::Asia__Yekaterinburg => @data.asia__yekaterinburg
    Tz::Asia__Yerevan => @data.asia__yerevan
    Tz::Atlantic__Azores => @data.atlantic__azores
    Tz::Atlantic__Bermuda => @data.atlantic__bermuda
    Tz::Atlantic__Canary => @data.atlantic__canary
    Tz::Atlantic__Cape_Verde => @data.atlantic__cape_verde
    Tz::Atlantic__Faeroe => @data.atlantic__faroe
    Tz::Atlantic__Faroe => @data.atlantic__faroe
    Tz::Atlantic__Jan_Mayen => @data.europe__berlin
    Tz::Atlantic__Madeira => @data.atlantic__madeira
    Tz::Atlantic__Reykjavik => @data.africa__abidjan
    Tz::Atlantic__South_Georgia => @data.atlantic__south_georgia
    Tz::Atlantic__St_Helena => @data.africa__abidjan
    Tz::Atlantic__Stanley => @data.atlantic__stanley
    Tz::Australia__ACT => @data.australia__sydney
    Tz::Australia__Adelaide => @data.australia__adelaide
    Tz::Australia__Brisbane => @data.australia__brisbane
    Tz::Australia__Broken_Hill => @data.australia__broken_hill
    Tz::Australia__Canberra => @data.australia__sydney
    Tz::Australia__Currie => @data.australia__hobart
    Tz::Australia__Darwin => @data.australia__darwin
    Tz::Australia__Eucla => @data.australia__eucla
    Tz::Australia__Hobart => @data.australia__hobart
    Tz::Australia__LHI => @data.australia__lord_howe
    Tz::Australia__Lindeman => @data.australia__lindeman
    Tz::Australia__Lord_Howe => @data.australia__lord_howe
    Tz::Australia__Melbourne => @data.australia__melbourne
    Tz::Australia__NSW => @data.australia__sydney
    Tz::Australia__North => @data.australia__darwin
    Tz::Australia__Perth => @data.australia__perth
    Tz::Australia__Queensland => @data.australia__brisbane
    Tz::Australia__South => @data.australia__adelaide
    Tz::Australia__Sydney => @data.australia__sydney
    Tz::Australia__Tasmania => @data.australia__hobart
    Tz::Australia__Victoria => @data.australia__melbourne
    Tz::Australia__West => @data.australia__perth
    Tz::Australia__Yancowinna => @data.australia__broken_hill
    Tz::Brazil__Acre => @data.america__rio_branco
    Tz::Brazil__DeNoronha => @data.america__noronha
    Tz::Brazil__East => @data.america__sao_paulo
    Tz::Brazil__West => @data.america__manaus
    Tz::CET => @data.europe__brussels
    Tz::CST6CDT => @data.america__chicago
    Tz::Canada__Atlantic => @data.america__halifax
    Tz::Canada__Central => @data.america__winnipeg
    Tz::Canada__Eastern => @data.america__toronto
    Tz::Canada__Mountain => @data.america__edmonton
    Tz::Canada__Newfoundland => @data.america__st_johns
    Tz::Canada__Pacific => @data.america__vancouver
    Tz::Canada__Saskatchewan => @data.america__regina
    Tz::Canada__Yukon => @data.america__whitehorse
    Tz::Chile__Continental => @data.america__santiago
    Tz::Chile__EasterIsland => @data.pacific__easter
    Tz::Cuba => @data.america__havana
    Tz::EET => @data.europe__athens
    Tz::EST => @data.america__panama
    Tz::EST5EDT => @data.america__new_york
    Tz::Egypt => @data.africa__cairo
    Tz::Eire => @data.europe__dublin
    Tz::Etc__GMT => @data.etc__gmt
    Tz::Etc__GMTPlus0 => @data.etc__gmt
    Tz::Etc__GMTPlus1 => @data.etc__gmtplus1
    Tz::Etc__GMTPlus10 => @data.etc__gmtplus10
    Tz::Etc__GMTPlus11 => @data.etc__gmtplus11
    Tz::Etc__GMTPlus12 => @data.etc__gmtplus12
    Tz::Etc__GMTPlus2 => @data.etc__gmtplus2
    Tz::Etc__GMTPlus3 => @data.etc__gmtplus3
    Tz::Etc__GMTPlus4 => @data.etc__gmtplus4
    Tz::Etc__GMTPlus5 => @data.etc__gmtplus5
    Tz::Etc__GMTPlus6 => @data.etc__gmtplus6
    Tz::Etc__GMTPlus7 => @data.etc__gmtplus7
    Tz::Etc__GMTPlus8 => @data.etc__gmtplus8
    Tz::Etc__GMTPlus9 => @data.etc__gmtplus9
    Tz::Etc__GMTMinus0 => @data.etc__gmt
    Tz::Etc__GMTMinus1 => @data.etc__gmtminus1
    Tz::Etc__GMTMinus10 => @data.etc__gmtminus10
    Tz::Etc__GMTMinus11 => @data.etc__gmtminus11
    Tz::Etc__GMTMinus12 => @data.etc__gmtminus12
    Tz::Etc__GMTMinus13 => @data.etc__gmtminus13
    Tz::Etc__GMTMinus14 => @data.etc__gmtminus14
    Tz::Etc__GMTMinus2 => @data.etc__gmtminus2
    Tz::Etc__GMTMinus3 => @data.etc__gmtminus3
    Tz::Etc__GMTMinus4 => @data.etc__gmtminus4
    Tz::Etc__GMTMinus5 => @data.etc__gmtminus5
    Tz::Etc__GMTMinus6 => @data.etc__gmtminus6
    Tz::Etc__GMTMinus7 => @data.etc__gmtminus7
    Tz::Etc__GMTMinus8 => @data.etc__gmtminus8
    Tz::Etc__GMTMinus9 => @data.etc__gmtminus9
    Tz::Etc__GMT0 => @data.etc__gmt
    Tz::Etc__Greenwich => @data.etc__gmt
    Tz::Etc__UCT => @data.etc__utc
    Tz::Etc__UTC => @data.etc__utc
    Tz::Etc__Universal => @data.etc__utc
    Tz::Etc__Zulu => @data.etc__utc
    Tz::Europe__Amsterdam => @data.europe__brussels
    Tz::Europe__Andorra => @data.europe__andorra
    Tz::Europe__Astrakhan => @data.europe__astrakhan
    Tz::Europe__Athens => @data.europe__athens
    Tz::Europe__Belfast => @data.europe__london
    Tz::Europe__Belgrade => @data.europe__belgrade
    Tz::Europe__Berlin => @data.europe__berlin
    Tz::Europe__Bratislava => @data.europe__prague
    Tz::Europe__Brussels => @data.europe__brussels
    Tz::Europe__Bucharest => @data.europe__bucharest
    Tz::Europe__Budapest => @data.europe__budapest
    Tz::Europe__Busingen => @data.europe__zurich
    Tz::Europe__Chisinau => @data.europe__chisinau
    Tz::Europe__Copenhagen => @data.europe__berlin
    Tz::Europe__Dublin => @data.europe__dublin
    Tz::Europe__Gibraltar => @data.europe__gibraltar
    Tz::Europe__Guernsey => @data.europe__london
    Tz::Europe__Helsinki => @data.europe__helsinki
    Tz::Europe__Isle_of_Man => @data.europe__london
    Tz::Europe__Istanbul => @data.europe__istanbul
    Tz::Europe__Jersey => @data.europe__london
    Tz::Europe__Kaliningrad => @data.europe__kaliningrad
    Tz::Europe__Kiev => @data.europe__kyiv
    Tz::Europe__Kirov => @data.europe__kirov
    Tz::Europe__Kyiv => @data.europe__kyiv
    Tz::Europe__Lisbon => @data.europe__lisbon
    Tz::Europe__Ljubljana => @data.europe__belgrade
    Tz::Europe__London => @data.europe__london
    Tz::Europe__Luxembourg => @data.europe__brussels
    Tz::Europe__Madrid => @data.europe__madrid
    Tz::Europe__Malta => @data.europe__malta
    Tz::Europe__Mariehamn => @data.europe__helsinki
    Tz::Europe__Minsk => @data.europe__minsk
    Tz::Europe__Monaco => @data.europe__paris
    Tz::Europe__Moscow => @data.europe__moscow
    Tz::Europe__Nicosia => @data.asia__nicosia
    Tz::Europe__Oslo => @data.europe__berlin
    Tz::Europe__Paris => @data.europe__paris
    Tz::Europe__Podgorica => @data.europe__belgrade
    Tz::Europe__Prague => @data.europe__prague
    Tz::Europe__Riga => @data.europe__riga
    Tz::Europe__Rome => @data.europe__rome
    Tz::Europe__Samara => @data.europe__samara
    Tz::Europe__San_Marino => @data.europe__rome
    Tz::Europe__Sarajevo => @data.europe__belgrade
    Tz::Europe__Saratov => @data.europe__saratov
    Tz::Europe__Simferopol => @data.europe__simferopol
    Tz::Europe__Skopje => @data.europe__belgrade
    Tz::Europe__Sofia => @data.europe__sofia
    Tz::Europe__Stockholm => @data.europe__berlin
    Tz::Europe__Tallinn => @data.europe__tallinn
    Tz::Europe__Tirane => @data.europe__tirane
    Tz::Europe__Tiraspol => @data.europe__chisinau
    Tz::Europe__Ulyanovsk => @data.europe__ulyanovsk
    Tz::Europe__Uzhgorod => @data.europe__kyiv
    Tz::Europe__Vaduz => @data.europe__zurich
    Tz::Europe__Vatican => @data.europe__rome
    Tz::Europe__Vienna => @data.europe__vienna
    Tz::Europe__Vilnius => @data.europe__vilnius
    Tz::Europe__Volgograd => @data.europe__volgograd
    Tz::Europe__Warsaw => @data.europe__warsaw
    Tz::Europe__Zagreb => @data.europe__belgrade
    Tz::Europe__Zaporozhye => @data.europe__kyiv
    Tz::Europe__Zurich => @data.europe__zurich
    Tz::GB => @data.europe__london
    Tz::GBEire => @data.europe__london
    Tz::GMT => @data.etc__gmt
    Tz::GMTPlus0 => @data.etc__gmt
    Tz::GMTMinus0 => @data.etc__gmt
    Tz::GMT0 => @data.etc__gmt
    Tz::Greenwich => @data.etc__gmt
    Tz::HST => @data.pacific__honolulu
    Tz::Hongkong => @data.asia__hong_kong
    Tz::Iceland => @data.africa__abidjan
    Tz::Indian__Antananarivo => @data.africa__nairobi
    Tz::Indian__Chagos => @data.indian__chagos
    Tz::Indian__Christmas => @data.asia__bangkok
    Tz::Indian__Cocos => @data.asia__yangon
    Tz::Indian__Comoro => @data.africa__nairobi
    Tz::Indian__Kerguelen => @data.indian__maldives
    Tz::Indian__Mahe => @data.asia__dubai
    Tz::Indian__Maldives => @data.indian__maldives
    Tz::Indian__Mauritius => @data.indian__mauritius
    Tz::Indian__Mayotte => @data.africa__nairobi
    Tz::Indian__Reunion => @data.asia__dubai
    Tz::Iran => @data.asia__tehran
    Tz::Israel => @data.asia__jerusalem
    Tz::Jamaica => @data.america__jamaica
    Tz::Japan => @data.asia__tokyo
    Tz::Kwajalein => @data.pacific__kwajalein
    Tz::Libya => @data.africa__tripoli
    Tz::MET => @data.europe__brussels
    Tz::MST => @data.america__phoenix
    Tz::MST7MDT => @data.america__denver
    Tz::Mexico__BajaNorte => @data.america__tijuana
    Tz::Mexico__BajaSur => @data.america__mazatlan
    Tz::Mexico__General => @data.america__mexico_city
    Tz::NZ => @data.pacific__auckland
    Tz::NZCHAT => @data.pacific__chatham
    Tz::Navajo => @data.america__denver
    Tz::PRC => @data.asia__shanghai
    Tz::PST8PDT => @data.america__los_angeles
    Tz::Pacific__Apia => @data.pacific__apia
    Tz::Pacific__Auckland => @data.pacific__auckland
    Tz::Pacific__Bougainville => @data.pacific__bougainville
    Tz::Pacific__Chatham => @data.pacific__chatham
    Tz::Pacific__Chuuk => @data.pacific__port_moresby
    Tz::Pacific__Easter => @data.pacific__easter
    Tz::Pacific__Efate => @data.pacific__efate
    Tz::Pacific__Enderbury => @data.pacific__kanton
    Tz::Pacific__Fakaofo => @data.pacific__fakaofo
    Tz::Pacific__Fiji => @data.pacific__fiji
    Tz::Pacific__Funafuti => @data.pacific__tarawa
    Tz::Pacific__Galapagos => @data.pacific__galapagos
    Tz::Pacific__Gambier => @data.pacific__gambier
    Tz::Pacific__Guadalcanal => @data.pacific__guadalcanal
    Tz::Pacific__Guam => @data.pacific__guam
    Tz::Pacific__Honolulu => @data.pacific__honolulu
    Tz::Pacific__Johnston => @data.pacific__honolulu
    Tz::Pacific__Kanton => @data.pacific__kanton
    Tz::Pacific__Kiritimati => @data.pacific__kiritimati
    Tz::Pacific__Kosrae => @data.pacific__kosrae
    Tz::Pacific__Kwajalein => @data.pacific__kwajalein
    Tz::Pacific__Majuro => @data.pacific__tarawa
    Tz::Pacific__Marquesas => @data.pacific__marquesas
    Tz::Pacific__Midway => @data.pacific__pago_pago
    Tz::Pacific__Nauru => @data.pacific__nauru
    Tz::Pacific__Niue => @data.pacific__niue
    Tz::Pacific__Norfolk => @data.pacific__norfolk
    Tz::Pacific__Noumea => @data.pacific__noumea
    Tz::Pacific__Pago_Pago => @data.pacific__pago_pago
    Tz::Pacific__Palau => @data.pacific__palau
    Tz::Pacific__Pitcairn => @data.pacific__pitcairn
    Tz::Pacific__Pohnpei => @data.pacific__guadalcanal
    Tz::Pacific__Ponape => @data.pacific__guadalcanal
    Tz::Pacific__Port_Moresby => @data.pacific__port_moresby
    Tz::Pacific__Rarotonga => @data.pacific__rarotonga
    Tz::Pacific__Saipan => @data.pacific__guam
    Tz::Pacific__Samoa => @data.pacific__pago_pago
    Tz::Pacific__Tahiti => @data.pacific__tahiti
    Tz::Pacific__Tarawa => @data.pacific__tarawa
    Tz::Pacific__Tongatapu => @data.pacific__tongatapu
    Tz::Pacific__Truk => @data.pacific__port_moresby
    Tz::Pacific__Wake => @data.pacific__tarawa
    Tz::Pacific__Wallis => @data.pacific__tarawa
    Tz::Pacific__Yap => @data.pacific__port_moresby
    Tz::Poland => @data.europe__warsaw
    Tz::Portugal => @data.europe__lisbon
    Tz::ROC => @data.asia__taipei
    Tz::ROK => @data.asia__seoul
    Tz::Singapore => @data.asia__singapore
    Tz::Turkey => @data.europe__istanbul
    Tz::UCT => @data.etc__utc
    Tz::US__Alaska => @data.america__anchorage
    Tz::US__Aleutian => @data.america__adak
    Tz::US__Arizona => @data.america__phoenix
    Tz::US__Central => @data.america__chicago
    Tz::US__EastIndiana => @data.america__indiana__indianapolis
    Tz::US__Eastern => @data.america__new_york
    Tz::US__Hawaii => @data.pacific__honolulu
    Tz::US__IndianaStarke => @data.america__indiana__knox
    Tz::US__Michigan => @data.america__detroit
    Tz::US__Mountain => @data.america__denver
    Tz::US__Pacific => @data.america__los_angeles
    Tz::US__Samoa => @data.pacific__pago_pago
    Tz::UTC => @data.etc__utc
    Tz::Universal => @data.etc__utc
    Tz::WSU => @data.europe__moscow
    Tz::WET => @data.europe__lisbon
    Tz::Zulu => @data.etc__utc
  }
}

///|
/// 给定 UTC 瞬时，返回其在本时区的偏移（无歧义）。
/// 用 binary_search + utc_span(n).cmp(ts)，Ok/Err 均取 idx（UTC 区间无缺口）。
pub fn Tz::offset_from_utc_date_time(self : Tz, dt : NaiveDateTime) -> TzOffset {
  let ts = dt.timestamp()
  let span = self.timespans()
  let i = binary_search(0, span.len(), fn(n) { span.utc_span(n).cmp(ts) })
  let idx = match i {
    Ok(n) => n
    Err(n) => n
  }
  TzOffset::make(self, span.get(idx))
}

///|
/// 给定本地墙钟，返回 LocalResult[TzOffset]（含 DST 歧义/缺口处理）。
pub fn Tz::offset_from_local_date_time(
  self : Tz,
  dt : NaiveDateTime,
) -> LocalResult[TzOffset] {
  let ts = dt.timestamp()
  let span = self.timespans()
  let i = binary_search(0, span.len(), fn(n) { span.local_span(n).cmp(ts) })
  match i {
    Ok(0) if span.len() == 1 =>
      LocalResult::Single(TzOffset::make(self, span.get(0)))
    Ok(0) if span.local_span(1).contains(ts) =>
      LocalResult::Ambiguous(
        TzOffset::make(self, span.get(0)),
        TzOffset::make(self, span.get(1)),
      )
    Ok(0) => LocalResult::Single(TzOffset::make(self, span.get(0)))
    Ok(n) if span.local_span(n - 1).contains(ts) =>
      LocalResult::Ambiguous(
        TzOffset::make(self, span.get(n - 1)),
        TzOffset::make(self, span.get(n)),
      )
    Ok(n) if n == span.len() - 1 =>
      LocalResult::Single(TzOffset::make(self, span.get(n)))
    Ok(n) if span.local_span(n + 1).contains(ts) =>
      LocalResult::Ambiguous(
        TzOffset::make(self, span.get(n)),
        TzOffset::make(self, span.get(n + 1)),
      )
    Ok(n) => LocalResult::Single(TzOffset::make(self, span.get(n)))
    Err(_) => LocalResult::None
  }
}

///|
/// Tz 实现 TimeZone trait（方法已定义，trait 声明见下）。
/// 注：MoonBit 用户自定义 trait 用 `pub impl Trait for Type with fn ...` 语法，
/// 此处方法已作为 Tz 的公开方法定义，可直接调用。

///|
/// DST 春进缺口信息，描述一个不存在的本地时刻前后的边界。
pub struct GapInfo {
  begin : (NaiveDateTime, TzOffset)?
  end : DateTime?
}

///|
/// 由边界直接构造。
pub fn GapInfo::make(
  begin : (NaiveDateTime, TzOffset)?,
  end : DateTime?,
) -> GapInfo {
  GapInfo::{ begin, end, }
}

///|
/// 探测本地墙钟 `local` 在时区 `tz` 下是否落在 DST 春进缺口。
pub fn GapInfo::detect(local_dt : NaiveDateTime, tz : Tz) -> GapInfo? {
  let ts = tz.timespans()
  let timestamp = local_dt.timestamp()
  match binary_search(0, ts.len(), fn(n) { ts.local_span(n).cmp(timestamp) }) {
    Ok(_) => None
    Err(end_idx) =>
      Some(GapInfo::make(gap_begin(tz, ts, end_idx), gap_end(tz, ts, end_idx)))
  }
}

///|
/// 缺口前最后一刻（本地）：endIdx==0 表示无前驱。
fn gap_begin(
  tz : Tz,
  ts : @core.FixedTimespanSet,
  end_idx : Int32,
) -> (NaiveDateTime, TzOffset)? {
  if end_idx == 0 {
    None
  } else {
    match ts.local_span(end_idx - 1).end {
      Some(t) =>
        Some(
          (
            NaiveDateTime::from_timestamp(t),
            TzOffset::make(tz, ts.get(end_idx - 1)),
          ),
        )
      None => None
    }
  }
}

///|
/// 缺口后第一刻（本地）：endIdx>=len 表示无后继。
fn gap_end(tz : Tz, ts : @core.FixedTimespanSet, end_idx : Int32) -> DateTime? {
  if end_idx >= ts.len() {
    None
  } else {
    match ts.local_span(end_idx).begin {
      Some(t) => gap_end_inner(tz, t)
      None => None
    }
  }
}

///|
fn gap_end_inner(tz : Tz, t : Int64) -> DateTime? {
  let nl = NaiveDateTime::from_timestamp(t)
  match tz.from_local_date_time(nl) {
    LocalResult::Single(dt) => Some(dt)
    _ => None
  }
}
