using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ShadowPlanarPostFx : MonoBehaviour {
	public Shader stencilInterpolateShader;
	public Camera cam = null;
	public Light shadowLight;
	public Color shadowColor;
	public GameObject plane;
	[SerializeField]
	protected int layer;
	
	private Mesh quadMesh;

	private Material stencilInterpolateMat;


	void Start() {

		if (!shadowLight) {
			Debug.LogWarning ("no shadow casting light set, disabling script");
			this.enabled = false;
			return;
		}

		if(cam == null)
		{
			Debug.LogWarning("camera must be set in order to achieve best performance");
		}

		if(stencilInterpolateMat == null)
		{
			stencilInterpolateMat = new Material(stencilInterpolateShader);
			stencilInterpolateMat.hideFlags = HideFlags.HideAndDontSave;
		}

		CreateQuadMesh();
	}

	protected void CreateQuadMesh()
	{
		if (quadMesh == null)
		{
			// Create quad vertices and triangles
			Vector3[] vertices =
			{
				new Vector3(-1.0f, 1.0f, 0.0f),
				new Vector3(1.0f, 1.0f, 0.0f),
				new Vector3(-1.0f, -1.0f, 0.0f),
				new Vector3(1.0f, -1.0f, 0.0f)
			};
			
			int[] triangles =
			{
				0, 1, 2,
				2, 1, 3
			};
			
			// Create the quad mesh
			Mesh mesh = new Mesh();
			
			mesh.name = "Quad Mesh";
			mesh.vertices = vertices;
			mesh.triangles = triangles;
			mesh.bounds = new Bounds(Vector3.zero, Vector3.one * float.MaxValue);
			
			quadMesh = mesh;
		}
	}

	void Update()
	{
		DrawShadow();
		UpdateLightDir();
	}

	void DrawShadow()
	{
		// Dont need to clear stencil buffer manually. Unity do it with clear flag option of camera.
		Graphics.DrawMesh(quadMesh, Vector3.zero, Quaternion.identity, stencilInterpolateMat, layer, cam, 0, null, false, false);
	}

	void UpdateLightDir()
	{
		Vector4 source;
		if(shadowLight != null)
		{
			if (shadowLight.type == LightType.Directional)
			{
				Vector3 direction = shadowLight.transform.forward;
				source = new Vector4(direction.x, direction.y, direction.z, 0.0f);
			}
			else
			{
				Vector3 position = shadowLight.transform.position;
				source = new Vector4(position.x, position.y, position.z, 1.0f);
			}
			Shader.SetGlobalVector("_LightDir", source);
		}

		if(plane != null)
		{
			Shader.SetGlobalMatrix("_World2Receiver", plane.renderer.worldToLocalMatrix);
		}

		Shader.SetGlobalVector("_ShadowColor", shadowColor);
	}
}
