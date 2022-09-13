using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;



public class ChangeCamera : MonoBehaviour
{

    private GameObject Camera_0;

    private GameObject Camera_1;

    void Start()
    {

        Camera_0 = GameObject.Find("Main Camera");

        Camera_1 = GameObject.Find("Camera");

    }

    bool a = true;

    public void OnClick()

    {

        if (a)
        {

            a = false;

            Camera_0.SetActive(false);

            Camera_1.SetActive(true);

        }
        else
        {

            a = true;

            Camera_0.SetActive(true);

            Camera_1.SetActive(false);

        }

    }
}
