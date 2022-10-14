using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeView : MonoBehaviour
{
    public GameObject mainCamera;
    public GameObject palyerView;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void clicked()
    {

        if (mainCamera.activeInHierarchy == true)
        {
            mainCamera.SetActive(false);
        } else {
            mainCamera.SetActive(true);
        }
        
        if (palyerView.activeInHierarchy == true)
        {
            palyerView.SetActive(false);
        } else {
            palyerView.SetActive(true);
        }
    }

}
