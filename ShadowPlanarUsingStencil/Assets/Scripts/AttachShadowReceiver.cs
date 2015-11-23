using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class AttachShadowReceiver : MonoBehaviour {
	public GameObject receiver;
	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
		if(receiver != null)
		{
			renderer.sharedMaterial.SetMatrix("_World2Receiver", receiver.renderer.worldToLocalMatrix);
		}
	}

}
