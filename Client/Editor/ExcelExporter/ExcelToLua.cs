
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace ExcelExporter
{
    public static class ExcelToLua
    {
        private static ExcelExporterSetting setting;
       
        //[MenuItem("Tools/Excel2Lua %#e")]
        static void DoExcelToLua()
        {
            setting = ExcelExporter.LoadSetting();
            List<string> excelFileList = ExcelExporter.GetExcelFileList(setting);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < excelFileList.Count; i++)
            {
                GenerateLua(excelFileList[i], sb);
                ExcelExporter.DisplayProgress(i,excelFileList.Count, excelFileList[i]);
            }
            EditorUtility.ClearProgressBar();
        }

        private static List<string> headFields;
        //private static List<string> headNames;
        private static List<string> headTypes;
        private const string Type_String = "string";
        private const string Type_Number = "number";
        private static void GenerateLua(string path, StringBuilder sb)
        {
            sb.Clear();
            ExcelReader reader = new ExcelReader(path);
            sb.Append($"-- {Path.GetFileNameWithoutExtension(path)} {DateTime.Now.ToLocalTime().ToString()}");
            sb.AppendLine();
            sb.Append("local Data = {}");
            sb.AppendLine();
            sb.Append("Data.table = {");
            reader.Read(delegate(int index, List<string> list)
            {
                ExecuteFile(index, list, sb);
            });
            sb.Append("}");
            sb.AppendLine();
            
            sb.AppendLine(@"
function Data.Get(id)
    if Data.table[id] == nil then
        logError(string.format('There is no id = %s data is table <"+ Path.GetFileName(path) + @">', id))
        return nil
    else
        return Data.table[id]
    end
end

return Data
                ");
            Output(sb, path);
        }
        private static void ExecuteFile(int rowIndex, List<string> list,StringBuilder sb)
        {
            if (rowIndex == 0)
            {
                headFields = list;
            }
            else if (rowIndex == 1)
            {
                headTypes = list;
            }
            else if (rowIndex == 2)
            {
                //headNames = list;
            }
            else
            {
                if (headTypes[0] == Type_Number)
                    sb.Append($"    [{list[0]}]");
                else
                    sb.Append($"    [\"{list[0]}\"]");
                sb.Append(" = {");
                for (int i = 0; i < list.Count; i++)
                {
                    if (headTypes[i] == Type_Number)
                    {
                       if (string.IsNullOrEmpty(list[i]))
                            sb.Append($"{headFields[i]} = 0");
                       else
                            sb.Append($"{headFields[i]} = {list[i]}");
                    }
                    else
                        sb.Append($"{headFields[i]} = \"{list[i]}\"");
                    if(i < list.Count - 1)
                        sb.Append(", ");
                }
                sb.Append("},");
                sb.AppendLine();
            }
        }
        private static void Output(StringBuilder sb, string path)
        {
           Debug.Log(sb.ToString());
           if (!Directory.Exists(setting.outputPath))
               Directory.CreateDirectory(setting.outputPath);
           EditUtils.SaveUTF8TextFile($"{setting.outputPath}/{Path.GetFileNameWithoutExtension(path)}.lua",sb.ToString());
        }
    }
}