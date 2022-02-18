using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(PostProcess_Twist))]
public class PostProcess_TwistEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        PostProcess_Twist instance = target as PostProcess_Twist;

        EditorGUI.BeginChangeCheck();
        float result = EditorGUILayout.Slider("Transition", instance.TransitionValue, 0, 1);
        if(EditorGUI.EndChangeCheck())
        {
            instance.TransitionValue = result;
        }

        if(GUILayout.Button("Save Current Render As Overlay Texture"))
        {
            instance.SaveCurrentRenderAsOverlayTexure();
        }
    }
}