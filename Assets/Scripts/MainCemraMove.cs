using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainCemraMove : MonoBehaviour
{
    // private Vector3 cameraPosition;

    // public float speed;

    // Start is called before the first frame update
    void Start()
    {
        // cameraPosition = this.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        // if(Input.GetKey(KeyCode.W)){
        //     cameraPosition.y -= speed/50;
        // }

        // if(Input.GetKey(KeyCode.S)){
        //     cameraPosition.y += speed/50;
        // }

        // if(Input.GetKey(KeyCode.A)){
        //     cameraPosition.x += speed/50;
        // }

        // if(Input.GetKey(KeyCode.D)){
        //     cameraPosition.x -= speed/50;
        // }
        // this.transform.position = cameraPosition; 
        
    }

    [SerializeField] float speed = 0.5f;
    [SerializeField] float sensitivity = 1.0f;
 
    Camera cam;
    Vector3 anchorPoint;
    Quaternion anchorRot;
 
    private void Awake()
    {
        cam = GetComponent<Camera>();
    }
   
    void FixedUpdate()
    {
        Vector3 move = Vector3.zero;
        if(Input.GetKey(KeyCode.W))
            move += Vector3.forward * speed;
        if (Input.GetKey(KeyCode.S))
            move -= Vector3.forward * speed;
        if (Input.GetKey(KeyCode.D))
            move += Vector3.right * speed;
        if (Input.GetKey(KeyCode.A))
            move -= Vector3.right * speed;
        if (Input.GetKey(KeyCode.E))
            move += Vector3.up * speed;
        if (Input.GetKey(KeyCode.Q))
            move -= Vector3.up * speed;
        transform.Translate(move);
 
        if (Input.GetMouseButtonDown(1))
        {
            anchorPoint = new Vector3(Input.mousePosition.y, -Input.mousePosition.x);
            anchorRot = transform.rotation;
        }
        if (Input.GetMouseButton(1))
        {
            Quaternion rot = anchorRot;
            Vector3 dif = anchorPoint - new Vector3(Input.mousePosition.y, -Input.mousePosition.x);
            rot.eulerAngles += dif * sensitivity;
            transform.rotation = rot;
        }
    }
    

    

}