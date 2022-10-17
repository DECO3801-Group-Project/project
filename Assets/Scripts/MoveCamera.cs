using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//inspired by https://www.youtube.com/watch?v=f473C43s8nE
public class MoveCamera : MonoBehaviour
{
    [Header("Camera Position (use cameraPos object)")]
    public Transform cameraPosition;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        //Moves the camera to the player position
        transform.position = cameraPosition.position;
    }
}
