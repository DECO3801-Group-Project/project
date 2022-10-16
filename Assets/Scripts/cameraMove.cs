using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraMove : MonoBehaviour
{
    private Vector3 m_camRot;
    private Transform m_camTransform;//摄像机Transform 
    public float m_rotateSpeed = 1;//旋转系数 


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
    #region 相机跟随鼠标旋转
    void CameraRotate_Mouse()
    {
        if (Input.GetMouseButton(1))
        {
            //获取鼠标移动距离
            float rh = Input.GetAxis("Mouse X");
            float rv = Input.GetAxis("Mouse Y");
            // 旋转摄像机
            m_camRot.x -= rv * m_rotateSpeed;
            m_camRot.y += rh * m_rotateSpeed;
        }
        m_camTransform.eulerAngles = m_camRot;
        if (Input.GetMouseButton(2))
        {
            float rh = Input.GetAxis("Mouse X");
            float rv = Input.GetAxis("Mouse Y");
            //float mscrollWheelouseS = Input.GetAxis("Mouse ScrollWheel");
            transform.Translate(transform.up * -rv * m_rotateSpeed + transform.right * -rh * m_rotateSpeed, Space.World);
        }

    }
    #endregion
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



        if (Input.GetKey(KeyCode.W))
        {
            z_m = z_m + Time.deltaTime * moveSpeed;
            transform.Translate(transform.forward * z_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.W))
        {
            z_m = 0;

        }


        if (Input.GetKey(KeyCode.S))
        {
            z_m = z_m - Time.deltaTime * moveSpeed;
            transform.Translate(transform.forward * z_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.S))
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

        if (Input.GetKey(KeyCode.Q))
        {
            y_m = y_m - Time.deltaTime * moveSpeed;
            transform.Translate(transform.up * y_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.Q))
        {
            y_m = 0;

        }

        if (Input.GetKey(KeyCode.E))
        {
            y_m = y_m + Time.deltaTime * moveSpeed;
            transform.Translate(transform.up * y_m, Space.World);
        }
        else if (Input.GetKeyUp(KeyCode.E))
        {
            y_m = 0;

        }


    }
    void Update()
    {
        PlayerMove();
        CameraRotate_Mouse();
    }
}