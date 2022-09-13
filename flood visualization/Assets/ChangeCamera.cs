using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ChangeCamera : MonoBehaviour
{
    public Camera camera_one;
    public Camera camera_two;

    private void Start()
    {
        camera_one.enabled = true;
        camera_two.enabled = false;
    }
    private void Update() //通过点击不同的按键实现相机的切换
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            camera_one.enabled = false;
            camera_two.enabled = true;
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            camera_one.enabled = true;
            camera_two.enabled = false;
        }
    }
}

