using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace DroneSim.Editor
{
    public static class EnvironmentInfo
    {
        [MenuItem("DroneSim/Environment Info")]
        public static void Log()
        {
            var pipeline = GraphicsSettings.currentRenderPipeline;
            string pipelineName = pipeline != null ? pipeline.GetType().Name : "Built-in";
            Debug.Log(
                $"Unity {Application.unityVersion} | fixed timestep {Time.fixedDeltaTime} s " +
                $"({1.0 / Time.fixedDeltaTime:F0} Hz) | render pipeline {pipelineName}");
        }
    }
}
