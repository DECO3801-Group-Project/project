using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlRain : MonoBehaviour
{

    [SerializeField]
    private ParticleSystem sys;
    private bool rainStopped = false;

    // Start is called before the first frame update
    void Start()
    {
        sys = GetComponent<ParticleSystem>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("p") || Input.GetKeyDown("m"))
        {
            if (!rainStopped)
            {
                sys.Stop();
            } else if (rainStopped)
            {
                sys.Play();
            }
            rainStopped = !rainStopped;
        }
    }
}
