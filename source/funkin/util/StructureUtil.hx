package funkin.util;

import haxe.DynamicAccess;

/**
 * Utilities for working with anonymous structures.
 */
class StructureUtil
{
  /**
   * Merge two structures, with the second overwriting the first.
   * Performs a SHALLOW clone, where child structures are not merged.
   * @param a The base structure.
   * @param b The new structure.
   * @return The merged structure.
   */
  public static function merge(a:Dynamic, b:Dynamic):Dynamic
  {
    var result:DynamicAccess<Dynamic> = Reflect.copy(a);

    for (field in Reflect.fields(b))
    {
      result.set(field, Reflect.field(b, field));
    }

    return result;
  }

  /**
   * Merge two structures, with the second overwriting the first.
   * Performs a DEEP clone, where child structures are also merged recursively.
   * @param a The base structure.
   * @param b The new structure.
   * @return The merged structure.
   */
  public static function deepMerge(a:Dynamic, b:Dynamic):Dynamic
  {
    if (a == null) return b;
    if (b == null) return null;
    if (!Reflect.isObject(a) || !Reflect.isObject(b)) return b;

    var result:DynamicAccess<Dynamic> = Reflect.copy(a);

    for (field in Reflect.fields(b))
    {
      if (Reflect.isObject(b))
      {
        // Note that isObject also returns true for class instances,
        // but we just assume that's not a problem here.
        result.set(field, deepMerge(Reflect.field(result, field), Reflect.field(b, field)));
      }
      else
      {
        // If we're here, b[field] is a primitive.
        result.set(field, Reflect.field(b, field));
      }
    }

    return result;
  }
}
