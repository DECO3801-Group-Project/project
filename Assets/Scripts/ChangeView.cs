using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeView : MonoBehaviour
{
    public GameObject mainCamera;
    public GameObject playerView;

    public GameObject main;
    public GameObject player;

    public GameObject waypoints;
    
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
        
        if (playerView.activeInHierarchy == true)
        {
            player.SetActive(false);
            playerView.SetActive(false);
            waypoints.SetActive(false);
        } else {
            player.SetActive(true);
            playerView.SetActive(true);
            waypoints.SetActive(true);
            waypoints.GetComponent<SetupWaypoints>().Path();
        }
    }

}
