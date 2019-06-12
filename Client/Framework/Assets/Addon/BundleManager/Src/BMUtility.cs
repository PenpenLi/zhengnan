﻿using UnityEngine;
using System.Collections;
using System.Text.RegularExpressions;
using System.IO;
using LitJsonBM;


namespace BM
{
    /// <summary>
    /// <para>打包平台工具集合</para>
    /// <para>Author: zhengnan</para>
    /// <para>Create: 2019/6/12 0:24:39</para>
    /// </summary>
    public class BMUtility
    {
        public const int InheritPriorityValue = 6;

        public static void Swap<T>(ref T a, ref T b)
        {
            T temp = a;
            a = b;
            b = temp;
        }

        public static string InterpretPath(string origPath, BuildPlatform platform)
        {
            var matches = Regex.Matches(origPath, @"\$\((\w+)\)");
            foreach (Match match in matches)
            {
                string var = match.Groups[1].Value;
                origPath = origPath.Replace(@"$(" + var + ")", EnvVarToString(var, platform));
            }

            return origPath;
        }

        public static T LoadFromPersistentData<T>(string fileName)
        {
            var path = System.IO.Path.Combine(Application.persistentDataPath, fileName);
            if (File.Exists(path))
            {
                var reader = new StreamReader(path);
                if (reader != null)
                {
                    var obj = JsonMapper.ToObject<T>(reader);
                    reader.Close();
                    return obj;
                }
                else
                {
                    reader.Close();
                    return default(T);
                }
            }
            else
            {
                return default(T);
            }
        }

        public static void SaveToPersistentData<T>(T data, string fileName)
        {
            var path = System.IO.Path.Combine(Application.persistentDataPath, fileName);

            var tw = new StreamWriter(path);
            if (tw == null)
            {
                Debug.LogError("Cannot write to " + path);
                return;
            }

            string jsonStr = JsonFormatter.PrettyPrint(JsonMapper.ToJson(data));
            tw.Write(jsonStr);
            tw.Flush();
            tw.Close();
        }

        public static void DeletePersistentData(string fileName)
        {
            var path = System.IO.Path.Combine(Application.persistentDataPath, fileName);
            if (File.Exists(path))
            {
                try
                {
                    File.Delete(path);
                }
                catch (System.Exception e)
                {
                    Debug.LogError(e.Message);
                }
            }
        }

        public static bool IsPersistentDataExists(string fileName)
        {
            var path = System.IO.Path.Combine(Application.persistentDataPath, fileName);
            return File.Exists(path);
        }

        public static int[] long2doubleInt(long a)
        {
            int a1 = (int)(a & uint.MaxValue);
            int a2 = (int)(a >> 32);
            return new int[] { a1, a2 };
        }

        public static long doubleInt2long(int a1, int a2)
        {
            long b = a2;
            b = b << 32;
            b = b | (uint)a1;
            return b;
        }

        private static string EnvVarToString(string varString, BuildPlatform platform)
        {
            switch (varString)
            {
                case "DataPath":
                    return Application.dataPath;
                case "PersistentDataPath":
                    return Application.persistentDataPath;
                case "StreamingAssetsPath":
                    return Application.streamingAssetsPath;
                case "Platform":
                    return platform.ToString();
                default:
                    Debug.LogError("Cannot solve enviroment var " + varString);
                    return "";
            }
        }

        
    }

}
