/**
 * @description Demonstrates how to create, link and share Files
 * @group Files Recipes
 */
public inherited sharing class FilesRecipes {
    /**
     * @description Internal exception class
     */
    public class FilesRecipesException extends Exception {
    }
    /**
     * @description This enum encapsulates a 'generic' filetype a 'filetype'
     * that may have multiple file extension and mime types associated with it.
     * For instance, IMAGE encapsulates: jpg, gif, jpeg, & png this allows
     * developers to say, 'give me all *image* attachments' without worrying
     * about the actual file extension.
     */
    public enum GenericFileType {
        IMAGE,
        AUDIO,
        DOCUMENT,
        ALL
    }

    /**
     * @description creates a file attachment containing the given string and
     * links it to the object specified in firstLocation
     * @param  text          String to write to the file
     * @param  firstLocation object to immediately link this file to
     * @example
     * Account acct = [SELECT id FROM Account LIMIT 1];
     * FilesRecipes.createFileFromStringAttachedToRecord('Hello World', acct.Id);
     * System.debug('Look for files assoicated with account: ' + acct.id);
     */
    public static void createFileFromStringAttachedToRecord(
        String text,
        Id firstLocation
    ) {
        Blob fileContents = Blob.valueOf(text);
        FilesRecipes.createFileAttachedToRecord(
            fileContents,
            firstLocation,
            'AwesomeFile1'
        );
    }

    /**
     * @description        Creates a file and links it to a given record
     * @param fileContents the binary blob of the files contents
     * @param attachedTo   the record to link this file to, initially
     * @param fileName     the name of the file. Note that the system determines
     *  the filetype from the file extension here
     * @return            `Database.SaveResult`
     * @example
     * Blob fileContents = Blob.valueOf('Hello World 2');
     * Account acct = [SELECT id FROM Account LIMIT 1];
     *  FilesRecipes.createFileAttachedToRecord(
     *      fileContents,
     *      firstLocation,
     *      'AwesomeFile1'
     *  );
     * System.debug('Look for files assoicated with account: ' + acct.id);
     */
    public static Database.SaveResult createFileAttachedToRecord(
        Blob fileContents,
        Id attachedTo,
        String fileName
    ) {
        ContentVersion fileToUpload = new ContentVersion();
        // S = Salesforce. The other options are: 'E' (external)
        // and 'L' (social customer service)
        fileToUpload.ContentLocation = 'S';
        fileToUpload.pathOnClient = fileName;
        fileToUpload.title = fileName;
        fileToUpload.versionData = fileContents;
        fileToUpload.firstPublishLocationId = attachedTo;
        Database.SaveResult saveResult;
        try {
            saveResult = Database.insert(fileToUpload);
        } catch (DmlException DMLE) {
            System.debug(
                LoggingLevel.INFO,
                'Failed to insert fileToUpload, error is: ' + dmle.getMessage()
            );
        }
        return saveResult;
    }

    /**
     * @description Searches for content version records linked to this record
     * Filtering by a generic file type: image, audio, document etc.
     *
     * Note: This method has a false-positive PMD warning. Our Query
     * includes the keyword 'WITH SECURITY_ENFORCED' which prevents this
     * Query from accessing fields and objects that they don't have permission
     * to access. This is a form of inline CRUD/FLS Check.
     *
     * @param genericFileType Enum of image, audio, document
     * @param recordId        Record id to limit searching to
     * @return               `List<ContentVersion>`
     * @example
     * Account acct = [SELECT id FROM Account LIMIT 1];
     * FilesRecipes.createFileFromStringAttachedToRecord('Hello World', acct.Id);
     * System.debug('Found the following ContentVersion Ids: ' + FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.ALL, acct.id));
     */
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public static List<ContentVersion> getFilteredAttachmentsForRecord(
        FilesRecipes.GenericFileType genericFileType,
        Id recordId
    ) {
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        String queryString =
            'SELECT ContentDocumentId' +
            ' FROM ContentDocumentLink' +
            ' WHERE ' +
            ' LinkedEntityId = :recordId';

        switch on genericFileType {
            when AUDIO {
                queryString += ' AND ContentDocument.FileType IN (\'M4A\')';
            }
            when IMAGE {
                queryString += ' AND ContentDocument.FileType IN (\'JPG\', \'GIF\', \'PNG\', \'JPEG\')';
            }
            when DOCUMENT {
                queryString += ' AND ContentDocument.FileType IN (\'WORD_X\', \'EXCEL_X\', \'POWER_POINT_X\', \'PDF\')';
            }
            when ALL {
                queryString += '';
            }
        }
        queryString += ' WITH SECURITY_ENFORCED';
        String safeQueryString = String.valueOf(queryString);
        links = Database.query(safeQueryString);

        Set<Id> fileIds = new Set<Id>();
        for (ContentDocumentLink cdl : links) {
            fileIds.add(cdl.ContentDocumentId);
        }
        if (CanTheUser.read(new ContentVersion())) {
            return [
                SELECT Id, Title
                FROM ContentVersion
                WHERE ContentDocumentId IN :fileIds AND IsLatest = TRUE
                WITH SECURITY_ENFORCED
                ORDER BY CreatedDate
            ];
        } else {
            throw new FilesRecipes.FilesRecipesException(
                'User has no Access to ContentVersion'
            );
        }
    }

    /**
     * @description Given a content document link, publish the content version
     * @param cdl   Content Document link record to publish
     * @return     `Database.SaveResult`
     * @exception   FilesRecipesException
     * @example
     * Account acct = [SELECT id FROM Account LIMIT 1];
     * FilesRecipes.createFileFromStringAttachedToRecord('Hello World', acct.Id);
     * ContentDocumentLink cdl = [SELECT LinkedEntityId, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :acct.id LIMIT 1];
     * System.debug('Found the following ContentVersion Ids: ' + FilesRecipes.getFilteredAttachmentsForRecord(FilesRecipes.GenericFileType.ALL, acct.id));
     */
    public static Database.SaveResult publishContent(ContentDocumentLink cdl) {
        ContentDistribution dist = new ContentDistribution();

        dist.Name = 'new distributrion of content';
        dist.PreferencesAllowOriginalDownload = true;
        dist.PreferencesAllowPDFDownload = true;
        dist.PreferencesAllowViewInBrowser = true;
        dist.RelatedRecordId = cdl.LinkedEntityId;
        dist.ContentVersionId = cdl.ContentDocument.LatestPublishedVersionId;

        if (CanTheUser.create(new ContentDistribution())) {
            try {
                return Database.insert(dist);
            } catch (DmlException dmle) {
                System.debug(LoggingLevel.INFO, dmle.getMessage());
                throw new FilesRecipesException(dmle.getMessage());
            }
        } else {
            throw new FilesRecipesException(
                'User has no privileges to create content distribution records'
            );
        }
    }
}