AvatarTools VerEx.0.3.2

本スクリプトは原作者である 黒鳥様 (twitter: @kurotori4423)が
公開されているAvatarTools(アバター着せ替えスクリプト)を、
MIT Licenseに基づき、空々こん(twitter: @kuukuukon)が改変・二次配布を行ったものです。

オリジナル
AvatarTools Ver.0.2
制作・権利者：黒鳥 様
https://kurotori.booth.pm/items/1564788

改変版
AvatarTools VerEx.0.3.2
https://kuukuukon.booth.pm/items/2014610

～前提・必須条件～
Unity
DynamicBone(UnityAssetsStore) （コンポーネント移植のために内部的に参照しています。


～概要～
3Dアバターの着せ替えツールである「AvatarTools Ver.0.2」をベースに、
様々な不具合修正と機能追加を行った改変データです。

AvatarToolsに含まれている「AvatarAssembler」は、
対象となるアバターモデルと、同じボーン構造をもったそのアバター(素体)専用衣装を結合するツールです。
衣装のメッシュの対応するボーンそのものをアバターの物に置き換える、大変スマートなツールです。
基本的な使い方等詳しくはオリジナルのページを参照してください。

改変版である「AvatarTools VerEx.0.3」は、
不具合修正に加えて、以下の機能を追加しています。

～AvatarAssembler～
・ボーンロールがアバターを違う衣装ボーンでも問題なく移植できます。
　（オリジナル版で移植すると足先や胸、その他特定部位がねじれてしまうことがある症状がなくなります）
　この機能はMeshファイルを書き換える必要があるため、ファイルを複製する処理が入ることがあります。

・アバターボーン名と衣装ボーン名が違っていても、
　衣装側が「基本ボーン名+定型文」又は「定型文＋基本ボーン名」な命名規則なら問題なく移植できます。
　（例。アバター側がHips で、衣装側が「Hips_Wear」や「(seta)Hips」等でも移植可能。

～SkinMeshCombiner～
・こちらは変更点も修正も有りません。完全にオリジナルと同一です。

=====更新履歴=====
==VerEx.0.3.2 (2020/05/01) ==
●AvatarAssembler
　○仕様変更
　　・単位スケールが１ではないデータを扱う場合は警告文を発するように。だけ。

==VerEx.0.3.1 (2020/04/28) ==
●AvatarAssembler
　○仕様変更
　　・DynamicBoneが移植される際、移植先のボーンに
　　　同じRootBoneを持つDynamicBoneがある場合、追加ではなく上書き処理をする。
　　　また、DynamicBoneコライダーを移植する際に移植先ボーンにすでにあれば無条件で上書きする。
　　　この仕様変更は例えば、アバター側の胸にすでにDBがあるのに衣装側胸にもDBがついてる場合に
　　　適切に処理されるようになる。ただし同じ場所に付けてくれていた場合に限る。

　　・名前差分を差し引いて実行するかを聞くウィンドウにある「無視して実行」を廃止して実行不可に。


==VerEx.0.3 (2020/04/27 新規配布) ==
●AvatarAssembler のオリジナルとの変更点
　○不具合修正
　　・アバター側と衣装側のボーンロール値が違うと正常に移植できない不具合(仕様)の修正
　　　（既存のもので移植すると衣装が一部、謎のひねりが発生することがあるのが治った）
　　・ボーンとメッシュ（頂点ウェイト）の対応にズレがあったのを修正
　　・メッシュやダイナミックボーンやクロスの移植での、オブジェクト参照が失敗している不具合の修正
　　・その他、内部的な不具合の修正
　○追加要素
　　・アバター側と衣装側のボーンロール値が違っていても正常に移植できるように。
　　・アバター側と衣装側のボーン名が違っていても
　　　衣装側が「基本ボーン名+定型文」又は「定型文＋基本ボーン名」な命名規則なら
　　　移植が可能に。


●SkinMeshCombiner についてはオリジナルとの変更点は無し。同一です。

==VerEx.0.3.1 (2020/04/28) ==
●AvatarAssembler
　○仕様変更
　　・DynamicBoneが移植される際、移植先のボーンに
　　　同じRootBoneを持つDynamicBoneがある場合、追加ではなく上書き処理をする。
　　　また、DynamicBoneコライダーを移植する際に移植先ボーンにすでにあれば無条件で上書きする。
　　　この仕様変更は例えば、アバター側の胸にすでにDBがあるのに衣装側胸にもDBがついてる場合に
　　　適切に処理されるようになる。ただし同じ場所に付けてくれていた場合に限る。

　　・名前差分を差し引いて実行するかを聞くウィンドウにある「無視して実行」を廃止して実行不可に。



～既知の問題(そのうち修正する)～
・Blender2.7系を通したFBXは、BlenderでExportする際に必ず設定で「スケールを適用」「FBX単位スケール」にして出力すること。
（特にQuicheちゃん等は単位が違う）
これを設定しないと正常に機能しない

・モデルのルート階層やArmature階層に置かれているSkinnedMeshRendererのついていないObjectは認識されない（コライダーオブジェとか。MeshRendererもだめ）
※この理由により本ショップのワンピースドレスは本ツールだと完全には移植できません。

・ConstraintやJoint系コンポーネントのオブジェクト参照の置き換え機能はまだない
（上記の問題と合わさってここらは手動でやる必要が高い）

・オリジナル版にあった、ダイナミックボーン無し版は本改変版ではありません。
DynamicBone(Asset)が必須です。

・帽子のHeadボーンなど、場合によってはずらして使用したい場合でも修正することが出来ない（反映されない）。
現状では、そういった衣装メッシュ部位だけ、手動のボーン移植方式を使用してください。

・アバター・衣装側両方ともに、ボーンのルート位置を、SkinnedMeshRendererのRootBoneの項目を参照して得ているので、もしこのRootBoneの項目を初期値「Hips」系から変更してる場合、機能しなくなります。
初期値に戻してからご利用ください。（このRootBoneの項目は本来、Boundsが追従するボーンを指定するためにある。実はボーンのルートを指定するものではなかったりする）



～免責事項～
このプログラムを使用したことによる不具合や損害については空々こん(kuukuukon)は一切の責任を持ちません。

～ライセンス～
---------------------------------------------------------------------------------------

Released under the MIT License (https://opensource.org/licenses/mit-license.php)

Copyright (c) 2019 Kurotori

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.