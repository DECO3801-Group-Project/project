using System.IO;
using UnityEngine;

public class GetPos : MonoBehaviour
{
    public TextAsset textJSON;

    [System.Serializable]
    public class Pos
    {
        public double x;
        public double z;
        public int y;
    }
    [System.Serializable]
    public class Data
    {
        public Pos[] results;
    }

    public Data Posdata = new Data();
    void Start()
    {
        Data Posdata = JsonUtility.FromJson<Data>(textJSON.text);
        foreach(var item in Posdata.results)
        {
            Debug.Log(item.x);
            Debug.Log(item.z);
            Debug.Log(item.y);
        }
    }

}