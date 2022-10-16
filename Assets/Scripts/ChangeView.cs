using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeView : MonoBehaviour
{
    public GameObject mainCamera;
    public GameObject palyerView;

    public GameObject main;
    public GameObject player;
    
    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void clicked()
    {

        if (mainCamera.activeInHierarchy == true)
        {
            main.SetActive(false);
            mainCamera.SetActive(false);
        } else {
            main.SetActive(true);
            mainCamera.SetActive(true);
        }
        
        if (palyerView.activeInHierarchy == true)
        {
            player.SetActive(false);
            palyerView.SetActive(false);
        } else {
            player.SetActive(true);
            palyerView.SetActive(true);
        }
    }

}
