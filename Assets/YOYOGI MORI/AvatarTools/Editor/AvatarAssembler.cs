/*
    AvatarTools VerEx.0.3.1
    AvatarAssembler

    本スクリプトは作者である 黒鳥様 (twitter: @kurotori4423)の同スクリプトを、
    MIT Licenseに基づき、空々こん(twitter: @kuukuukon)が改変・二次配布を行ったものです。
    ライセンスはオリジナルの MIT Licenseを継承しています。

    オリジナル
    https://kurotori.booth.pm/items/1564788
    AvatarTools Ver.0.2
    制作：黒鳥 様

    改変版
    https://kuukuukon.booth.pm/items/2014610
    AvatarTools VerEx.0.3.1


*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEditor;

using System.Text.RegularExpressions;

public class AvatarAssembler : EditorWindow {

    struct ComponentData
    {
        public List<Component> components;
        public GameObject target;
    };

    // バージョン情報
    private const string version = "VerEx.0.3.1";
    private const string url = "https://kuukuukon.booth.pm/items/2014610";


    private GameObject BaseObject;
    private Vector2 scrollPosition = new Vector2();

    //private List<Transform> BoneList = new List<Transform>();
    private List<GameObject> CombineObjects = new List<GameObject>();
    
    // K2Ex追加設定
    private string AddMatchingWordCombineSide = "";   // Combine側がアバター側のボーン名に別ワードを加えている時に指定する。

    private string savingfolder = "Assets/";

    //GUI制御用(K2Ex)
    private bool foldout1 = false;
    private bool foldout2 = false;

    private Vector2 scrollpos = new Vector2(0,0);
    private Vector2 scrollpos2 = new Vector2(0,0);


    [MenuItem("AvatarTools/AvatarAssembler_K2Ex")]
    static void Open()
    {
        var assembler = EditorWindow.GetWindow<AvatarAssembler>();
    
        // ウィンドウ設定
        assembler.minSize = new Vector2(380,450);
        assembler.maxSize = new Vector2(600,800);

        assembler.Setup();
    }

    public void Setup()
    {
        CombineObjects.Add(null);
    }

    private bool Check()
    {
        var baseObjectAnimator = BaseObject.GetComponent<Animator>();
        if (!baseObjectAnimator)
        {
            EditorUtility.DisplayDialog("ERROR","ベースオブジェクトはモデルデータではありません。", "OK");
            return false;
        }

        var baseSkinnedMesh = BaseObject.GetComponentInChildren<SkinnedMeshRenderer>();
        if(!baseSkinnedMesh)
        {
            EditorUtility.DisplayDialog("ERROR", "ベースオブジェクトにSkinnedMeshRendererが存在しません。", "OK");
            return false;
        }

        var baseRootBone = baseSkinnedMesh.rootBone;
        if(!baseRootBone)
        {
            EditorUtility.DisplayDialog("ERROR", "ベースオブジェクトのRootBoneが存在しません。", "OK");
            return false;
        }

        var checkScalebase = baseRootBone.parent.parent.localScale.x != 1 || baseRootBone.parent.localScale.x != 1;
        if(checkScalebase) {
            int option = EditorUtility.DisplayDialogComplex("ATTENTION",
                BaseObject.name + "の単位Scaleが１ではありません。実行すると失敗する可能性があります。\n\n" +
                "もしBlenderでFBX出力したものでこの問題が出た場合、FBXExportする時の設定の「スケールの適用」を「FBX単位スケール」にする等をしてください。",
                "無視して実行",
                "キャンセル",
                ""
                );
            if(option==1) return false;
        }


        foreach (var combineObject in CombineObjects)
        {
            // アニメーターの有無による衣装のモデルデータ判別を廃止。モデルデータではなかったら下記のチェックでどこかで弾いてくれるはず
            //if(!combineObject.GetComponent<Animator>())
            //{
            //    combineObject.AddComponent<Animator>();
            //    EditorUtility.DisplayDialog("Attention", "衣装には空のAnimatorComponentが必要です\n" + combineObject.name + " に空のAnimatorComponentを\n自動で追加しました。もう一度実行してください。", "OK");
            //    return false;
            //}

            // ところどころ、conbineObject参照すべきところをbaseObjectを参照しているので修正した ↓

            // そのうち、メッシュ無しでDB等のComponentだけ移植とかも出来るようにしたい。そこらへん整えてそのうちこのチェック廃止
            var combineSkinnedMesh = combineObject.GetComponentInChildren<SkinnedMeshRenderer>();
            if (!combineSkinnedMesh)
            {
                EditorUtility.DisplayDialog("ERROR", combineObject.name + "にSkinnedMeshRendererが存在しません。", "OK");
                return false;
             }

            var combineRootBone = combineSkinnedMesh.rootBone;
            if (!combineRootBone)
            {
                EditorUtility.DisplayDialog("ERROR", combineObject.name + "のRootBoneが存在しません。\n\n正しく衣装オブジェクトを指定している場合、SkinnedMeshRendererコンポーネント内のRootBone欄が外れているだけの可能性があります。Hips等を指定してください", "OK");
                return false;
            }

            //combineArmatureの大きさ判定
            var checkScalecomb = combineRootBone.parent.parent.localScale.x != 1 || combineRootBone.parent.localScale.x != 1;
            if(checkScalecomb) {
                int option = EditorUtility.DisplayDialogComplex("ATTENTION",
                    combineObject.name + "の単位Scaleが１ではありません。実行すると失敗する可能性があります。\n\n" +
                    "もしBlenderでFBX出力したものでこの問題が出た場合、FBXExportする時の設定の「スケールの適用」を「FBX単位スケール」にする等をしてください。",

                    "無視して実行",
                    "キャンセル",
                    ""
                    );
                if(option==1) return false;
            }


            //Debug.Log($"PreStartCheck. baseroot is {baseRootBone.name}.  combineroot is {combineRootBone.name}");
            bool Rnamecheck1 = baseRootBone.name+AddMatchingWordCombineSide != combineRootBone.name;
            bool Rnamecheck2 = AddMatchingWordCombineSide+baseRootBone.name != combineRootBone.name;
            if ( Rnamecheck1 && Rnamecheck2 ) // AddMatchingWordCombineSideを付けた状態で一致するか
            {
                //AddMatchingWordCombineSideを付けても一致しなかったパターン。

                var match1 = Regex.Match(combineRootBone.name, @"^" + baseRootBone.name);
                var match2 = Regex.Match(combineRootBone.name, baseRootBone.name + @"$");
                //Debug.Log("比較テスト：" + match2.ToString());

                var namematch1 = baseRootBone.name == match1.ToString();
                var namematch2 = baseRootBone.name == match2.ToString();
                if(namematch1 || namematch2 ) { // 差分抜いたらマッチした場合
                    var sabun = namematch1 ? combineRootBone.name.Remove(0, match1.Length) : combineRootBone.name.Remove(combineRootBone.name.Length - match2.Length);   // 差分格納

                    int option = EditorUtility.DisplayDialogComplex("ATTENTION",
                        combineObject.name + "とBaseオブジェクトのrootBoneの名前が違いますが、名前の差分を差し引くと一致します\n\n" +
                        $"Base: {baseRootBone.name }  Combine: {combineRootBone.name}  差分: {sabun}\n\n" +
                        "差分を差し引いて実行しますか？\n\n" +
                        $"※現在のAddMatchingWordCombineSideの値\n[ {AddMatchingWordCombineSide} ]を[ {sabun} ]に置換",
                        "差し引いて実行",
                        "キャンセル",
                        ""
                        );


                    switch (option)
                    {
                        // 差し引いて実行
                        case 0:
                            AddMatchingWordCombineSide = sabun;
                            break;//return true; ここで返さずに最後まで処理する

                        // キャンセル
                        case 1:
                            return false;

                        // 無視して実行(廃止。さすがに意味がないので。)
                        //case 2:
                        //    return true;

                        default:
                            Debug.LogError("Unrecognized option.");
                            break;
                    }

                }
                else {  // 差分抜いてもマッチしなかった場合
                    EditorUtility.DisplayDialog("ERROR",
                        combineObject.name + "とBaseオブジェクトのボーン命名規則が違うため実行できません。\n" +
                        "Base: " + baseRootBone.name + " | Combine: " + combineRootBone.name, "OK"
                    );
                    return false;
                }

                return false;
            }

        }

        return true;
    }

    private bool CheckCombineObjects()
    {
        if (!CombineObjects.Any()) return false;

        foreach(var combineObject in CombineObjects)
        {
            if (!combineObject) return false;
        }

        return true;
    }

    private void OnGUI()
    {
        scrollpos = GUILayout.BeginScrollView(scrollpos, false, true,  GUILayout.Width(position.width),  GUILayout.Height(position.height-350));
        {
            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("BaseObject");
            BaseObject = EditorGUILayout.ObjectField(BaseObject, typeof(GameObject), true) as GameObject;
            GUILayout.EndHorizontal();

            using (new EditorGUILayout.HorizontalScope())
            {
                EditorGUILayout.LabelField("CombineObjects");
                if (GUILayout.Button("+"))
                {
                    CombineObjects.Add(null);
                }
                EditorGUI.BeginDisabledGroup(!CombineObjects.Any());
                if (GUILayout.Button("-"))
                {
                    CombineObjects.Remove(CombineObjects.Last());
                }
                EditorGUI.EndDisabledGroup();

            }

            for (int i = 0; i < CombineObjects.Count(); ++i)
            {
                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField("CombineObject" + (i+1));
                    CombineObjects[i] = EditorGUILayout.ObjectField(CombineObjects[i], typeof(GameObject), true) as GameObject;
                }
            }

        }
        GUILayout.EndScrollView();


        EditorGUI.BeginDisabledGroup(!CheckCombineObjects() || !BaseObject);
        if (GUILayout.Button("Assemble"))
        {
            if (!Check()) return;
            Assemble();
        }
        EditorGUI.EndDisabledGroup();




        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.Space();

        scrollpos2 = GUILayout.BeginScrollView(scrollpos2, false, false,  GUILayout.Width(position.width),  GUILayout.Height(300));

        EditorGUILayout.LabelField("━━Option━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        EditorGUILayout.Space();
        AddMatchingWordCombineSide = EditorGUILayout.TextField("AddMatchBoneWords",AddMatchingWordCombineSide);
        EditorGUILayout.Space();
        foldout1 = EditorGUILayout.Foldout(foldout1, "説明");
        if(foldout1){
            var mes = "衣装側ボーン名が、「アバター側ボーン名＋定型文」又は「定型文＋アバター側ボーン名」な命名規則のときにここに定型文を指定する。\n" +
            "例1) アバター側Hips で衣装側が Hips_Wear なら↑に「_Wear」指定\n" +
            "例2)衣装側が (seta)Hips なら「(seta)」を指定\n" +
            "※空欄でも自動で判別してくれます";
            EditorGUILayout.HelpBox(mes,MessageType.None);
        }
        EditorGUILayout.Space();
        EditorGUILayout.LabelField("───────────────────────────────────────────────────────────────────────────────────────────────────────────────────");
        EditorGUILayout.Space();


        using (new EditorGUILayout.VerticalScope())
        {

            EditorGUILayout.LabelField("Mesh Output Foloder : " + savingfolder);

            if (GUILayout.Button("Select Output Folder"))
            {
                var path  = EditorUtility.OpenFolderPanel("Select Output Folder", savingfolder, "");
                if (string.IsNullOrEmpty(path)){
                } else {
                    savingfolder = path;
                    var match = Regex.Match(savingfolder, @"Assets/.*");
                    savingfolder = match.Value + "/";
                    if (savingfolder == "/") savingfolder = "Assets/";
                }
            }
            EditorGUILayout.Space();
            foldout2 = EditorGUILayout.Foldout(foldout2, "説明");
            if(foldout2){
                var mes = "ボーンのロール値がアバターと衣装で違う場合、その違いを修正したMeshファイルを複製することがあります。その際にどこに保存するかを指定します。";
                EditorGUILayout.HelpBox(mes,MessageType.None);
            }


        }

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        EditorGUILayout.Space();
        EditorGUILayout.LabelField("Avatar tools K2Ex " + version);
        if (GUILayout.Button("Check WEB to Update")){
            Application.OpenURL(url);
        }

        GUILayout.EndScrollView();
         
        /*
        GUILayout.BeginVertical();
        scrollPosition = GUILayout.BeginScrollView(scrollPosition);

        var tex = EditorGUIUtility.IconContent("PrefabNormal Icon");
        EditorGUIUtility.SetIconSize(new Vector2(16f, 16f));
        for (int i = 0; i < 100; i++)
        {
            GUILayout.BeginHorizontal();
           
            GUILayout.Label(tex, GUILayout.Width(20));
            if (GUILayout.Button("Button", "label")) Debug.Log("Label");
            GUILayout.EndHorizontal();
        }
        EditorGUIUtility.SetIconSize(Vector2.zero);
        GUILayout.EndScrollView();
        GUILayout.EndVertical();
        */
    }

    private void DestroyChild(GameObject gObject)
    {
        foreach (Transform n in gObject.transform)
        {
            GameObject.DestroyImmediate(n.gameObject);
        }
    }

    private List<Transform> GetBoneList(Transform rootBone)
    {
        // ベースボーンからボーンリストを生成
        return GetAllChildren.GetAll(rootBone.gameObject).Select(e => e.transform).ToList();
    }

    private Transform FindBone(GameObject root, string name)
    {
        List<GameObject> list = GetAllChildren.GetAll(root);

        foreach(var child in list)
        {
            if (String.Equals(name, child.name)) return child.transform;
        }
        return null;
    }

    // クロスコンポーネントの転送
    private void ClothComponentTransporter(Cloth cloth, GameObject root, Cloth orignal)
    {
        // カプセルコライダー移植
        var capusuleColliders = cloth.capsuleColliders;

        List<GameObject> objectList = new List<GameObject>();

        GetAllChildren.GetChildren(root, ref objectList);

        List<CapsuleCollider> newList = new List<CapsuleCollider>();

        foreach(var capusuleCollider in capusuleColliders)
        {
            string name = capusuleCollider.gameObject.name;

            var sameObjects = objectList.Where(item => 
                item.name+AddMatchingWordCombineSide == name ||
                AddMatchingWordCombineSide+item.name == name  ||
                item.name == name
            ); // AddMatchingWordCombineSideを追加

            if(sameObjects.Any())
            {
                newList.Add(sameObjects.First().GetComponent<CapsuleCollider>());
            }
        }

        cloth.capsuleColliders = newList.ToArray();
    

        //球体コライダー移植
        var sphereColliders = cloth.sphereColliders;

        List<ClothSphereColliderPair> newListS = new List<ClothSphereColliderPair>();

        foreach(var sphereCollider in sphereColliders)
        {
            string namefirst = sphereCollider.first.gameObject.name;
            string namesecond = sphereCollider.second.gameObject.name;

            var sameObjectsfirst = objectList.Where(item =>
                item.name+AddMatchingWordCombineSide == namefirst ||
                AddMatchingWordCombineSide+item.name == namefirst ||
                item.name == namefirst
            ); // AddMatchingWordCombineSideを追加
            var sameObjectssecond = objectList.Where(item =>
                item.name+AddMatchingWordCombineSide == namesecond ||
                AddMatchingWordCombineSide+item.name == namesecond ||
                item.name == namesecond
            ); // AddMatchingWordCombineSideを追加

            var cscp = new ClothSphereColliderPair(); 
            if(sameObjectsfirst.Any())
            {
                cscp.first = sameObjectsfirst.First().GetComponent<SphereCollider>();
            }
            if(sameObjectssecond.Any())
            {
                cscp.second = sameObjectssecond.First().GetComponent<SphereCollider>();
            }
            newListS.Add(cscp);
        }

        cloth.sphereColliders = newListS.ToArray();



        //CCBR式ウェイトコピー
        var coefficients = cloth.coefficients;
        var originalcoefficients = orignal.coefficients;
        if(originalcoefficients.Length == coefficients.Length) {
            for(int i=0, il=originalcoefficients.Length; i<il; ++i ){
                coefficients[i].collisionSphereDistance = originalcoefficients[i].collisionSphereDistance;
                coefficients[i].maxDistance = originalcoefficients[i].maxDistance;
            }
            cloth.coefficients = coefficients;
        } else Debug.LogError("Clothコピーの際にメッシュの頂点数が一致しませんでした。When copying cloth, the number of mesh vertices did not match.");


        // 他のParameterは複製時のParameter生成で問題ないハズ


    }


/*
// List全表示用デバック関数
    private void ShowListContentsInTheDebugLog<T>(List<T> list)
    {
        string log = "";

        foreach(var content in list.Select((val, idx) => new {val, idx}))
        {
            if (content.idx == list.Count - 1)
                log += content.val.ToString();
            else
                log += content.val.ToString() + ", ";
        }

        Debug.Log(log);
    }
*/


    private void Assemble()
    {
        // スタードデバッグログ
        //Debug.Log("Start Assemble");
        //Debug.Log("AddWord :" + AddMatchingWordCombineSide);

        List<Transform> BoneList = new List<Transform>();
        // ベースオブジェクトの複製
        GameObject newBase = Instantiate(BaseObject, new Vector3(2.0f, 0.0f, 0.0f), Quaternion.identity);
        
        {
            // ベースオブジェクトからRootであるボーンを検索
            var baseSkinnedMesh = newBase.GetComponentInChildren<SkinnedMeshRenderer>();
            var rootBone = baseSkinnedMesh.rootBone; //FindBone(newBase, "Hips");

            //Debug.Log("rootBone:" + rootBone);

            // ボーンリストを生成
            BoneList = GetBoneList(rootBone);
            BoneList.Insert(0, rootBone); // 先頭にRootボーン追加
            //BoneList.Insert(0,rootBone.parent); // さらに先頭にArmtureを追加　これをしないとArmatureにコンポーネントがついていた場合に取得できない。が、気にするほどでもないか？
        }

        //ShowListContentsInTheDebugLog<Transform>(BoneList);

        List<ComponentData> componentDataList = new List<ComponentData>();

        foreach (var combineObject in CombineObjects)
        {

            List<Transform> combineBonesList = new List<Transform>();
            {
                // 結合オブジェクトからRootであるボーンを検索
                Transform rootBone;
                var combineSkinnedMesh = combineObject.GetComponentInChildren<SkinnedMeshRenderer>();
                if(combineSkinnedMesh){ // スキニードメッシュRendererがあったら
                    rootBone = combineSkinnedMesh.rootBone;
                } else {    // 無かったら
                    rootBone = FindBone(combineObject, "Hips");
                }

                // 結合ボーンリストを作成
                combineBonesList = GetBoneList(rootBone);
                combineBonesList.Insert(0,rootBone);      // Base同様、Rootボーンをリストに含ませる。無かった。
                //combineBonesList.Insert(0,rootBone.parent);       // Armatureを含めるかどうか

                //Debug.Log("Conbine RootBone:" + rootBone.name);
                //Debug.Log("ListFirst:" + combineBonesList.First());
                //ShowListContentsInTheDebugLog<Transform>(combineBonesList);
            }
            // ベースボーンリストにボーンを追加していく
            foreach (var combineBone in combineBonesList)
            {
                // ベースボーンから同名のボーンを検索する
                var sameBone = BoneList.Where(e =>
                    e.name+AddMatchingWordCombineSide == combineBone.name ||
                    AddMatchingWordCombineSide+e.name == combineBone.name ||
                    e.name == combineBone.name
                ); // AddMatchingWordCombineSide を追加した

                if (!sameBone.Any())
                {
                    // 同名のボーンが存在しない場合

                    // 親ボーンを検索する
                    var parentName = combineBone.parent.name;
                    //Debug.Log("Bonename:"+combineBone.name);
                    //Debug.Log("Parentname:"+parentName);
                    var targetParent = BoneList.Select((trans, index) => new { trans, index }).Where(e =>
                        e.trans.name+AddMatchingWordCombineSide == parentName ||
                        AddMatchingWordCombineSide+e.trans.name == parentName ||
                        e.trans.name == parentName
                    );//AddMatchingWordCombineSideを追加
                

                    if (targetParent.Any())
                    {
                        // オブジェクトを追加する
                        //var boneObject = Instantiate(combineBone.gameObject, targetParent.First().trans);   // ここでコンポーネントごとコピーされる？しかし正常にはされてない様子
                        var boneObject = new GameObject(combineBone.name);  //空っぽから生成する

                        //boneObject.name = combineBone.name;
                        boneObject.transform.parent = targetParent.First().trans;   // 親子関係設定
                        //DestroyChild(boneObject); // 不要な子オブジェクトを削除する
                        //Debug.Log("NewAddedbone:" + boneObject.gameObject.name);

                        // ローカルトランスフォームをそろえる
                        boneObject.transform.localPosition = combineBone.localPosition;
                        boneObject.transform.localRotation = combineBone.localRotation;
                        boneObject.transform.localScale = combineBone.localScale;


                        // 親ボーンを発見した場合
                        // 必ず親ボーンの後に挿入されるようにする。
                        BoneList.Insert(targetParent.First().index + 1, boneObject.transform);
                        // コンポーネントの上書き処理用スタック
                        ComponentData componentData;
                        var components = combineBone.gameObject.GetComponents<Component>();

                        componentData.target = boneObject;
                        componentData.components = components.ToList();
                        componentDataList.Add(componentData);
                        // コンポーネントを正規のコピペする。追加式。
                        foreach(var compdata in componentData.components){
                            if(compdata.GetType()==typeof(Transform)) continue;//Transformの追加をスキップする（スキップしなくても２重にはならないぽい
                            UnityEditorInternal.ComponentUtility.CopyComponent(compdata);
                            UnityEditorInternal.ComponentUtility.PasteComponentAsNew(boneObject);
                        }

                    }
                    else
                    {
                        Debug.LogError("Parent not found. : " + parentName);
                    }
                }
                else
                {
                    // 同名のボーンが存在した場合
                    // コンポーネントの上書き処理用スタック
                    ComponentData componentData;
                    var components = combineBone.gameObject.GetComponents<Component>();

                    //コンポチェック(デバッグログ表示)
                    /*
                    string debugstring = "" + combineBone.name + ":";
                    foreach(var comp in components){
                        debugstring += comp.GetType() +" , ";
                    }
                    Debug.Log(debugstring);
                    */
                   
                    componentData.target = sameBone.First().gameObject;
                    componentData.components = components.ToList();
                    componentDataList.Add(componentData);
                    // この段階ではまたコピーを行っていない？
                    //同名ボーンが無かったときはコンポごとオブジェコピーされたがここではされてないので書き込む。追加扱い。DBかつ同名ターゲットだった場合のみ上書き

                    // 先にBese側ダイナミックボーンリストを取得
                    var basedblist = componentData.target.GetComponents<DynamicBone>().ToList();

                    foreach(var compdata in componentData.components){
                        UnityEditorInternal.ComponentUtility.CopyComponent(compdata);
                        if( compdata is DynamicBone ) { // DBだったら
                            var combdb = compdata as DynamicBone;
                            // Rootが同じDBを探索
                            var samebasedbs = basedblist.Where( val =>
                                val.m_Root.name+AddMatchingWordCombineSide == combdb.m_Root.name ||
                                AddMatchingWordCombineSide+val.m_Root.name == combdb.m_Root.name ||
                                val.m_Root.name == combdb.m_Root.name
                            );
                            if(samebasedbs.Any()) { // 同じものがあれば 値を上書き　同名のものは他にはない前提で処理をする。
                                UnityEditorInternal.ComponentUtility.PasteComponentValues(samebasedbs.First());                            
                            }
                            else { // 同じものが無かった
                                UnityEditorInternal.ComponentUtility.PasteComponentAsNew(componentData.target);                            
                            }

                        }
                        else if( compdata is DynamicBoneColliderBase ){     // DBコライダーだったら
                            var combdbc = compdata as DynamicBoneColliderBase;
                            // Bese側にDBコライダーがないかチェック。あったら問答無用で上書きする
                            var basedbc = componentData.target.GetComponent<DynamicBoneColliderBase>(); // １つしかない前提で処理する。
                            if(basedbc){//存在したら
                                UnityEditorInternal.ComponentUtility.PasteComponentValues(basedbc);//上書き
                            } else {
                                UnityEditorInternal.ComponentUtility.PasteComponentAsNew(componentData.target);//追加
                            }

                        }
                        else {  // その他だったら
                            UnityEditorInternal.ComponentUtility.PasteComponentAsNew(componentData.target);
                        }
                    }


                    
                    //Debug.Log("Over,"+componentData.target.name);
                }
            }

            List<GameObject> objectList = GetAllChildren.GetAll(newBase);
            //ShowListContentsInTheDebugLog<GameObject>(objectList);

            // コンポーネントの新規 ・・・はない。Dynamicボーンの更新のみ
            foreach (var componentData in componentDataList)
            {
                var components = componentData.components;
                //Debug.Log("componetDataTargetName:"+componentData.target.name + "-------------------------------------------------------");

                //base側コンポーネント配列
                List<DynamicBone> basecomps = componentData.target.GetComponents<DynamicBone>().ToList();
                //                          ↑の旧配置場所は下のforeachの中かつ「GetComponent」だったため、
                //                          １つのオブジェにDBが複数あっても１つめのDBにしか処理できずにバグが発生していた。


                //foreach(var component in components)
                foreach(var basecomp in basecomps)
                {
                    var type = basecomp.GetType();
                    //Debug.Log("typeof:"+ type);
                    if (type == typeof(DynamicBone))
                    {
                        //Debug.Log("ProcessingIn:"+ type);

                        DynamicBone basedynamicBone = basecomp as DynamicBone;

                        //if(!copy) {   コンポーネントは前段階ですべてすでにコピーされているのでチェック及び追加処理は削除
                        //    copy = componentData.target.AddComponent<DynamicBone>();
                        //    Debug.Log("DynamicBone Notting. Adding");
                        //} else Debug.Log("DynamicBone is Ready");

                        basedynamicBone.m_Root = BoneList.Where(item =>
                            item.name+AddMatchingWordCombineSide == basedynamicBone.m_Root.name ||
                            AddMatchingWordCombineSide+item.name == basedynamicBone.m_Root.name ||
                            item.name == basedynamicBone.m_Root.name
                        ).First();// AddMatchingWordCombineSideを追加
                        //Debug.Log("RootBone:"+basedynamicBone.m_Root + "----------------------");

                        // コライダーリスト処理
                        var colliders = basedynamicBone.m_Colliders;
                        var newColliders = new List<DynamicBoneColliderBase>();
                        foreach(var collider in colliders)
                        {
                            //Debug.Log("OrignalDBCname:"+collider);
                            var sameObject = objectList.Where(item =>
                                item.name+AddMatchingWordCombineSide == collider.name ||
                                AddMatchingWordCombineSide+item.name == collider.name ||
                                item.name == collider.name
                            );  // AddMatchingWordCombineSideを追加
                            //Debug.Log("SameObject is :" + sameObject.First());
                            if(sameObject.Any())
                            {
                                newColliders.Add(sameObject.First().GetComponent<DynamicBoneColliderBase>());
                                //Debug.Log("SameObjectmatch:Yes : coll:"+newColliders.Last() + "  , data:" +collider.GetComponent<DynamicBoneColliderBase>());// ここで一部検出できないものがある。
                            }// else Debug.Log("SameObjectmatch:No");
                        }
                        //Debug.Log("DBCCount:"+colliders.Count);
                        basedynamicBone.m_Colliders = newColliders;

                        // 除外リスト処理
                        var exclusions = basedynamicBone.m_Exclusions;
                        var newExclusions = new List<Transform>();
                        foreach(var exclusion in exclusions)
                        {
                            var sameObject = objectList.Where(item =>
                                item.name+AddMatchingWordCombineSide == exclusion.name ||
                                AddMatchingWordCombineSide+item.name == exclusion.name ||
                                item.name == exclusion.name
                            ); // AddMatchingWordCombineSideを追加
                            if(sameObject.Any())
                            {
                                newExclusions.Add(sameObject.First().transform);
                            }
                        }
                        basedynamicBone.m_Exclusions = newExclusions;


/*                      // ここらはすでにコピーされている
                        copy.m_Damping = dynamicBone.m_Damping;
                        copy.m_DampingDistrib = dynamicBone.m_DampingDistrib;
                        copy.m_DistanceToObject = dynamicBone.m_DistanceToObject;
                        copy.m_DistantDisable = dynamicBone.m_DistantDisable;
                        copy.m_Elasticity = dynamicBone.m_Elasticity;
                        copy.m_ElasticityDistrib = dynamicBone.m_ElasticityDistrib;
                        copy.m_EndLength = dynamicBone.m_EndLength;
                        copy.m_EndOffset = dynamicBone.m_EndOffset;
                        copy.m_Force = dynamicBone.m_Force;
                        copy.m_FreezeAxis = dynamicBone.m_FreezeAxis;
                        copy.m_Gravity = dynamicBone.m_Gravity;
                        copy.m_Inert = dynamicBone.m_Inert;
                        copy.m_InertDistrib = dynamicBone.m_InertDistrib;
                        copy.m_Radius = dynamicBone.m_Radius;
                        copy.m_RadiusDistrib = dynamicBone.m_RadiusDistrib;
                        //copy.m_ReferenceObject = dynamicBone.m_ReferenceObject;
                        copy.m_Stiffness = dynamicBone.m_Stiffness;
                        copy.m_StiffnessDistrib = dynamicBone.m_StiffnessDistrib;
                        copy.m_UpdateMode = dynamicBone.m_UpdateMode;
                        copy.m_UpdateRate = dynamicBone.m_UpdateRate;
*/
                    }


                }

            }

            componentDataList.Clear();



            // 下のメッシュ移植を、アバタールート直下のメッシュ以外のオブジェでも移植するようにしたい。

            // メッシュのボーンリスト情報の更新
            var CombineMeshs = combineObject.GetComponentsInChildren<SkinnedMeshRenderer>();
            foreach (var mesh in CombineMeshs)
            {
                //Debug.Log("Meshname:" + mesh.gameObject.name);
                var combinedMesh = Instantiate(mesh.gameObject);
                combinedMesh.name = mesh.gameObject.name;
                combinedMesh.transform.SetParent(newBase.transform);

                combinedMesh.transform.localPosition = mesh.gameObject.transform.localPosition;
                combinedMesh.transform.localRotation = mesh.gameObject.transform.localRotation;
                combinedMesh.transform.localScale = mesh.gameObject.transform.localScale;

                var skinnedMesh = combinedMesh.GetComponent<SkinnedMeshRenderer>();
                skinnedMesh.sharedMesh = mesh.sharedMesh;


                //ボーンウェイトから実際に使っているボーンのインデックスを列挙し、以下のバインドポーズ処理時にローテンション不一致ボーンがあっても、列挙外であれば無視する
                //var boneweight = new List<BoneWeight>();
                var usebone = new List<int>();
                foreach(var boneweight in skinnedMesh.sharedMesh.boneWeights.ToList()){
                    if(!(usebone.Where(val => val == boneweight.boneIndex0).Any()) && boneweight.weight0 != 0.0) usebone.Add(boneweight.boneIndex0);
                    if(!(usebone.Where(val => val == boneweight.boneIndex1).Any()) && boneweight.weight1 != 0.0) usebone.Add(boneweight.boneIndex1);
                    if(!(usebone.Where(val => val == boneweight.boneIndex2).Any()) && boneweight.weight2 != 0.0) usebone.Add(boneweight.boneIndex2);
                    if(!(usebone.Where(val => val == boneweight.boneIndex3).Any()) && boneweight.weight3 != 0.0) usebone.Add(boneweight.boneIndex3);
                }
                //Debug.Log("useing bone list");
                //ShowListContentsInTheDebugLog<int>(usebone);




                // バインドポーズ処理
                int i = 0;
                bool isNomatch = false;
                List<Transform> bones = new List<Transform>();
                List<Matrix4x4> lbindpose = new List<Matrix4x4>();
                foreach (var bone in skinnedMesh.bones)
                {
                    var target = BoneList.Where(e =>
                        e.name+AddMatchingWordCombineSide == bone.name ||
                        AddMatchingWordCombineSide+e.name == bone.name ||
                        e.name == bone.name
                    ).First();// AddMatchingWordCombineSideを追加
                    bones.Add(target);
                    // ここでボーンの回転違いがあればBonePoseを補正する
                    if(target.transform.localRotation != bone.transform.localRotation) {
                        //Debug.Log("name:" + target.name + ".  TransT:" + target.transform.localRotation + ".  TransB:" + bone.transform.localRotation);
                        //Debug.Log("name:" + target.name + ".  ScaleT:" + target.transform.localScale + ".  ScaleB:" + bone.transform.localScale);
                        lbindpose.Add(target.transform.worldToLocalMatrix * combinedMesh.transform.localToWorldMatrix);
                        //isNomatch = true;// 一つでも一致しないボーンローテーションがあった
                        if(usebone.Where( val => val == i).Any()) {
                            //Debug.Log(""+ target.name + " is usebone");
                            isNomatch = true; // ボーンウェイトで実際につかわれてるボーンだったらtrueへ　これで不要な複製回避しないと、一部のメッシュが異常複製する。謎。謎of謎
                        } else {
                            //Debug.Log(""+ target.name + " is Notusebone");
                        }

                    } else { // 同じ場合
                        lbindpose.Add(target.transform.worldToLocalMatrix * combinedMesh.transform.localToWorldMatrix);
                    }
                    // ローテーション違いがあったものだけ計算し直せばいいので↑の行は全てにおいて計算しなおしていて無駄だけども、気にするほどでもない
                    //Debug.Log("bone:"+bone.name+"("+i+")     , matrix:"+ lbindpose + "("+lbindpose.Count+")");
                    ++i;
                }




                // 1つでも一致しないボーンローテーションがあったらmeshを複製する
                if(isNomatch){
                    var newmesh = Instantiate(mesh.sharedMesh);
                    var newname = mesh.sharedMesh.name + "_AA";
                    var folderpath = savingfolder;//"Assets/";

                    // 複製物への変更内容
                    newmesh.bindposes = lbindpose.ToArray();

                    // セーブ
                    AssetDatabase.CreateAsset(newmesh, AssetDatabase.GenerateUniqueAssetPath(folderpath + newname + ".asset"));
                    AssetDatabase.SaveAssets();

                    // 複製したメッシュに置き換え
                    skinnedMesh.sharedMesh = newmesh;
                }

                skinnedMesh.bones = bones.ToArray();
                skinnedMesh.rootBone = BoneList.First();

                if(skinnedMesh.probeAnchor) {
                    var probeanker = BoneList.Where(e =>
                        e.name+AddMatchingWordCombineSide == skinnedMesh.probeAnchor.gameObject.name ||
                        AddMatchingWordCombineSide+e.name == skinnedMesh.probeAnchor.gameObject.name ||
                        e.name == skinnedMesh.probeAnchor.gameObject.name
                    );
                    if(probeanker.Any()) skinnedMesh.probeAnchor = probeanker.First();// else skinnedMesh.probeAnchor = null;
                // ProbeAnkerは全部Base側のHipsにしちゃっていいんでなかろうか。とはいえ、Baseのほうのアンカーはいじっていないので統一できないのが悩ましい
                }

/*
                // 複製されたメッシュのボーンリストを確認。順番はあっている
                var conblist = mesh.bones.ToList();
                var origlist = skinnedMesh.bones.ToList();

                string log = "複製先とオリジナルのボーンリスト順列チェック\n";

                foreach(var content in origlist.Select((val, idx) => new {val, idx}))
                {
                    log += conblist.ElementAt(content.idx) + "\t\t" + content.val.ToString() + ",\n";
                }

                Debug.Log(log + "\n Count: " + conblist.Count + " , " + origlist.Count);
*/


                var cloth = combinedMesh.GetComponent<Cloth>();
                if(cloth)
                {
                    ClothComponentTransporter(cloth, newBase, mesh.gameObject.GetComponent<Cloth>());
                }

            }
        }
    }

}
