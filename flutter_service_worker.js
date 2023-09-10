'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"android-chrome-512x512.png": "84d55ce03f0792e587917239d058d845",
"assets/assets/sounds/shot/5_Db.mp3": "7b3bc185a44bbc4bd85a8117524c55db",
"assets/assets/sounds/shot/1_B.mp3": "0a12401f0a9e06389aa641a4bdbfb8c5",
"assets/assets/sounds/shot/5_Ab.mp3": "2a31c80c301dd3b1cba46abac0116e15",
"assets/assets/sounds/shot/7_C.mp3": "2c8f62f4ec4e4a231edfebe0d3741025",
"assets/assets/sounds/shot/2_F.mp3": "8b295ecf823dde3a5810b5b9b05b5c6b",
"assets/assets/sounds/shot/0_Cb.mp3": "e5db306ff02e12b226edfa6a3901092f",
"assets/assets/sounds/shot/3_Gb.mp3": "fc134a28ccbbed5dcbaac38f4016fdde",
"assets/assets/sounds/shot/2_A.mp3": "9953068e547958cc78ec717c5e2b612a",
"assets/assets/sounds/shot/2_E.mp3": "68160a3e8ce30aa1b6e91d341ed672fa",
"assets/assets/sounds/shot/2_G.mp3": "87208127aa4d85af5f15263aac0e4c17",
"assets/assets/sounds/shot/1_Db.mp3": "c6ea51782c77ddda0a1de91b8cf2b608",
"assets/assets/sounds/shot/2_Ab.mp3": "6848703553505034b517de50cda4de40",
"assets/assets/sounds/shot/3_E.mp3": "d697ab725335ee2f8ea0f7128614ebba",
"assets/assets/sounds/shot/5_Fb.mp3": "bb8c5421bbb6e86b72d6b282f1ae20d5",
"assets/assets/sounds/shot/0_D.mp3": "97f0eb706bdcc1cd35cd075b7d854c97",
"assets/assets/sounds/shot/0_Fb.mp3": "20ed3ffdf93d83a5db5654420f08d66c",
"assets/assets/sounds/shot/5_A.mp3": "119d50064f9eef8b8581fd40f5b1fe06",
"assets/assets/sounds/shot/2_D.mp3": "a3b95489a5c4b067f442250d72806de4",
"assets/assets/sounds/shot/0_E.mp3": "0580ba4a60eb112f06e2f285ae9ad931",
"assets/assets/sounds/shot/3_Db.mp3": "18b2216633693f358752ea315deebc4d",
"assets/assets/sounds/shot/4_B.mp3": "9cbc4ae50d990a5f899d95cffda6ae46",
"assets/assets/sounds/shot/2_Fb.mp3": "ddee45aa0684e6a0b12c1bb80c37bf2e",
"assets/assets/sounds/shot/6_B.mp3": "1db0c5f4b8db9225f72c5916fb21ed58",
"assets/assets/sounds/shot/5_G.mp3": "be3aba642fb24dc46f6dbd6d909be95c",
"assets/assets/sounds/shot/1_A.mp3": "b35d3cd212f608cfbd8ba8e383a5a63e",
"assets/assets/sounds/shot/6_F.mp3": "76011c1fcb87278553b2e88c482941d0",
"assets/assets/sounds/shot/4_F.mp3": "d2abea115ed9af8262b14612447ba627",
"assets/assets/sounds/shot/0_F.mp3": "c0752fce2f6b6d781baa7474b48a1ce1",
"assets/assets/sounds/shot/3_F.mp3": "912f1124cf6d147ca10b26d6acaba3fc",
"assets/assets/sounds/shot/3_C.mp3": "192bd98eef72d407a418915aeb3ac030",
"assets/assets/sounds/shot/3_Ab.mp3": "d0e04b9b28410d9cba32a2c4d367109a",
"assets/assets/sounds/shot/-1_A.mp3": "5781aa84fd29c9bca413ec6de976a1de",
"assets/assets/sounds/shot/6_Gb.mp3": "aebc4282aa6127aa0f96c9731b56d2e8",
"assets/assets/sounds/shot/5_D.mp3": "c3208786f9fe8bcfe89c1e8b92918158",
"assets/assets/sounds/shot/6_E.mp3": "a95ae91636403898d1b7e61aa2b46ed3",
"assets/assets/sounds/shot/3_B.mp3": "0926ab5d2d12e11ec9db86e5e4d28ad3",
"assets/assets/sounds/shot/6_A.mp3": "c6533fde1c36f7f9f6089ec60737696e",
"assets/assets/sounds/shot/3_A.mp3": "167daa42bd16735c70f0eb1757bb66f7",
"assets/assets/sounds/shot/3_G.mp3": "08628a889af56ff51c1a8be2064f633f",
"assets/assets/sounds/shot/4_A.mp3": "179b068ece29b9339da2892cf343277e",
"assets/assets/sounds/shot/4_E.mp3": "fbc2c909b8cd53902e525253e20db8c6",
"assets/assets/sounds/shot/1_Gb.mp3": "d67dc1f5ed27756d16f91e5e6c04f1f8",
"assets/assets/sounds/shot/0_Ab.mp3": "5db483b0ff331903ac081725d48bb6c8",
"assets/assets/sounds/shot/6_G.mp3": "dda04302316bfe6eb7d10a3b0046dfc5",
"assets/assets/sounds/shot/1_C.mp3": "cfc87302d0ec2ac0e96d3b623b559578",
"assets/assets/sounds/shot/5_Gb.mp3": "8dcf27b2b0e31daac303bb24a1e0473d",
"assets/assets/sounds/shot/6_D.mp3": "cb772ec675538d7c91c1246048a4d9bc",
"assets/assets/sounds/shot/0_Gb.mp3": "d69695c8e64ac06e291d7bd890237438",
"assets/assets/sounds/shot/1_F.mp3": "40179cf2425850db8f19c63b34d32e2d",
"assets/assets/sounds/shot/-1_B.mp3": "94f46322a04012c30ef2d644a23fa215",
"assets/assets/sounds/shot/5_F.mp3": "01de37a75da8b6e92a516df1b86ec1fe",
"assets/assets/sounds/shot/5_Cb.mp3": "87d3b939055168a6ce225ab1496ab33a",
"assets/assets/sounds/shot/4_Gb.mp3": "38c31188ad68bffe79a5822057ad8a7b",
"assets/assets/sounds/shot/4_Db.mp3": "2f10f2ce710e84259bd083e51baa7094",
"assets/assets/sounds/shot/6_Cb.mp3": "9dcdf7dbbd91b4dfbd87667aedc7610d",
"assets/assets/sounds/shot/3_Cb.mp3": "b35e91c9fe22799c416ae83f95e2e396",
"assets/assets/sounds/shot/6_C.mp3": "b63df580d3c692ffe82aa4dcb0a55f11",
"assets/assets/sounds/shot/4_D.mp3": "bbf0ce3ff58d4eddcf34ed3c21116d61",
"assets/assets/sounds/shot/6_Db.mp3": "72565241284150b80f7cd7b1371030d4",
"assets/assets/sounds/shot/3_Fb.mp3": "622f486e18e290a09d78c0e450ca4bc7",
"assets/assets/sounds/shot/4_C.mp3": "8f168558a4813b060cd04133a6c3af5a",
"assets/assets/sounds/shot/1_D.mp3": "87480da9e62b7754d16ebfe591986020",
"assets/assets/sounds/shot/3_D.mp3": "5c226bcdb9ce5c2d2c5120586f8530d8",
"assets/assets/sounds/shot/6_Ab.mp3": "d5c2f638f23ee9ebb0b18641e7334c71",
"assets/assets/sounds/shot/2_Db.mp3": "e84bcbe2f7dd89df02bcf114cacaa9d4",
"assets/assets/sounds/shot/1_E.mp3": "92c00ec71321c22d4f15d347d417156c",
"assets/assets/sounds/shot/2_B.mp3": "33f1058fe4f9e2a3d2acf3619d071b5a",
"assets/assets/sounds/shot/0_Db.mp3": "3f1c0f7fbc79d378141adc91b4c701d4",
"assets/assets/sounds/shot/1_Ab.mp3": "46a68f61d67331dbfcb7bb1450ccfe5e",
"assets/assets/sounds/shot/4_Cb.mp3": "d34dc8bf02e259eaa83badaf7032a04b",
"assets/assets/sounds/shot/1_Cb.mp3": "a8367e2f7df705375dc5ec4d924ea979",
"assets/assets/sounds/shot/4_Fb.mp3": "8d544850cb8f7c7511d129c8ecaa6375",
"assets/assets/sounds/shot/5_B.mp3": "18662d1cb37bf76121227c360164572c",
"assets/assets/sounds/shot/1_Fb.mp3": "3699d6ccac0e7966b5824150f557a64e",
"assets/assets/sounds/shot/4_Ab.mp3": "fbce232da1b9a23e49670b5522e8ba3b",
"assets/assets/sounds/shot/0_A.mp3": "11435eb70ac255a3ca561ca43e858081",
"assets/assets/sounds/shot/2_Cb.mp3": "73682253f57f9fc74fef350071581349",
"assets/assets/sounds/shot/2_C.mp3": "4798f99ecd532ff1c7bda791ab7dd8a0",
"assets/assets/sounds/shot/2_Gb.mp3": "91d7c2f6639626a514633b849f47bf18",
"assets/assets/sounds/shot/0_B.mp3": "70ba58e6acf846a3013fae30f51fefff",
"assets/assets/sounds/shot/0_G.mp3": "b2ab707a41be69c6999c80298458c209",
"assets/assets/sounds/shot/1_G.mp3": "1bd3750e5653a925348cb18508e21797",
"assets/assets/sounds/shot/5_C.mp3": "eb7393f229fea55ffea16f60f4a8647d",
"assets/assets/sounds/shot/5_E.mp3": "961b64403a323a2804bb21e51a9e89f6",
"assets/assets/sounds/shot/-1_Ab.mp3": "c2575a9a032ff8bd25c5ca181260718e",
"assets/assets/sounds/shot/6_Fb.mp3": "40b7ffa8a7f2f8b9c0312f8069d45da2",
"assets/assets/sounds/shot/4_G.mp3": "51ef731d4631a2707b0b4c2d8f3c12e5",
"assets/assets/sounds/shot/0_C.mp3": "4a9f85902bcde77267038dec7e6f429a",
"assets/assets/sounds/sustain/5_Db.mp3": "9bec46889009b250fd3f88d92bd8f78d",
"assets/assets/sounds/sustain/1_B.mp3": "16d3ad0ae7433a69768567785b80fff2",
"assets/assets/sounds/sustain/5_Ab.mp3": "4803c5a64caf1a07868fea66007ec080",
"assets/assets/sounds/sustain/7_C.mp3": "1006209e4ef96e64205e1d9efd0c16fb",
"assets/assets/sounds/sustain/2_F.mp3": "60568226cc62798e513f3cfcf7a4d30c",
"assets/assets/sounds/sustain/0_Cb.mp3": "5e8d143545f5ba540af2c5b4fd7da479",
"assets/assets/sounds/sustain/3_Gb.mp3": "d6c3546760d2e93abe03c303d052c360",
"assets/assets/sounds/sustain/2_A.mp3": "4f11ef3ce29b84d4fc3636f3ff278e31",
"assets/assets/sounds/sustain/2_E.mp3": "1db1aa52267650efd085f0fed070189a",
"assets/assets/sounds/sustain/2_G.mp3": "b934bd39bad9125e6ae8d2d9bdd36742",
"assets/assets/sounds/sustain/1_Db.mp3": "cc097eeea729493fd210d2db0625ab89",
"assets/assets/sounds/sustain/2_Ab.mp3": "117b9b263afd0b3da43d0fc618b4b7d0",
"assets/assets/sounds/sustain/3_E.mp3": "14b3d32afcb994e4d9ba0080310e114c",
"assets/assets/sounds/sustain/5_Fb.mp3": "806210acd92532f6b76ab006cd3ac2cf",
"assets/assets/sounds/sustain/0_D.mp3": "3b142c2cb4925ca134c179a76d91cc06",
"assets/assets/sounds/sustain/0_Fb.mp3": "595761742797c5231a7f93e09d61f8db",
"assets/assets/sounds/sustain/5_A.mp3": "e7f635827590f986e15be446fd9e04c4",
"assets/assets/sounds/sustain/2_D.mp3": "58df1bdb909e1fece7834063519d5458",
"assets/assets/sounds/sustain/0_E.mp3": "a5a40c34bb4cd72475ff494a7ed4ba33",
"assets/assets/sounds/sustain/3_Db.mp3": "f2413537708982c771cafa4463014b91",
"assets/assets/sounds/sustain/4_B.mp3": "7ed4aef0e9655fac02bb23d060d4aa22",
"assets/assets/sounds/sustain/2_Fb.mp3": "d24c41ef5277e62c6991a30aa3aaef87",
"assets/assets/sounds/sustain/6_B.mp3": "3c76191ac64e9753f3551509e32858c8",
"assets/assets/sounds/sustain/5_G.mp3": "127ec3a60fee8e22b2cb6ee45bfee349",
"assets/assets/sounds/sustain/1_A.mp3": "6f216e423937867d0da4a60e3205cf6a",
"assets/assets/sounds/sustain/6_F.mp3": "a0859d8d8f9c2cd8d033bdfedd82e5f7",
"assets/assets/sounds/sustain/4_F.mp3": "d15c0434fefc665ac1228983974859cd",
"assets/assets/sounds/sustain/0_F.mp3": "d10c07df221c6fabc116c01ed3bf83df",
"assets/assets/sounds/sustain/3_F.mp3": "8fa82a201eb6e25fb24b35d300f72c1f",
"assets/assets/sounds/sustain/3_C.mp3": "6160814fab9e8a9b3bbc60dd5b1c3790",
"assets/assets/sounds/sustain/3_Ab.mp3": "666498d8920ecb21e55a98194678dafe",
"assets/assets/sounds/sustain/-1_A.mp3": "b317e1325cc14f14f5fc2427ec5d2383",
"assets/assets/sounds/sustain/6_Gb.mp3": "fbcfb3559196c7dee117ffe46c3d443e",
"assets/assets/sounds/sustain/5_D.mp3": "d3803ccf63ac195157f895b2326cea46",
"assets/assets/sounds/sustain/6_E.mp3": "d08f686083ed4e097471c43f3fb122c7",
"assets/assets/sounds/sustain/3_B.mp3": "05afd3497b4a3d9a6acafed5cf6dd857",
"assets/assets/sounds/sustain/7_Cb.mp3": "f24d7703ceeba1dcae5675a00cc8deff",
"assets/assets/sounds/sustain/6_A.mp3": "bda3569b69dfdf43db731517f55ca0d7",
"assets/assets/sounds/sustain/3_A.mp3": "9443e46d85a9a7558dd612cda1649b0f",
"assets/assets/sounds/sustain/3_G.mp3": "2589f49e70a49d22018b1da414182c99",
"assets/assets/sounds/sustain/4_A.mp3": "1771c9c2af03ccd6af653e8a77bd3eee",
"assets/assets/sounds/sustain/4_E.mp3": "c8c6769d91bbe60d5ff04ca3f61095f8",
"assets/assets/sounds/sustain/1_Gb.mp3": "11e099446da3bf371125283ec77bdf88",
"assets/assets/sounds/sustain/0_Ab.mp3": "d8d30a37bfd10c35d8e9b8d96a4fd48b",
"assets/assets/sounds/sustain/6_G.mp3": "2ff21ce83b7284dd35d6ea0334e6b89d",
"assets/assets/sounds/sustain/1_C.mp3": "ecae93f87bd61fe7eef3d955d44b447f",
"assets/assets/sounds/sustain/5_Gb.mp3": "318962ebb8497eb5edc9436d8f73b129",
"assets/assets/sounds/sustain/6_D.mp3": "65eae207905ede872a029f1fcd3c4390",
"assets/assets/sounds/sustain/0_Gb.mp3": "7d8254d22e07a4c760b54c0d7d9a9ff8",
"assets/assets/sounds/sustain/1_F.mp3": "ce98d06698de690ce22716a5ec2e3b3f",
"assets/assets/sounds/sustain/-1_B.mp3": "e56130c33d569ab5022569ff2848fa98",
"assets/assets/sounds/sustain/5_F.mp3": "12f4cca548a8e24d83569146f3fed762",
"assets/assets/sounds/sustain/5_Cb.mp3": "1e99076329d1083b0808685045c7f6da",
"assets/assets/sounds/sustain/4_Gb.mp3": "30151b052785f03d369ebb6b13937024",
"assets/assets/sounds/sustain/4_Db.mp3": "d9f745361dcfc9fbb1cba069d78309ab",
"assets/assets/sounds/sustain/6_Cb.mp3": "878cc8457f7ca8b81aac0a402027274f",
"assets/assets/sounds/sustain/3_Cb.mp3": "e6412ae4acffd3b34b0093588bd37622",
"assets/assets/sounds/sustain/6_C.mp3": "3249f689d1a1e4ecb2760b7f07d72d15",
"assets/assets/sounds/sustain/4_D.mp3": "2ef5e8cd163231070dc48a958ed001d2",
"assets/assets/sounds/sustain/6_Db.mp3": "36ff8b9e0370d37b5f5667c2f50fabec",
"assets/assets/sounds/sustain/3_Fb.mp3": "e515df97e1d489813a3b774cd5155aa1",
"assets/assets/sounds/sustain/4_C.mp3": "03cacae170cad41bf870fc7364d9772b",
"assets/assets/sounds/sustain/1_D.mp3": "b3d2f39c8b4e163303dc0731d89a215d",
"assets/assets/sounds/sustain/3_D.mp3": "349dc465d76d901c183272dc6e26b25d",
"assets/assets/sounds/sustain/6_Ab.mp3": "c76ecfa8ebf6a6d385b926f4fdcb8598",
"assets/assets/sounds/sustain/2_Db.mp3": "1bec53ef4e0d8c564c491553fa9de700",
"assets/assets/sounds/sustain/1_E.mp3": "7ef2b470422dc5ec7b68a2e014b55ed9",
"assets/assets/sounds/sustain/2_B.mp3": "b8e0b4149a2f3369131805a03e79bcf7",
"assets/assets/sounds/sustain/0_Db.mp3": "0d77c4de6f0f70ac9b22df68da3009e2",
"assets/assets/sounds/sustain/1_Ab.mp3": "c2fa716ec04236502683dc7d080f5100",
"assets/assets/sounds/sustain/4_Cb.mp3": "2d0621508fe9bda149cf40e6044f031f",
"assets/assets/sounds/sustain/1_Cb.mp3": "54357f15210ada14d410b3eb658a5809",
"assets/assets/sounds/sustain/4_Fb.mp3": "8abcaaa7736f33f48b68e09a4c3a57c1",
"assets/assets/sounds/sustain/5_B.mp3": "3e35403468694250641c1a7662fa1c8e",
"assets/assets/sounds/sustain/1_Fb.mp3": "e2705e900307d8dbf6d34c90fc3436e3",
"assets/assets/sounds/sustain/4_Ab.mp3": "144e9433c24cf7b4ef3858dcbbfafac8",
"assets/assets/sounds/sustain/0_A.mp3": "bca587a1beca1da0927a0560f47002fb",
"assets/assets/sounds/sustain/2_Cb.mp3": "785901eb692677741ef8321165bd2f27",
"assets/assets/sounds/sustain/2_C.mp3": "6e8a9800eda4c9d9b9dde605fd2289e6",
"assets/assets/sounds/sustain/2_Gb.mp3": "eaa972a4556908bda2690e8bc015324f",
"assets/assets/sounds/sustain/0_B.mp3": "c5f37a25b9b3ca8b6043b62ad9338223",
"assets/assets/sounds/sustain/0_G.mp3": "b5a850bdd1e11878064affef67145a78",
"assets/assets/sounds/sustain/1_G.mp3": "ef38986aeeedbcf5f1499e2d5ffea0a2",
"assets/assets/sounds/sustain/5_C.mp3": "bfd8a971e558d4cd1a844c890bf2c14e",
"assets/assets/sounds/sustain/5_E.mp3": "3713e39c1d2a41609a2548a982500e04",
"assets/assets/sounds/sustain/-1_Ab.mp3": "06be678e6e66660cd559b98f2610175b",
"assets/assets/sounds/sustain/6_Fb.mp3": "eed50061beaff3d141bf541c7ae301cf",
"assets/assets/sounds/sustain/4_G.mp3": "940407720774f03d0e01ec903d8b590e",
"assets/assets/sounds/sustain/0_C.mp3": "bd9f5c32c2fe15f7f7289e0db26b24ae",
"assets/fonts/MaterialIcons-Regular.otf": "df7c776dc4fdaa2aaedc60298951c723",
"assets/AssetManifest.json": "bf4f991cf2b974107667c73c85c1a2d1",
"assets/packages/country_flags/res/si/to.si": "999f5edc1d7bd74937dab96f8d035368",
"assets/packages/country_flags/res/si/ug.si": "b5368d2d0a873dd2ff8adc689c6c6b09",
"assets/packages/country_flags/res/si/ga.si": "863042bec1c7781b8245d2fec2961835",
"assets/packages/country_flags/res/si/gq.si": "e8e087ae91048f042fa212b5f79a496c",
"assets/packages/country_flags/res/si/pr.si": "ccb19936defb882dea166d865f8ee5ff",
"assets/packages/country_flags/res/si/pa.si": "3231c2af8957eddd456819783df37ef5",
"assets/packages/country_flags/res/si/al.si": "3a10d259f602c6832ed5316403f6fe91",
"assets/packages/country_flags/res/si/ki.si": "80c4adc8b03b18055be571a612fa3f79",
"assets/packages/country_flags/res/si/vi.si": "acbfd08b5cd096eac556c46efecb7926",
"assets/packages/country_flags/res/si/uy.si": "8163529e4c65d4f7f97dad78c51918c7",
"assets/packages/country_flags/res/si/tn.si": "d15a30567010db55d9a398ffde25694c",
"assets/packages/country_flags/res/si/se.si": "64f75927796e3bcf418a7f1bce12cf39",
"assets/packages/country_flags/res/si/vu.si": "54ccd51f720f6bb242f2256626a172b8",
"assets/packages/country_flags/res/si/sc.si": "65a3e456a8f0cfb400f7a4b354fd1839",
"assets/packages/country_flags/res/si/mn.si": "d7d59010e2822958f8390d72bfbf0072",
"assets/packages/country_flags/res/si/do.si": "0c12349ea290f3e7d6bd3c7eba8ec556",
"assets/packages/country_flags/res/si/af.si": "9fb0d66778b5afe46c5750f6b2de0a06",
"assets/packages/country_flags/res/si/sb.si": "b6160f674954161619f0f57d4039e010",
"assets/packages/country_flags/res/si/gr.si": "a7ffe39d3dbd0f7e2d7cf03b38ebce8b",
"assets/packages/country_flags/res/si/gi.si": "1d4b7516dbef91dd53a3223786433468",
"assets/packages/country_flags/res/si/aw.si": "bac854c7bbf50dd71fc643f9197f4587",
"assets/packages/country_flags/res/si/nz.si": "95a431faf2077c36c314e060d3565e11",
"assets/packages/country_flags/res/si/co.si": "471a020ee0695a4be6867c76e3e4fcdf",
"assets/packages/country_flags/res/si/ad.si": "c3ccb8e3cf8b3ce384280c687c94ed53",
"assets/packages/country_flags/res/si/bb.si": "a0f7ccd01c2e5eee48607b53d0791941",
"assets/packages/country_flags/res/si/pl.si": "034643869bc1b14ad2af44cc9aa24b9f",
"assets/packages/country_flags/res/si/fm.si": "d195abb2e8d6961f6ffa0da23d8b2813",
"assets/packages/country_flags/res/si/bw.si": "50b6724787e9b206d8998f747748f133",
"assets/packages/country_flags/res/si/as.si": "f12705f23ac102cc4fa8e85c3a780040",
"assets/packages/country_flags/res/si/za.si": "a66971379a3a65b274a702c82b3375d7",
"assets/packages/country_flags/res/si/re.si": "b319560213233391af1170881595344f",
"assets/packages/country_flags/res/si/kg.si": "1f1f0daac400da3f36e873982f002844",
"assets/packages/country_flags/res/si/pg.si": "51e824f62d970ad02c7afa9cc70330d8",
"assets/packages/country_flags/res/si/dg.si": "3469f709b852fa25f3d735d4e7ee88a2",
"assets/packages/country_flags/res/si/ba.si": "6719180c7b4f5d76a1c41fd76668cc69",
"assets/packages/country_flags/res/si/ic.si": "5459bbd72389b2300c7da170cd528f23",
"assets/packages/country_flags/res/si/bf.si": "36c828d75ffb1b1ee0c074f08dbd162e",
"assets/packages/country_flags/res/si/mu.si": "9f4070ad133e7380edb48cb11cffaef1",
"assets/packages/country_flags/res/si/au.si": "93810e1a767ca77d78fa8d70ef89878a",
"assets/packages/country_flags/res/si/ni.si": "8af49cf35b72204052de6fab8322afc8",
"assets/packages/country_flags/res/si/ao.si": "042c2a03c013acf928449dbaf2a4affe",
"assets/packages/country_flags/res/si/us.si": "a524142e2a2f7df4ee1b26a98f09a927",
"assets/packages/country_flags/res/si/gb-sct.si": "c1e2452023ede8ca68306f9360bec03f",
"assets/packages/country_flags/res/si/gp.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/mm.si": "3ab23c7fcc44e249de75e6019af32611",
"assets/packages/country_flags/res/si/lb.si": "d2268cc1967d63699bb1ff2a87264c75",
"assets/packages/country_flags/res/si/fk.si": "bcdc2242f7af2a72255f8d89d2642fe8",
"assets/packages/country_flags/res/si/pm.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/ci.si": "2dd6886cd9b611e8301f347233f275db",
"assets/packages/country_flags/res/si/cu.si": "b561ce782460b38c99795d3891be4bd8",
"assets/packages/country_flags/res/si/va.si": "c23d81f5e4e3acd336ce01d9ed561ee8",
"assets/packages/country_flags/res/si/nu.si": "dac0a569e83a73006b8600fa1f1f8ac5",
"assets/packages/country_flags/res/si/sk.si": "009a8dbaf2bc675683650d84bde81643",
"assets/packages/country_flags/res/si/mq.si": "b319560213233391af1170881595344f",
"assets/packages/country_flags/res/si/ps.si": "e91b4cc92cc8629f42c9d8fb11d028ba",
"assets/packages/country_flags/res/si/pw.si": "e658e7c8cdf0e27c4d9ccb084768f383",
"assets/packages/country_flags/res/si/is.si": "6a75ef472e3b3674cb992a6c1a2d8656",
"assets/packages/country_flags/res/si/tr.si": "3bd279bd1f4c26e0ad0abed7fb744df3",
"assets/packages/country_flags/res/si/rw.si": "8b075359fc5a06224acf83d24b058752",
"assets/packages/country_flags/res/si/vn.si": "5e53b20018d53d957714d0211c237211",
"assets/packages/country_flags/res/si/ma.si": "9ced8447a0a9b2e720d870bc5aef87cf",
"assets/packages/country_flags/res/si/ac.si": "084b17449dd0ba76474f133039ee68d3",
"assets/packages/country_flags/res/si/hk.si": "cdc28623f40113eb4227c9ed796b6201",
"assets/packages/country_flags/res/si/qa.si": "534abea02d79321b510b2a3fb040ffbc",
"assets/packages/country_flags/res/si/no.si": "6b6efedb50f0a7b05a9afe882924fe99",
"assets/packages/country_flags/res/si/at.si": "da9709351758847fbf187e9947fd44a5",
"assets/packages/country_flags/res/si/pt.si": "04c1755d12a50d7524a66124c8d725cc",
"assets/packages/country_flags/res/si/ke.si": "87ce4c55414a8c5d29f23ca16310a01c",
"assets/packages/country_flags/res/si/mf.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/tv.si": "7e462e7d6fa8bdd967bf9e37b86d0906",
"assets/packages/country_flags/res/si/na.si": "d49f748db27e5d6f63293f41c2e8361e",
"assets/packages/country_flags/res/si/gs.si": "d6e2a1be23c5e70fced629d467e0a1f7",
"assets/packages/country_flags/res/si/ss.si": "cd22425520f63dac39be3dbfdb49465b",
"assets/packages/country_flags/res/si/zw.si": "b32c711b08bfe7425d509407c48ee5ed",
"assets/packages/country_flags/res/si/um.si": "bec8665843b879da2d8ed65532da7e01",
"assets/packages/country_flags/res/si/es.si": "c59363bf0d9a595df07cfe238f9cc16a",
"assets/packages/country_flags/res/si/fi.si": "6ed37987c4dee7606f35b1f3ef2f4352",
"assets/packages/country_flags/res/si/bo.si": "1491a562f1ee0f5fdf512a72821dc3b1",
"assets/packages/country_flags/res/si/cf.si": "00cce9e9924e59417fd640f22ff3c068",
"assets/packages/country_flags/res/si/kw.si": "fae7c5f1138fcb68b76b6bf1ecb5f422",
"assets/packages/country_flags/res/si/nf.si": "1473b829023248dbbd77f49b9e6e5ede",
"assets/packages/country_flags/res/si/tw.si": "7bba519f0f26cca5417d8edb57bdef83",
"assets/packages/country_flags/res/si/sl.si": "a0d669d7821909f6b73d73ebd29e77e7",
"assets/packages/country_flags/res/si/tk.si": "9fc0141c9928734e4229f05d2f2f68d4",
"assets/packages/country_flags/res/si/sm.si": "e29d9a0493a72947dfc5e5668bcdcc30",
"assets/packages/country_flags/res/si/pf.si": "29e59d85bfa9cc1ed50424098c4577b5",
"assets/packages/country_flags/res/si/tz.si": "643850342b81b7015ad57cddc9589a69",
"assets/packages/country_flags/res/si/np.si": "aac703fec2d68d1f05f0b368bcd05b5c",
"assets/packages/country_flags/res/si/eu.si": "0c7acf5338eb131940e6a2d53022fda7",
"assets/packages/country_flags/res/si/in.si": "335a5837f0d2b45527db4e60087b4221",
"assets/packages/country_flags/res/si/my.si": "017ea1b80814ba715985331e8ff494fc",
"assets/packages/country_flags/res/si/cr.si": "7385af5d3c967dad1c62027ece383dd6",
"assets/packages/country_flags/res/si/si.si": "11367d866b110a2971aae42dbc72b47f",
"assets/packages/country_flags/res/si/by.si": "045e4e447111a76bb834bd9e969756b4",
"assets/packages/country_flags/res/si/gw.si": "9c6f62e2963f012b571dad989416a1f3",
"assets/packages/country_flags/res/si/vg.si": "de1ed29316c1d0f81af9946e35d254d7",
"assets/packages/country_flags/res/si/kr.si": "0fc0217454ce0fac5d5b0ed0e19051ce",
"assets/packages/country_flags/res/si/lk.si": "c8f0c394d54b1618603d89307e6cd127",
"assets/packages/country_flags/res/si/hr.si": "dc0efaf40fb58a21f52fd9a86c7ddfdc",
"assets/packages/country_flags/res/si/un.si": "d3a2546a132b2e216aa17ffafaca8f57",
"assets/packages/country_flags/res/si/ax.si": "a456e36511e13498fa3d610a026d79b8",
"assets/packages/country_flags/res/si/bq.si": "130b5b1f64baa8e002dc668b0d3d589f",
"assets/packages/country_flags/res/si/bm.si": "2c1effe65d4c9c6ea846536f9ebcac93",
"assets/packages/country_flags/res/si/bg.si": "75bcf4b187601813fcf6008da5ef3625",
"assets/packages/country_flags/res/si/ck.si": "30d75fc50470f00d7fc590c058b7a4c1",
"assets/packages/country_flags/res/si/vc.si": "a6d41b2c67d49f3f202dc920ad2f8c49",
"assets/packages/country_flags/res/si/ai.si": "98108de6fc34688b9281b6040f855730",
"assets/packages/country_flags/res/si/tt.si": "6550348a507c01feaf93fd191503ce72",
"assets/packages/country_flags/res/si/aq.si": "e15ec1a740dfd94250faaf3a04c3e009",
"assets/packages/country_flags/res/si/cw.si": "8c2327f9686e6183f85b4141294f7944",
"assets/packages/country_flags/res/si/lr.si": "8ea704b8b395abcb8dbd13a7fb738b3e",
"assets/packages/country_flags/res/si/ng.si": "d2764e808010a6d2389cfc1e83e3b710",
"assets/packages/country_flags/res/si/je.si": "5fb5c37d3e7469ad537882debd8c4f33",
"assets/packages/country_flags/res/si/lv.si": "d61111f2dcbc8b2c84e644f7288b1fd7",
"assets/packages/country_flags/res/si/ve.si": "e846876f7ec7ad396e58fb20e969a486",
"assets/packages/country_flags/res/si/lu.si": "0ac3af11df6af8b90ca8f8078902fc9a",
"assets/packages/country_flags/res/si/bd.si": "18bcbe7c5cd7ef99faf8e581dcf6f2db",
"assets/packages/country_flags/res/si/ee.si": "d1d0e6c483ec14291ccafc69c4390f07",
"assets/packages/country_flags/res/si/kh.si": "711d8494963708be2a01a1dfc5a002db",
"assets/packages/country_flags/res/si/cn.si": "a629d6ea2863bc2e2783ed86427fccdf",
"assets/packages/country_flags/res/si/bt.si": "9b9f54fdaeb57d27628dd7318c23d632",
"assets/packages/country_flags/res/si/gb-nir.si": "70756040e8747ea10547485c1b5493dd",
"assets/packages/country_flags/res/si/gu.si": "f47c5abf0b2dd4b8b717e87c82e1f328",
"assets/packages/country_flags/res/si/sx.si": "424c70f52c10927bd40135e75d958e8b",
"assets/packages/country_flags/res/si/ky.si": "498424ad28f6c9e005ae14e8d66c3e2f",
"assets/packages/country_flags/res/si/gl.si": "f447d0f9f9e95027def4b4a333f59393",
"assets/packages/country_flags/res/si/de.si": "aaabd585b21d0960b60d05acf4c54cd3",
"assets/packages/country_flags/res/si/ch.si": "25b5af40c1ed5254d8a5c9286a235a78",
"assets/packages/country_flags/res/si/om.si": "8d23e422f6191c117e764aa17c80e195",
"assets/packages/country_flags/res/si/jm.si": "db4e387e95c824cefb80b16ae8f8af9f",
"assets/packages/country_flags/res/si/cp.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/gy.si": "6373d2b94878202fd94563aeea4fd8ca",
"assets/packages/country_flags/res/si/sh.si": "084b17449dd0ba76474f133039ee68d3",
"assets/packages/country_flags/res/si/me.si": "d87206186e9601dcfabdd0d38b655899",
"assets/packages/country_flags/res/si/tc.si": "78d2718e865371288caf216fb083c8bd",
"assets/packages/country_flags/res/si/tf.si": "2fdcf8c49f0b17d65aa2601d4b505cfa",
"assets/packages/country_flags/res/si/gh.si": "21e46cb3743f96b4e47de0c0b277c604",
"assets/packages/country_flags/res/si/zm.si": "ef4d9e8828b6609e41642a3fbb6541ec",
"assets/packages/country_flags/res/si/ne.si": "5323700b3b0dc68916ffe048c4afc2b1",
"assets/packages/country_flags/res/si/ae.si": "600a0ce358d82ca58155a6298524084f",
"assets/packages/country_flags/res/si/mr.si": "73d5e7f3158beeb1e09e294cc2cc3b79",
"assets/packages/country_flags/res/si/ls.si": "f469f1632ad300b4fb00db8328f9b844",
"assets/packages/country_flags/res/si/bn.si": "1334a282f886a35989ab2d1fee8b3acc",
"assets/packages/country_flags/res/si/xx.si": "95362a356a59ae95c73b1a7a415abff6",
"assets/packages/country_flags/res/si/hu.si": "379f70d867e53920ef1105ae9d3dc5e1",
"assets/packages/country_flags/res/si/gd.si": "2bd89cc35d9a35aa6b5c7dfa8888e769",
"assets/packages/country_flags/res/si/ea.si": "c59363bf0d9a595df07cfe238f9cc16a",
"assets/packages/country_flags/res/si/jp.si": "ee22ac07312690001d82c27ed0fab0a8",
"assets/packages/country_flags/res/si/ag.si": "f2607a0fcfd1aeecb45e1ea7d17979a0",
"assets/packages/country_flags/res/si/gb-eng.si": "c23da032fa2a18ca5390c2cab903ac80",
"assets/packages/country_flags/res/si/es-ga.si": "c128cec2feffaff7aab7940dadcd9ccd",
"assets/packages/country_flags/res/si/br.si": "dc32cd1c578da0b7106bd15a74434692",
"assets/packages/country_flags/res/si/ru.si": "677089233d82298520fd2b176f8003a8",
"assets/packages/country_flags/res/si/cx.si": "8d7a59ff653f34ab3323c39c5c5b2f75",
"assets/packages/country_flags/res/si/fj.si": "5315abdde8d2a5274a621a7d1fdb92a6",
"assets/packages/country_flags/res/si/py.si": "a05eb3d105fde5507180087464bc282b",
"assets/packages/country_flags/res/si/pe.si": "978e662d337e34163ef3dbc28cf35f11",
"assets/packages/country_flags/res/si/mk.si": "0aee6cc90fb321101c9d4afd923c2d85",
"assets/packages/country_flags/res/si/mv.si": "47d6de70a92bb16bc0284187d12dfb47",
"assets/packages/country_flags/res/si/bh.si": "637d8c9177fdc8bf98d2afb4de3a3cbe",
"assets/packages/country_flags/res/si/gg.si": "57b684be8b0e0fa86e1dae5100f3c0ee",
"assets/packages/country_flags/res/si/fr.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/bl.si": "b319560213233391af1170881595344f",
"assets/packages/country_flags/res/si/am.si": "f1c0decc96d76ecce7dda29e1b0a3048",
"assets/packages/country_flags/res/si/mp.si": "48f591d6c4a1e7aab511bcc750536836",
"assets/packages/country_flags/res/si/cd.si": "092862ef3f988f301bf81d937d0b2251",
"assets/packages/country_flags/res/si/sn.si": "e283672331f67926294d3609b6317d82",
"assets/packages/country_flags/res/si/dj.si": "c39ebb82ae2414d5b42b0c78d7db1626",
"assets/packages/country_flags/res/si/cg.si": "a9df20410076c50e9abbd11b324712c3",
"assets/packages/country_flags/res/si/cz.si": "57831eb560349de7a9274604af4cda4d",
"assets/packages/country_flags/res/si/nr.si": "7762af79a081de69557b7611eaf93bf9",
"assets/packages/country_flags/res/si/bi.si": "4e22a5fa7d3657998c6424ee89ba328f",
"assets/packages/country_flags/res/si/cm.si": "d89b50b2a1e7c5814a53894ddf6842f6",
"assets/packages/country_flags/res/si/sg.si": "3e20b9387970793f6b3db62609820d4a",
"assets/packages/country_flags/res/si/pk.si": "afa64ff88820436b4ec66b1043a1ca7d",
"assets/packages/country_flags/res/si/tm.si": "61cac086e156158fe52394aadb734bd1",
"assets/packages/country_flags/res/si/kn.si": "cd16cb0ce86ecb131422414a132352bb",
"assets/packages/country_flags/res/si/il.si": "5926479ae8ffa09647b9c20feceb9415",
"assets/packages/country_flags/res/si/mx.si": "add64001e4e654f95a36c24e5b212b80",
"assets/packages/country_flags/res/si/ly.si": "b99bf6af3ded37ca4b35c612bfe98721",
"assets/packages/country_flags/res/si/li.si": "08d65db7ba158c62f8b70240985fbbe9",
"assets/packages/country_flags/res/si/wf.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/ca.si": "a911aefa8694f795f4066047492134be",
"assets/packages/country_flags/res/si/md.si": "074b41437a23811d27d4db98bedd56d8",
"assets/packages/country_flags/res/si/cy.si": "f4f95412e75e3e82b62b140f1fb4d327",
"assets/packages/country_flags/res/si/bz.si": "3fad74bf2e5948e1556c8048e65e084e",
"assets/packages/country_flags/res/si/be.si": "6d9dd724fd5dd06b3cff71955bf03728",
"assets/packages/country_flags/res/si/cefta.si": "4a619e7166e3a91fd3333a0aa9a7f212",
"assets/packages/country_flags/res/si/dk.si": "23b9112d01b91326804b173427d0a991",
"assets/packages/country_flags/res/si/gb.si": "b875cc97c8e2a1a41fd3ccbbdb63d291",
"assets/packages/country_flags/res/si/ht.si": "2f82778ff6d4910a677170a08545bfd6",
"assets/packages/country_flags/res/si/et.si": "6020d43892ed1096172d0d01a00afe89",
"assets/packages/country_flags/res/si/mh.si": "88c8196c37481de5021237e01ccb95a1",
"assets/packages/country_flags/res/si/jo.si": "3c4f0683e2fe5e5d9b1424a5865c1e59",
"assets/packages/country_flags/res/si/st.si": "201fdb14910faacd6ce8c30c0a2c1bec",
"assets/packages/country_flags/res/si/mg.si": "f6406a9d332acb29115b31235c49c920",
"assets/packages/country_flags/res/si/yt.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/ie.si": "58082f0739794c2562fbd21b9700a0a9",
"assets/packages/country_flags/res/si/la.si": "161dccf57b198768b6c95fd585966156",
"assets/packages/country_flags/res/si/gt.si": "2841eca17a032575b20e97e3c4c0977e",
"assets/packages/country_flags/res/si/xk.si": "967bec40d36ab8264262777667c5da33",
"assets/packages/country_flags/res/si/sv.si": "912cc0a01ad6e839db6392ece5736b68",
"assets/packages/country_flags/res/si/it.si": "c472c6bc7844cc6633d4e41d139b282c",
"assets/packages/country_flags/res/si/ua.si": "aeb59a31627c7e9cb89c2c31c8b95d15",
"assets/packages/country_flags/res/si/kz.si": "f5aad35a9ce49a2a17f165d4761d8ace",
"assets/packages/country_flags/res/si/cl.si": "1765b8d051900505b51ca7149756b62e",
"assets/packages/country_flags/res/si/gf.si": "5ac3d76ce03f06c4463d135d4129c494",
"assets/packages/country_flags/res/si/sd.si": "c6e5b30fafc73d2d84b45a10c6053568",
"assets/packages/country_flags/res/si/ro.si": "ec81c7e1014f2b8584ddd07d0fad9c43",
"assets/packages/country_flags/res/si/ml.si": "e583b41ed5e4f9508970265999bf47bf",
"assets/packages/country_flags/res/si/km.si": "6cc50d7456a351984bae778298741591",
"assets/packages/country_flags/res/si/az.si": "203fdb6be0df02e0b86e1ab468a84588",
"assets/packages/country_flags/res/si/th.si": "1654e97b82bcdcdaade71e1bc3a5590d",
"assets/packages/country_flags/res/si/ar.si": "4ce98d701be0d5607ec3f0d62e5c7ff8",
"assets/packages/country_flags/res/si/hm.si": "93810e1a767ca77d78fa8d70ef89878a",
"assets/packages/country_flags/res/si/bv.si": "d2e12ff6011d4fc76d0044e61abbd8a1",
"assets/packages/country_flags/res/si/ec.si": "87d4beb1830c8746d02bd3eb81daa1cf",
"assets/packages/country_flags/res/si/sy.si": "744af358ea4a3b27e1ae16c99181dd71",
"assets/packages/country_flags/res/si/iq.si": "a0be6279c1905893dcbcbe0c7ce44302",
"assets/packages/country_flags/res/si/ws.si": "1644f5c199bfc4a5ee49d0907eb26efa",
"assets/packages/country_flags/res/si/so.si": "ee4702222805ec60fe47cca5500fced8",
"assets/packages/country_flags/res/si/rs.si": "f231dce72ce3243a624eb723d200a63e",
"assets/packages/country_flags/res/si/lt.si": "8ef10e2712fa997ca06742fc1d79c095",
"assets/packages/country_flags/res/si/ge.si": "6f700846562325e1e647946a9b7e26f6",
"assets/packages/country_flags/res/si/mw.si": "529e2edb7b4f71261a4d8c52de450f5d",
"assets/packages/country_flags/res/si/lc.si": "981c9cb18294152ac0423aa64039f6e0",
"assets/packages/country_flags/res/si/ye.si": "cc3bd4c5b25155d249015f88380a3023",
"assets/packages/country_flags/res/si/ir.si": "84eb55b574dd390d8fc86b185d182578",
"assets/packages/country_flags/res/si/mz.si": "65389bae62f6de08c93ff93fe61e7b24",
"assets/packages/country_flags/res/si/im.si": "3bca9cb89673cd2c1837c69f72038bde",
"assets/packages/country_flags/res/si/ph.si": "c8899c0eb2232931f49fa35de57f5d09",
"assets/packages/country_flags/res/si/gm.si": "b764f5bed08b62f0c908d224b61c62ce",
"assets/packages/country_flags/res/si/gn.si": "ebb9409ab8449de9d040549ffcef1321",
"assets/packages/country_flags/res/si/mo.si": "4a369319962984183cfed7f0bf4d60a5",
"assets/packages/country_flags/res/si/io.si": "3469f709b852fa25f3d735d4e7ee88a2",
"assets/packages/country_flags/res/si/pn.si": "4df57b8f366ab9d559a134e25fa92201",
"assets/packages/country_flags/res/si/mc.si": "0cb03fed360c4c1401b0e9cff5dea505",
"assets/packages/country_flags/res/si/er.si": "1f32851695ad06a33b607cbfe96cbe5c",
"assets/packages/country_flags/res/si/fo.si": "c074164f5875cc2ac648caa3461a4ffa",
"assets/packages/country_flags/res/si/tg.si": "2a23d4dbc913968f6eb97dbb5454941e",
"assets/packages/country_flags/res/si/dz.si": "74f32a3036da03823454cf8c2fbcc22f",
"assets/packages/country_flags/res/si/sj.si": "04dcac0249ab5999520c35c8e7f3ce38",
"assets/packages/country_flags/res/si/dm.si": "114b039b7de692af992aa75bdfd324d9",
"assets/packages/country_flags/res/si/mt.si": "2c7e94cc8b51a7ce1c1958a00f880398",
"assets/packages/country_flags/res/si/uz.si": "9141032bde5150e86cd2d159c4f31b72",
"assets/packages/country_flags/res/si/bj.si": "e356b737969b4d0413d0d17781f5476f",
"assets/packages/country_flags/res/si/cc.si": "831df80000b0c6d12f0c37f696a11e31",
"assets/packages/country_flags/res/si/sr.si": "c996e0d2b46e4afc13b18a5abe492fe7",
"assets/packages/country_flags/res/si/tj.si": "ff5523df78dbb97dbc212adec3b67a5e",
"assets/packages/country_flags/res/si/es-ct.si": "9d497fc098e8ac8eb94576ca2b72a65a",
"assets/packages/country_flags/res/si/id.si": "9cf3c91fee39a1ff1d93cbbe385d7bbf",
"assets/packages/country_flags/res/si/kp.si": "863f41ba80f1b3f9c794aaeafafb02d6",
"assets/packages/country_flags/res/si/ta.si": "084b17449dd0ba76474f133039ee68d3",
"assets/packages/country_flags/res/si/sa.si": "cf93fcbb04c97fac13136e80fd27ade9",
"assets/packages/country_flags/res/si/ms.si": "e04ef3545afb3927de3aff13640ff6b9",
"assets/packages/country_flags/res/si/eh.si": "99373a71bd21ee4d5ce37dd840fa8bc5",
"assets/packages/country_flags/res/si/hn.si": "bf1d541bc8c0b4826c3cf7f2d36e1b87",
"assets/packages/country_flags/res/si/bs.si": "5818730530c519e134452e41830a7d4b",
"assets/packages/country_flags/res/si/td.si": "7fe532f134f64c198cc8b4feb90efcaf",
"assets/packages/country_flags/res/si/cv.si": "1d61ed1ebf59c2a571f54da09340b52b",
"assets/packages/country_flags/res/si/gb-wls.si": "bb7216967d97426e1d684b2745118f89",
"assets/packages/country_flags/res/si/eg.si": "eb6351aaa487d5e422ecd8f1160ada0d",
"assets/packages/country_flags/res/si/nl.si": "130b5b1f64baa8e002dc668b0d3d589f",
"assets/packages/country_flags/res/si/sz.si": "780a7eb9794bd6cf85d59d42766e62b3",
"assets/packages/country_flags/res/si/nc.si": "8760c0e60c7ab868ea1577de40a8dd04",
"assets/packages/country_flags/res/si/tl.si": "307e25e1507c3e76df867108079cb487",
"assets/CHANGELOG.md": "acd5030c1d009db833182e33a0c5a0a4",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "df9ecd28d4eaae2de30ed20869e8eb98",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/NOTICES": "f8f856cc5807e7c3656fe3987c33a9e3",
"mstile-150x150.png": "d17de0ca88d66ba8a6c0f86fca3c2802",
"favicon-32x32.png": "333e1b61b760cd64439b3babe8602ca1",
"version.json": "3e5b78b9fc7acdbf66d8412aa390df77",
"android-chrome-192x192.png": "1b984fffdb6464fe41f5b0ef9cf51d25",
"apple-touch-icon.png": "e2aab4fb2ff4d0a62aa621bfe2f42c48",
"favicon.ico": "c27b2fceec72f90b71307a026c0a0dca",
"manifest.json": "f80a142437774de2dd1f7029bd3f8be3",
"index.html": "ddf6e8bc4c57ac755e39fe40db9cd86f",
"/": "ddf6e8bc4c57ac755e39fe40db9cd86f",
"flutter.js": "0b19a3d1d54c58174c41cd35acdd9388",
"CNAME": "0c4b89b979854a52bebf59cfc3c04ea4",
"favicon-16x16.png": "ef3125e18ebbde5b14b86b818f013870",
"safari-pinned-tab.svg": "15c4526f1c9b4ef8cdae3ba140e1f42b",
"main.dart.js": "555ede010bc6fdb6f8fe03d5c66dfe8a",
"browserconfig.xml": "a493ba0aa0b8ec8068d786d7248bb92c",
"canvaskit/canvaskit.wasm": "acffb57c88613883935113f62d3f1cef",
"canvaskit/skwasm.wasm": "4e8794ddf4a38d9d979502cced963d9f",
"canvaskit/canvaskit.js": "3bd93dfe6f74ec4261f82b4d4c2c63dc",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/chromium/canvaskit.wasm": "7a1bea507c76779850ab738ff5eb598f",
"canvaskit/chromium/canvaskit.js": "2829bb10a7eb9912e12b452dfd671141",
"canvaskit/skwasm.js": "5256dd3e40ec9fe1fc9faa51a116bcfd"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
