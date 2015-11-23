using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;

public class NStarAssetPostprocessor : AssetPostprocessor 
{
	void OnPreprocessModel () {
		if(!assetPath.ToLower().Contains("shadow"))
		{
			ModelImporter modelImporter  = assetImporter as ModelImporter;
//			modelImporter.normalSmoothingAngle = 180;
//			modelImporter.globalScale = 0.01f;
            modelImporter.animationType = ModelImporterAnimationType.Legacy;
			modelImporter.animationCompression = ModelImporterAnimationCompression.KeyframeReductionAndCompression;
		}
	}

	void OnPreprocessAudio () {
		AudioImporter audioImporter = (AudioImporter) assetImporter;
		Debug.Log("OnPreprocessAudio " + assetImporter.name);
	}

	void OnPreprocessTexture (){
//		TextureImporter textImporter = (TextureImporter) assetImporter;
//		textImporter.textureType = TextureImporterType.Advanced;
//		textImporter.textureFormat = TextureImporterFormat.PVRTC_RGB4;
//		textImporter.compressionQuality = (int)TextureCompressionQuality.Best;
		Debug.Log("OnPreprocessTexture " + assetImporter.name);
	}

}
