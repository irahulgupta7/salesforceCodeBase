/**
 * @description A reusable, intuitive library for determing wether or not the
 * current use can create, read, edit, or delete objects as well as
 * determining if the user has access or update permissions on specific fields.
 * This class name was chosen to facilitate easy-to-understand and read code.
 * Whenever you need to check FLS or CRUD access your code reads like this
 * `if(CanTheUser.read(new account())){}` making the calling and use of this
 * code easy and intuitive.
 * @group Security Recipes
 */
public inherited sharing class CanTheUser {
    @testVisible
    private static Map<String, Set<String>> accessibleFieldsByObject = new Map<String, Set<String>>();
    @testVisible
    private static Map<String, Set<String>> updatableFieldsByObject = new Map<String, Set<String>>();

    /**
     * @description Internal custom exception class
     */
    public class CanTheUserException extends Exception {
    }

    public enum CrudType {
        CREATE,
        READ,
        EDIT,
        DEL
    }

    public enum FLSType {
        ACCESSIBLE,
        UPDATABLE
    }

    /**
     * Description this cachebuilder interface allows the CanTheUser clas to
     * cache per-object results for each object requested. This prevents the
     * need to repeatedly calculate permission usage by calling
     * Schema.Describe* calls
     */
    private class PermissionCache implements Cache.CacheBuilder {
        /**
         * @description   Required method for the CacheBuilder interface. Used
         * here to either calcuate an objects per-user FLS, OR to return it
         * from Cache.
         * The return datastructure for this is
         * Map<String, Map<FLSType,Boolean>> and represents:
         * FieldName -> FLStype -> True/False
         * @param objType String object name used as the cache key
         * @returns       `Object`
         */
        public Object doLoad(string objType) {
            Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(
                new List<String>{ objType }
            );

            Map<String, Map<FLSType, Boolean>> results = new Map<String, Map<FLSType, Boolean>>();
            for (SObjectField field : descResult[0].fields.getMap().values()) {
                DescribeFieldResult fieldDetails = field.getDescribe();
                String fieldKey = String.valueOf(field).toLowerCase();
                results.put(fieldKey, new Map<FLSType, Boolean>());
                results.get(fieldKey)
                    .put(FLSType.ACCESSIBLE, fieldDetails.isAccessible());
                results.get(fieldKey)
                    .put(FLSType.UPDATABLE, fieldDetails.isUpdateable());
            }
            return results;
        }
    }

    /**
     * This class' name was chosen to facilitate easy-to-understand and read
     * code. Whenever you need to check FLS or CRUD access your code reads like
     * this
     * `if(CanTheUser.read(new account())){}` making the calling and use of this
     * code easy and intuitive.
     */

    /**
     * @description
     * @param obj the object type to check
     * @param permission create, read, update or delete
     * @return Boolean
     * @example
     * System.debug(CanTheUser.crud(new Account(), CanTheUser.CrudType.READ));
     **/
    public static Boolean crud(SObject obj, CrudType permission) {
        switch on permission {
            when CREATE {
                return obj.getSObjectType().getDescribe().isCreateable();
            }
            when READ {
                return obj.getSObjectType().getDescribe().isAccessible();
            }
            when EDIT {
                return obj.getSObjectType().getDescribe().isUpdateable();
            }
            when DEL {
                return obj.getSObjectType().getDescribe().isDeletable();
            }
        }
        return false;
    }

    /**
     * @description convenience api for determining if the running user can
     * create the specified object
     * @param obj Object type to check create permissions on
     * @return Boolean
     * @example
     * System.debug(CanTheUser.create(new Account()));
     **/
    public static Boolean create(SObject obj) {
        return CanTheUser.crud(obj, CrudType.CREATE);
    }

    /**
     * @description convenience api for determining if the running user can
     * read / access the specified object
     * @param obj object type to check read permissions on
     * @return Boolean
     * @example
     * System.debug(CanTheUser.read(new Account()));
     **/
    public static Boolean read(SObject obj) {
        return CanTheUser.crud(obj, CrudType.READ);
    }

    /**
     * @description convenience api for determining if the running user can
     * edit / update the specified object
     * @param obj object type to check edit permissions on
     * @return Boolean
     * @example
     * System.debug(CanTheUser.edit(new Account()));
     **/
    public static Boolean edit(SObject obj) {
        return CanTheUser.crud(obj, CrudType.EDIT);
    }

    /**
     * @description convenience api for determining if the running user can
     * delete/destroy the specified object
     * @param obj object type to check destroy permissions on
     * @return Boolean
     * @example
     * System.debug(CanTheUser.destroy(new Account()));
     **/
    public static Boolean destroy(SObject obj) {
        return CanTheUser.crud(obj, CrudType.DEL);
    }

    /**
     * @description public method to determine if a given field on a given
     * object is Accessible (readable)
     * @param obj the object in question, in string form
     * @param field the field in question in SObjectField form
     * @return Boolean
     * @example
     * System.debug(CanTheuser.flsAccessible('Account', 'Name'));
     **/
    public static Boolean flsAccessible(String obj, String field) {
        Cache.Partition defaultSession = PlatformCacheRecipes.getDefaultPartition(
            PlatformCacheRecipes.PatitionType.SESSION
        );
        Map<String, Map<FLSType, Boolean>> objResults = (Map<String, Map<FLSType, Boolean>>) defaultSession.get(
            PermissionCache.class,
            obj
        );
        if (objResults.containsKey(field.toLowerCase())) {
            return objResults.get(field.toLowerCase()).get(FLSType.ACCESSIBLE);
        }
        return false;
    }

    /**
     * @description  bulk form of flsAccessible
     * @param obj    Obj name on which to check
     * @param fields Set of Fields to check for accessibility.
     * @return      `Map<String, Boolean>`
     * @example
     * String[] fields = new String[]{'Name', 'ShippingStreet'};
     * System.debug(CanTheuser.bulkFLSAccessible('Account', fields));
     */
    public static Map<String, Boolean> bulkFLSAccessible(
        String obj,
        Set<String> fields
    ) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, flsAccessible(obj, field));
        }
        return results;
    }

    /**
     * @description public method to determine if a given field on a given
     * object is Updatable.
     * @param obj the string version of an object name
     * @param field the field to check
     * @return Boolean
     * @example
     * System.debug(CanTheuser.flsUpdatable('Account', 'Name'));
     **/
    public static Boolean flsUpdatable(String obj, String field) {
        Cache.Partition defaultSession = PlatformCacheRecipes.getDefaultPartition(
            PlatformCacheRecipes.PatitionType.SESSION
        );
        Map<String, Map<FLSType, Boolean>> objResults = (Map<String, Map<FLSType, Boolean>>) defaultSession
            .get(PermissionCache.class, obj);
        if (objResults.containsKey(field.toLowerCase())) {
            return objResults.get(field.toLowerCase()).get(FLSType.UPDATABLE);
        }
        return false;
    }

    /**
     * @description  bulk form o flsUpdatable call
     * @param obj    Name of the object
     * @param fields Set of Field names to check
     * @return      `Map<String, Boolean>`
     * @example
     * String[] fields = new String[]{'Name', 'ShippingStreet'};
     * System.debug(CanTheuser.bulkFLSUpdatable('Account', fields));
     */
    public static Map<String, Boolean> bulkFLSUpdatable(
        String obj,
        Set<String> fields
    ) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String field : fields) {
            results.put(field, flsUpdatable(obj, field));
        }
        return results;
    }

    /**
     * @description   Utilizes the Metadata catalog to determine FLS
     *
     * Note: this method contains a false-positive PMD violation.
     * Normally, we'd want to check for FLS/CRUD here, but for metadata catalog
     * objects that admins cannot remove permissions to we're ok.
     *
     * Additionally, even the minimum access profile user has read access
     * to the FieldPermissions object.
     *
     * @param objType String version of the object type to check
     * @param action  Enum of the FLS action to check permissions for
     * @return       `set<String>`
     */
    @SuppressWarnings('PMD.ApexCRUDViolation')
    @testVisible
    private static set<String> memoizeFLSMDC(String objType, FLSType action) {
        List<FieldPermissions> fields = [
            SELECT Id, field, permissionsEdit, permissionsRead, SObjectType
            FROM FieldPermissions
            WHERE SObjecttype = :objType
        ];

        if (!CanTheUser.accessibleFieldsByObject.containsKey(objType)) {
            Set<String> accessibleFields = new Set<String>();
            Set<String> updatableFields = new Set<String>();
            for (FieldPermissions field : fields) {
                String[] parts = field.field.split('\\.');
                if (field.PermissionsRead) {
                    accessibleFields.add(parts[1].toLowerCase());
                }
                if (field.PermissionsEdit) {
                    updatableFields.add(parts[1].toLowerCase());
                }
            }
            CanTheUser.accessibleFieldsByObject.put(objType, accessibleFields);
            CanTheUser.updatableFieldsByObject.put(objType, updatableFields);
        }

        if (action == CanTheUser.FLSType.ACCESSIBLE) {
            return CanTheUser.accessibleFieldsByObject.get(objType);
        } else {
            return CanTheUser.updatableFieldsByObject.get(objType);
        }
    }
}