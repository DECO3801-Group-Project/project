using System.Collections;
using System.Collections.Generic;
using Doozy.Runtime.UIManager.Components;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Loading : MonoBehaviour
{
    public GameObject LoadingScreen;
    public UISlider LoadingBar;
    public TMP_Text progressText;

    public void LoadScene(int sceneid)
    {
        StartCoroutine(LoadSceneAsync(sceneid));
    }

    IEnumerator LoadSceneAsync(int sceneID)
    {
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneID);
        
        LoadingScreen.SetActive(true);

        while (!operation.isDone)
        {

            LoadingBar.value = operation.progress;
            progressText.text = operation.progress * 100f + "%";
            yield return null;
        }
    }
}
