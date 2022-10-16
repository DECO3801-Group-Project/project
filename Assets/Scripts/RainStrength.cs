using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class RainStrength : MonoBehaviour
{
    Scrollbar bar;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void changeStrength()
    {
        bar = gameObject.GetComponent<Scrollbar>();
    }
}
