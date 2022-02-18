using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

[ExecuteAlways]
public class PostProcess_Twist : MonoBehaviour
{
    [SerializeField] private Material postProcessTwistMaterial;
    private Camera _camera;
    
    public float TransitionValue
    {
        get => postProcessTwistMaterial.GetFloat("_Transition");
        set => postProcessTwistMaterial.SetFloat("_Transition", value);
    }


    private void OnEnable() 
    {
        _camera = GetComponent<Camera>();
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, postProcessTwistMaterial);
    }


    [ContextMenu("Clear Camera")]
    public void ClearCamera()
    {
        _camera.targetTexture = null;
    }

    [ContextMenu("Save Current Render As Overlay Texture")]
    public void SaveCurrentRenderAsOverlayTexure()
    {
        RenderTexture rt = new RenderTexture(_camera.scaledPixelWidth, _camera.scaledPixelHeight, 16);
        _camera.targetTexture = rt;
        _camera.Render();
        ClearCamera();

        SetOverlayTexture(rt);
        Debug.Log("texture stored as overlay texture");
    }

    public void SetOverlayTexture(Texture texture)
    {
        postProcessTwistMaterial.SetTexture("_OverlayTex", texture);
    }

}
