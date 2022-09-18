using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraMove2 : MonoBehaviour
{
    private Vector3 m_camRot;
    private Transform m_camTransform;//摄像机Transform 


    public float m_speed = 1.5f;//初始移动速度 
    private float moveSpeed;//移动速度
                            //记录加速度
    float x_m;
    float y_m;
    float z_m;
    float d;


    void Start()
    {
        m_camTransform = Camera.main.transform;
        m_camRot = Camera.main.transform.eulerAngles;
    }
    
    void PlayerMove()
    {
        moveSpeed = m_speed;


        if (Input.GetKey(KeyCode.LeftShift))
        {
            moveSpeed = m_speed * 3;
        }
        else if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            moveSpeed = m_speed;

        }



        if (Input.GetKey(KeyCode.Q))
        {
            z_m = z_m + Time.deltaTime * moveSpeed;
            transform.Translate(transform.forward * z_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.Q))
        {
            z_m = 0;

        }


        if (Input.GetKey(KeyCode.E))
        {
            z_m = z_m - Time.deltaTime * moveSpeed;
            transform.Translate(transform.forward * z_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.E))
        {
            z_m = 0;

        }


        if (Input.GetKey(KeyCode.A))
        {
            x_m = x_m - Time.deltaTime * moveSpeed;
            transform.Translate(transform.right * x_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.A))
        {
            x_m = 0;

        }


        if (Input.GetKey(KeyCode.D))
        {
            x_m = x_m + Time.deltaTime * moveSpeed;
            transform.Translate(transform.right * x_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.D))
        {
            x_m = 0;

        }

        if (Input.GetKey(KeyCode.S))
        {
            y_m = y_m - Time.deltaTime * moveSpeed;
            transform.Translate(transform.up * y_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.S))
        {
            y_m = 0;

        }

        if (Input.GetKey(KeyCode.W))
        {
            y_m = y_m + Time.deltaTime * moveSpeed;
            transform.Translate(transform.up * y_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.W))
        {
            y_m = 0;

        }


    }
    void Update()
    {
        PlayerMove();
 
    }
}