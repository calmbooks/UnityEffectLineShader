using UnityEngine;
using System.Collections;

public class GruGru : MonoBehaviour {

    [SerializeField]
    Material grugruMat;

    void OnRenderImage ( RenderTexture src, RenderTexture dest ) {

        grugruMat.SetTexture("_TEX", src);
        Graphics.Blit(src, dest, grugruMat);
    }
}
