import 'package:flutter/material.dart';
import 'package:flutterflix/assets.dart';
import 'package:flutterflix/sampleData/atlaEpisodes.dart';
import 'package:flutterflix/sampleData/blackMirrorEpisodes.dart';
import 'package:flutterflix/sampleData/breakingBadEpisodes.dart';
import 'package:flutterflix/sampleData/cobraKaiEpisode.dart';
import 'package:flutterflix/sampleData/queenEpisodes.dart';
import 'package:flutterflix/sampleData/tigerEpisodes.dart';
import 'package:flutterflix/sampleData/umbrellaEpisodes.dart';
import 'package:flutterflix/sampleData/witcherEpisodes.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/models/notificationModel.dart';
import 'package:flutterflix/screens/homeScreen.dart';
import 'package:flutterflix/sampleData/trailers.dart';

final List<String> genres = const [
  "All",
  "Crime",
  "Drama",
  "Documentry",
  "Sci-Fi",
  "Comedy",
  "Thriller",
  "Sports",
  "Action",
  "Animation",
  "Fantasy",
  "Mystery"
];

final List<String> colors = [
  Colors.red.toString(),
  Colors.blue.toString(),
  Colors.green.toString(),
  Colors.yellow.toString(),
  Colors.cyan.toString(),
  Colors.white.toString(),
  Colors.brown.toString(),
  Colors.amber.toString(),
  Colors.blueGrey.toString(),
  Colors.deepOrange.toString(),
  Colors.indigo.toString(),
];

final Content featureHome = atla;
final Content featureTV = breakingBad;
final Content featureMovie = ava;

final List<Content> previews = [
  atla,
  breakingBad,
  blackMirror,
  cobraKai,
  umbrellaAcademy,
  queenGambit,
  tigerKing,
  witcher,
  shazam,
  matrix,
  lotr,
  ava,
  bahubali,
  oblivion,
  mosul,
  dangal,
  sintelContent
];

final List<Content> myList = [
  ava,
  queenGambit,
  oblivion,
  mosul,
  witcher,
  tigerKing,
  matrix,
  lotr
];

final List<Content> topSearches = [
  cobraKai,
  queenGambit,
  umbrellaAcademy,
  tigerKing,
  witcher,
  shazam,
  matrix,
  lotr,
  ava,
  bahubali,
  oblivion,
];

final List<Content> originals = [
  ava,
  queenGambit,
  blackMirror,
  tigerKing,
  witcher,
  lotr,
  breakingBad,
  mosul
];

final List<Content> trending = [
  atla,
  breakingBad,
  blackMirror,
  cobraKai,
  queenGambit,
  umbrellaAcademy,
  tigerKing,
  witcher,
  shazam,
  matrix,
  lotr,
  ava,
  bahubali,
  oblivion,
  mosul,
  dangal,
  sintelContent
];

final List<Content> allContent = [
  atla,
  breakingBad,
  blackMirror,
  cobraKai,
  queenGambit,
  umbrellaAcademy,
  tigerKing,
  witcher,
  shazam,
  matrix,
  lotr,
  ava,
  bahubali,
  oblivion,
  mosul,
  dangal,
  sintelContent
];

final Content sintelContent = Content(
  id: "Mov_01",
  name: 'Sintel',
  color: Colors.red,
  imageUrl: Assets.sintel,
  imageUrlLandscape: Assets.sintel_landscape,
  poster: Assets.sintelPoster,
  titleImageUrl: Assets.sintelTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.sintelPreviewUrl,
  percentMatch: 55,
  year: 2016,
  rating: 12,
  duration: 144,
  genres: ["Animation", "Fantasy", "Mystery"],
  cast: [
    "Halina Reijn",
    "Thom Hoffman",
  ],
  trailers: [sintelTrailer1, sintelTrailer2, sintelTrailer3],
  description:
      'A lonely young woman, Sintel,helps and befriends a dragon,whom she calls Scales. But when he is kidnapped by an adultdragon, Sintel decides to embark on a dangerous quest to findher lost friend Scales.',
);

final Content blackMirror = Content(
  id: "TV_01",
  name: 'Black Mirror',
  color: Colors.tealAccent,
  imageUrl: Assets.blackMirror,
  imageUrlLandscape: Assets.blackMirrorLandscape,
  poster: Assets.blackMirrorPoster,
  titleImageUrl: Assets.blackMirrorTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.blackMirrorPreviewUrl,
  percentMatch: 97,
  year: 2011,
  rating: 18,
  duration: 789,
  genres: [
    "Drama",
    "Sci-Fi",
    "Thriller",
  ],
  cast: ["Daniel Lapaine", "Hannah John-Kamen", "Michaela Coel"],
  episodes: [
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode1,
    blackMirrorEpisode2,
    blackMirrorEpisode3
  ],
  seasons: ["Season 1", "Season 2"],
  trailers: [blackMirrorTrailer1, blackMirrorTrailer3],
  description:
      "In an abstrusely dystopian future, several individuals grapple with the manipulative effects of cutting edge technology in their personal lives and behaviours.",
);

final Content atla = Content(
  id: "TV_02",
  name: 'Avatar The Last Airbender',
  color: Colors.orange,
  imageUrl: Assets.atla,
  imageUrlLandscape: Assets.atla_landscape,
  poster: Assets.atlaPoster,
  titleImageUrl: Assets.atlaTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.atlaPreviewUrl,
  percentMatch: 23,
  year: 2006,
  rating: 12,
  duration: 297,
  genres: ["Animation", "Fantasy", "Mystery"],
  cast: ["Zach Tyler", "Mae Whitman", "Jack De Sena"],
  episodes: [
    atlaEpisode0,
    atlaEpisode1,
    atlaEpisode2,
    atlaEpisode3,
    atlaEpisode4,
    atlaEpisode5,
    atlaEpisode6,
    atlaEpisode7,
    atlaEpisode8,
    atlaEpisode9,
    atlaEpisode10
  ],
  seasons: ["The intro", "Season 2"],
  trailers: [atlaTrailer1, atlaTrailer2, atlaTrailer3],
  description:
      "The world is divided into four elemental nations: The Northern and Southern Water Tribes, the Earth Kingdom, the Fire Nation, and the Air Nomads.",
);

final Content breakingBad = Content(
  id: "TV_03",
  name: 'Breaking Bad',
  color: Colors.green,
  imageUrl: Assets.breakingBad,
  imageUrlLandscape: Assets.breakingBadLandscape,
  poster: Assets.breakingBadPoster,
  titleImageUrl: Assets.breakingBadTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.breakingBadPreviewUrl,
  percentMatch: 46,
  year: 2001,
  rating: 6,
  duration: 887,
  genres: ["Crime", "Drama", "Thriller"],
  cast: [
    "Bryan Cranston",
    "Aaron Paul",
    "Anna Gunn",
  ],
  episodes: [
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode1,
    breakingBadEpisode2,
    breakingBadEpisode3
  ],
  seasons: ["Season 1", "Season 2"],
  trailers: [breakingBadTrailer1, breakingBadTrailer2, breakingBadTrailer3],
  description:
      "A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family's future.",
);

final Content cobraKai = Content(
  id: "TV_04",
  name: 'Cobra Kai',
  color: Colors.yellow,
  imageUrl: Assets.cobraKai,
  imageUrlLandscape: Assets.cobraKaiLandscape,
  poster: Assets.cobraKaiPoster,
  titleImageUrl: Assets.cobraKaiTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.cobraKaiPreviewUrl,
  percentMatch: 46,
  year: 2018,
  rating: 10,
  duration: 330,
  genres: ["Comedy", "Drama", "Action"],
  cast: ["Mary Mouser", "William Zabka", "Tanner Buchanan", "Ralph Macchio"],
  episodes: [
    cobraKaiEpisode1,
    cobraKaiEpisode2,
    cobraKaiEpisode1,
    cobraKaiEpisode2,
    cobraKaiEpisode1,
    cobraKaiEpisode2,
    cobraKaiEpisode1,
    cobraKaiEpisode2,
    cobraKaiEpisode1,
    cobraKaiEpisode2,
    cobraKaiEpisode1,
    cobraKaiEpisode2,
    cobraKaiEpisode1,
    cobraKaiEpisode2,
    cobraKaiEpisode3
  ],
  seasons: ["Season 1", "Season 2"],
  trailers: [cobraKaiTrailer1, cobraKaiTrailer2, cobraKaiTrailer3],
  description:
      "Decades after their 1984 All Valley Karate Tournament bout, a middle-aged Daniel LaRusso and Johnny Lawrence find themselves martial-arts rivals again.",
);

final Content queenGambit = Content(
  id: "TV_05",
  name: "Queen's Gambit",
  color: Colors.pink,
  imageUrl: Assets.queenGambit,
  imageUrlLandscape: Assets.queenGambitLandscape,
  poster: Assets.queenGambitPoster,
  titleImageUrl: Assets.queenGambitTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.queenGambitPreviewUrl,
  percentMatch: 77,
  year: 2019,
  rating: 10,
  duration: 342,
  genres: ["Sports", "Drama", "Thriller"],
  cast: [
    "Anya Taylor-Joy",
    "Chloe Pirrie",
    "Bill Camp",
  ],
  episodes: [
    queenEpisode1,
    queenEpisode2,
    queenEpisode1,
    queenEpisode2,
    queenEpisode1,
    queenEpisode2,
    queenEpisode1,
    queenEpisode2,
    queenEpisode1,
    queenEpisode2,
    queenEpisode1,
    queenEpisode2,
    queenEpisode1,
    queenEpisode2,
    queenEpisode1,
    queenEpisode2,
    queenEpisode3
  ],
  seasons: ["Season 1", "Season 2"],
  trailers: [queenTrailer1, queenTrailer2, queenTrailer3, queenTrailer4],
  description:
      "Orphaned at the tender age of nine, prodigious introvert Beth Harmon discovers and masters the game of chess in 1960s USA. But child stardom comes at a price.",
);

final Content umbrellaAcademy = Content(
  id: "TV_06",
  name: 'Umbrella Academy',
  color: Colors.blue,
  imageUrl: Assets.umbrellaAcademy,
  imageUrlLandscape: Assets.umbrellaAcademyLandscape,
  poster: Assets.umbrellaAcademyPoster,
  titleImageUrl: Assets.umbrellaAcademyTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.umbrellaAcademyPreviewUrl,
  percentMatch: 52,
  year: 2014,
  rating: 3,
  duration: 1045,
  genres: ["Comedy", "Drama", "Sci-Fi"],
  cast: [
    "Elliot Page",
    "Tom Hopper",
    "David Castañeda",
  ],
  episodes: [
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode1,
    umbrellaEpisode2,
    umbrellaEpisode3
  ],
  seasons: ["Season 1", "Season 2"],
  trailers: [umbrellaTrailer1, umbrellaTrailer2, umbrellaTrailer3],
  description:
      "A family of former child heroes, now grown apart, must reunite to continue to protect the world.",
);

final Content tigerKing = Content(
  id: "TV_07",
  name: 'Tiger King',
  color: Colors.teal,
  imageUrl: Assets.tigerKing,
  imageUrlLandscape: Assets.tigerKingLandscape,
  poster: Assets.tigerKingPoster,
  titleImageUrl: Assets.tigerKingTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.sintelPreviewUrl,
  percentMatch: 12,
  year: 2020,
  rating: 3,
  duration: 120,
  genres: ["Crime", "Drama", "Documentry"],
  cast: [
    "Carole Baskin",
    "Joe Exotic",
    "Howard Baskin",
    "Bhagavan Antle",
    "John Finlay",
  ],
  episodes: [
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode1,
    tigerEpisode2,
    tigerEpisode3
  ],
  seasons: ["Season 1", "Season 2"],
  trailers: [tigerTrailer1, tigerTrailer2, tigerTrailer3],
  description:
      "A rivalry between big cat eccentrics takes a dark turn when Joe Exotic, a controversial animal park boss, is caught in a murder-for-hire plot.",
);

final Content witcher = Content(
  id: "TV_08",
  name: 'Witcher',
  color: Colors.white,
  imageUrl: Assets.witcher,
  imageUrlLandscape: Assets.witcher_landscape,
  poster: Assets.witcherPoster,
  titleImageUrl: Assets.witcherTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.TV_SHOW,
  previewVideo: Assets.witcherPreviewUrl,
  percentMatch: 100,
  year: 2010,
  rating: 18,
  duration: 430,
  genres: ["Action", "Fantasy", "Mystery"],
  cast: [
    "Henry Cavill",
    "Freya Allan",
    "Yasen Atour",
  ],
  episodes: [
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode1,
    witcherEpisode2,
    witcherEpisode3
  ],
  seasons: ["Season 1", "Season 2"],
  trailers: [witcherTrailer1, witcherTrailer2, witcherTrailer3],
  description:
      "Geralt of Rivia, a solitary monster hunter, struggles to find his place in a world where people often prove more wicked than beasts.",
);

final Content shazam = Content(
  id: "Mov_02",
  name: 'Shazam',
  color: Colors.yellow,
  imageUrl: Assets.shazam,
  imageUrlLandscape: Assets.shazam_landscape,
  poster: Assets.shazamPoster,
  titleImageUrl: Assets.shazamTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.shazamPreviewUrl,
  percentMatch: 55,
  year: 2019,
  rating: 12,
  duration: 170,
  genres: ["Action", "Fantasy", "Fantasy"],
  cast: ["Zachary Levi", "Mark Strong", "Asher Angel"],
  trailers: [shazamTrailer1, shazamTrailer2, shazamTrailer3],
  description:
      'A newly fostered young boy in search of his mother instead finds unexpected super powers and soon gains a powerful enemy.',
);

final Content matrix = Content(
  id: "Mov_03",
  name: 'Matrix',
  color: Colors.green,
  imageUrl: Assets.matrix,
  imageUrlLandscape: Assets.matrix_landscape,
  poster: Assets.matrixPoster,
  titleImageUrl: Assets.matrixTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.matrixPreviewUrl,
  percentMatch: 100,
  year: 1999,
  rating: 12,
  duration: 130,
  genres: ["Action", "Mystery", "Sci-Fi"],
  cast: ["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss"],
  trailers: [matrixTrailer1, matrixTrailer2, matrixTrailer3],
  description:
      'When a beautiful stranger leads computer hacker Neo to a forbidding underworld, he discovers the shocking truth--the life he knows is the elaborate deception of an evil cyber-intelligence.',
);

final Content lotr = Content(
  id: "Mov_04",
  name: 'The Lord of the Rings',
  color: Colors.yellow[800],
  imageUrl: Assets.lotr,
  imageUrlLandscape: Assets.lotr_landscape,
  poster: Assets.lotrPoster,
  titleImageUrl: Assets.lotrTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.lotrPreviewUrl,
  percentMatch: 100,
  year: 2001,
  rating: 12,
  duration: 210,
  genres: ["Action", "Drama", "Fantasy"],
  cast: ["Elijah Wood", "Ian McKellen", "Orlando Bloom"],
  trailers: [lotrTrailer1, lotrTrailer2, lotrTrailer3],
  description:
      'A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.',
);

final Content ava = Content(
  id: "Mov_05",
  name: 'Ava',
  color: Colors.red[300],
  imageUrl: Assets.ava,
  imageUrlLandscape: Assets.ava_landscape,
  poster: Assets.avaPoster,
  titleImageUrl: Assets.avaTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.avaPreviewUrl,
  percentMatch: 43,
  year: 2018,
  rating: 12,
  duration: 134,
  genres: ["Action", "Crime", "Thriller"],
  cast: ["Jessica Chastain", "John Malkovich", "Common"],
  trailers: [avaTrailer1, avaTrailer2, avaTrailer3],
  description:
      'Ava is a deadly assassin who works for a black ops organization, traveling the globe specializing in high profile hits. When a job goes dangerously wrong she is forced to fight for her own survival.',
);

final Content bahubali = Content(
  id: "Mov_06",
  name: 'Bahubali',
  color: Colors.brown,
  imageUrl: Assets.bahubali,
  imageUrlLandscape: Assets.bahubali_landscape,
  poster: Assets.bahubaliPoster,
  titleImageUrl: Assets.bahubaliTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.bahubaliPreviewUrl,
  percentMatch: 43,
  year: 2015,
  rating: 12,
  duration: 134,
  genres: ["Action", "Drama", "Documentry"],
  cast: ["Prabhas", "Rana Daggubati", "Ramya Krishnan"],
  trailers: [bbTrailer1, bbTrailer2, bbTrailer3],
  description:
      'In ancient India, an adventurous and daring man becomes involved in a decades old feud between two warring people.',
);

final Content oblivion = Content(
  id: "Mov_07",
  name: 'Oblivion',
  color: Colors.lightBlue,
  imageUrl: Assets.oblivion,
  imageUrlLandscape: Assets.oblivion_landscape,
  poster: Assets.oblivionPoster,
  titleImageUrl: Assets.oblivionTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.oblivionPreviewUrl,
  percentMatch: 89,
  year: 2013,
  rating: 12,
  duration: 134,
  genres: ["Action", "Sci-Fi", "Crime"],
  cast: ["Tom Cruise", "Morgan Freeman", "Andrea Riseborough"],
  trailers: [oblivionTrailer1, oblivionTrailer2, oblivionTrailer3],
  description:
      'A veteran assigned to extract Earths remaining resources begins to question what he knows about his mission and himself.',
);

final Content mosul = Content(
  id: "Mov_08",
  name: 'Mosul',
  color: Colors.white,
  imageUrl: Assets.mosul,
  imageUrlLandscape: Assets.mosul_landscape,
  poster: Assets.mosulPoster,
  titleImageUrl: Assets.mosulTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.mosulPreviewUrl,
  percentMatch: 89,
  year: 2018,
  rating: 4,
  duration: 134,
  genres: ["Action", "Drama", "Documentry"],
  cast: ["Waleed Elgadi", "Hayat Kamille", "Thaer Al-Shayei"],
  trailers: [mosulTrailer1, mosulTrailer2, mosulTrailer3],
  description:
      'A police unit from Mosul fight to liberate the Iraqi city from thousands of ISIS militants.',
);

final Content dangal = Content(
  id: "Mov_09",
  name: 'Dangal',
  color: Colors.amber,
  imageUrl: Assets.dangal,
  imageUrlLandscape: Assets.dangal_landscape,
  poster: Assets.dangalPoster,
  titleImageUrl: Assets.dangalTitle,
  videoUrl: Assets.sintelVideoUrl,
  category: ContentCategory.MOVIES,
  previewVideo: Assets.dangalPreviewUrl,
  percentMatch: 89,
  year: 2016,
  rating: 4,
  duration: 190,
  genres: ["Sports", "Drama", "Documentry"],
  cast: ["Aamir Khan", "Sakshi Tanwar", "Fatima Sana Shaikh"],
  trailers: [dangalTrailer1, dangalTrailer2, dangalTrailer3],
  description:
      'Former wrestler Mahavir Singh Phogat and his two wrestler daughters struggle towards glory at the Commonwealth Games in the face of societal oppression.',
);

final NotificationData notification1 =
    NotificationData("nId_1", "Avatar: New season now live", atla.id);

final NotificationData notification2 =
    NotificationData("nId_2", "Shazam: New DC movie just released", shazam.id);

final NotificationData notification3 = NotificationData(
    "nId_3", "Recomemded for you: Umbrella Academy", umbrellaAcademy.id);

final NotificationData notification4 =
    NotificationData("nId_4", "Recomemded for you: Matrix", matrix.id);
