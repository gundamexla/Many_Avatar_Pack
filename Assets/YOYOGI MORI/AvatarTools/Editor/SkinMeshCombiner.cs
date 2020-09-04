using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEditor;

public class SkinMeshCombiner : EditorWindow
{

    struct BlendShape
    {
        public string name;
        public int vertexOffset;
        public List<Vector3> deltaVerticies;
        public List<Vector3> deltaNormals;
        public List<Vector3> deltaTangents;
        
        public BlendShape(string name,List<Vector3> verticies, List<Vector3> normals, List<Vector3> tangents, int vertexOffset)
        {
            this.name = name;
            this.vertexOffset = vertexOffset;
            deltaVerticies = verticies;
            deltaNormals = normals;
            deltaTangents = tangents;
        }
    };

    private GameObject TargetObject;

    [MenuItem("AvatarTools/SkinMeshCombiner")]
    static void Open()
    {
        EditorWindow.GetWindow<SkinMeshCombiner>();
    }

    private void OnGUI()
    {
        GUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("TargetObject");
        TargetObject = EditorGUILayout.ObjectField(TargetObject, typeof(GameObject), true) as GameObject;
        GUILayout.EndHorizontal();

        EditorGUI.BeginDisabledGroup(!TargetObject);
        if (GUILayout.Button("Combine!"))
        {
            if (!Check()) return;
            Combine();
        }
        EditorGUI.EndDisabledGroup();
    }

    private bool Check()
    {
        var skinMeshRendererList = TargetObject.GetComponentsInChildren<SkinnedMeshRenderer>();
        if (!skinMeshRendererList.Any())
        {
            EditorUtility.DisplayDialog("ERROR", "対象のオブジェクトにSkinnedMeshRendererが存在しません。", "OK");
            return false;
        }

        return true;
    }

    private void Combine()
    {
        String objectName = TargetObject.name;


        // 元を壊さないよう複製
        GameObject newObject = Instantiate(TargetObject, new Vector3(3.0f, 0.0f, 0.0f), Quaternion.identity);

        SkinnedMeshRenderer skinnedMesh = newObject.GetComponentInChildren<SkinnedMeshRenderer>();

        Transform rootBone = skinnedMesh.rootBone;

        
        // ボーンリストの取得
        // Hipsオブジェクト以下のボーン構造を全取得
        // ウェイトが入っていないエンプティオブジェクトも関係なしに取得する

        List<Transform> boneList = GetAllChildren.GetAll(skinnedMesh.rootBone.gameObject).Select(e => e.transform).ToList();
        boneList.Insert(0, skinnedMesh.rootBone); // 先頭にHipsボーン追加


        // バインドポーズは事前に生成
        List<Matrix4x4> bindPoseList = new List<Matrix4x4>();
        foreach(var bone in boneList)
        {
            var bindPose = bone.worldToLocalMatrix * skinnedMesh.rootBone.parent.localToWorldMatrix;
            bindPoseList.Add(bindPose);
        }


        // 子オブジェクトからスキンメッシュを持っているオブジェクトのリストを取得
        var skinMeshRendererList = newObject.GetComponentsInChildren<SkinnedMeshRenderer>();

        // クロスコンポーネント持ちは除外する
        skinMeshRendererList = skinMeshRendererList.Where(item => item.gameObject.GetComponent<Cloth>() == null).ToArray();

        List<Material> materialList = new List<Material>(); // マテリアルリスト
        List<Vector3> verticesList = new List<Vector3>(); // 頂点リスト
        List<Vector3> normalsList = new List<Vector3>(); // ノーマルリスト
        List<Vector4> tangentsList = new List<Vector4>(); // タンジェントリスト
        List<Vector2> uvsList = new List<Vector2>(); // UVリスト
        List<BlendShape> blendShapesList = new List<BlendShape>();
        List<List<int>> subMeshList = new List<List<int>>(); // サブメッシュ(三角形)リスト
        List<BoneWeight> boneWeightsList = new List<BoneWeight>(); // ボーンウェイトリスト
        
        

        foreach (var skinMesh in skinMeshRendererList)
        {
            Debug.Log("skinMesh: " + skinMesh.name);

            var srcMesh = skinMesh.sharedMesh;


            // 元のスキンメッシュのボーンインデックスと結合メッシュオブジェクトのボーンインデックスの対応付け
            var boneIndexMatchDictionary = new Dictionary<int, int>();
            for(int i=0;i < skinMesh.bones.Length; ++i)
            {
                Transform srcBone = skinMesh.bones[i];
                var dstBone = boneList.Select((trans, index) => new { trans, index }).Where(e => String.Equals(e.trans.name, srcBone.name)).First();

                boneIndexMatchDictionary.Add(i, dstBone.index);
            }


            // マテリアルリストの更新
            var materialIndexMatchDictionary = new Dictionary<int, int>();

            for (int i = 0; i < skinMesh.sharedMaterials.Length; ++i)
            {
                Material srcMaterial = skinMesh.sharedMaterials[i];
                var targetMat = materialList.Select((mat, index) => new { mat, index }).Where(e => e.mat.Equals(srcMaterial));

                if(!targetMat.Any())
                {
                    // 同一マテリアルが存在しない場合
                    // マテリアルリストに追加
                    materialList.Add(srcMaterial);

                    // サブメッシュリストに新たなサブメッシュを作成する
                    subMeshList.Add(new List<int>());

                    // Srcマテリアルのインデックスと結合メッシュオブジェクトのマテリアルのインデックスの対応
                    materialIndexMatchDictionary.Add(i, materialList.Count()-1);
                    
                }
                else
                {
                    // 同一マテリアルが存在する場合
                    materialIndexMatchDictionary.Add(i, targetMat.First().index);
                }
            }

            // メッシュコピー開始

            int indexOffset = verticesList.Count();

            // 頂点コピー
            foreach(var vertex in srcMesh.vertices)
            {
                verticesList.Add(vertex);
            }

            // ノーマルのコピー
            foreach(var normal in srcMesh.normals)
            {
                normalsList.Add(normal);
            }
            // タンジェントのコピー
            foreach (var tangent in srcMesh.tangents)
            {
                tangentsList.Add(tangent);
            }
            // UV座標のコピー
            foreach (var uv in srcMesh.uv)
            {
                uvsList.Add(uv);
            }

            // blendShapeのコピー
            Debug.Log(srcMesh.blendShapeCount);

            for(int i = 0; i < srcMesh.blendShapeCount; ++i)
            {
                Debug.Log(srcMesh.GetBlendShapeName(i));

                int vertexNum = srcMesh.vertexCount;

                Vector3[] deltaVartices = new Vector3[vertexNum];
                Vector3[] deltaNormals = new Vector3[vertexNum];
                Vector3[] deltaTangets = new Vector3[vertexNum];

                srcMesh.GetBlendShapeFrameVertices(i, 0, deltaVartices, deltaNormals, deltaTangets);
                string blendShapeName = srcMesh.GetBlendShapeName(i);

                BlendShape blendShape = new BlendShape( blendShapeName,deltaVartices.ToList(), deltaNormals.ToList(), deltaTangets.ToList(), indexOffset);

                blendShapesList.Add(blendShape);
            }


            // 三角形インデックスのコピー
            for(int subMeshIndex =0; subMeshIndex < srcMesh.subMeshCount; ++subMeshIndex)
            {
                var triangles = srcMesh.GetTriangles(subMeshIndex);
                foreach(var triangle in triangles)
                {
                    subMeshList[materialIndexMatchDictionary[subMeshIndex]].Add(triangle + indexOffset);
                }
            }

            // ボーンウェイトのコピー
            foreach(var boneWeight in srcMesh.boneWeights)
            {
                BoneWeight weight = new BoneWeight();
                weight.boneIndex0 = boneIndexMatchDictionary[boneWeight.boneIndex0];
                weight.boneIndex1 = boneIndexMatchDictionary[boneWeight.boneIndex1];
                weight.boneIndex2 = boneIndexMatchDictionary[boneWeight.boneIndex2];
                weight.boneIndex3 = boneIndexMatchDictionary[boneWeight.boneIndex3];

                weight.weight0 = boneWeight.weight0;
                weight.weight1 = boneWeight.weight1;
                weight.weight2 = boneWeight.weight2;
                weight.weight3 = boneWeight.weight3;

                boneWeightsList.Add(weight);
            }

            // 参照元のオブジェクトを削除
            GameObject.DestroyImmediate(skinMesh.gameObject);
        }

        // 新たなメッシュを作成
        GameObject generateMeshObject = new GameObject("Body");
        generateMeshObject.transform.parent = newObject.transform;
        generateMeshObject.transform.localPosition = Vector3.zero;

        SkinnedMeshRenderer combinedSkinMesh = generateMeshObject.AddComponent<SkinnedMeshRenderer>();
        Mesh combinedMesh = new Mesh();

        combinedMesh.name = objectName;
        combinedSkinMesh.rootBone = rootBone;
        combinedMesh.RecalculateBounds(); // バウンズは再生成

        combinedMesh.SetVertices(verticesList);
        combinedMesh.SetNormals(normalsList);
        combinedMesh.SetTangents(tangentsList);
        combinedMesh.SetUVs(0,uvsList);

        Debug.Log(subMeshList.Count());

        combinedMesh.subMeshCount = subMeshList.Count();
        for(int i = 0; i < subMeshList.Count(); ++i)
        {
            combinedMesh.SetTriangles(subMeshList[i].ToArray(), i);
            Debug.Log(i + ":" + subMeshList[i].Count());
        }

        // ブレンドシェイプの設定
        foreach(var blendShape in blendShapesList)
        {
            int offset = blendShape.vertexOffset;
            int vertexSize = blendShape.deltaVerticies.Count();

            List<Vector3> deltaVerticies = new List<Vector3>();
            List<Vector3> deltaNormals = new List<Vector3>();
            List<Vector3> deltaTangents = new List<Vector3>();

            for(int i = 0; i < verticesList.Count(); ++i)
            {
                if(i >= offset && i < offset + vertexSize)
                {
                    deltaVerticies.Add(blendShape.deltaVerticies[i - offset]);
                    deltaNormals.Add(blendShape.deltaNormals[i - offset]);
                    deltaTangents.Add(blendShape.deltaTangents[i - offset]);
                }else
                {
                    deltaVerticies.Add(Vector3.zero);
                    deltaNormals.Add(Vector3.zero);
                    deltaTangents.Add(Vector3.zero);
                }
            }

            combinedMesh.AddBlendShapeFrame(blendShape.name, 100, deltaVerticies.ToArray(), deltaNormals.ToArray(), deltaTangents.ToArray());

        }

        combinedMesh.boneWeights = boneWeightsList.ToArray();
        combinedMesh.bindposes = bindPoseList.ToArray();

        combinedSkinMesh.sharedMesh = combinedMesh;
        combinedSkinMesh.sharedMaterials = materialList.ToArray();
       
        combinedSkinMesh.bones = boneList.ToArray(); // 結合スキンメッシュのボーンリストを設定

        AssetDatabase.CreateAsset(combinedMesh, "Assets/" + objectName + ".asset");
        AssetDatabase.SaveAssets();
    }
}
