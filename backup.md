# Backup and migrate A WordPress Production Site to Staging Site

This is a general guide to manually backup a live/production website and create a staging environment or possibly migrate a website to a different web server. 

Much of the backing up process can be done through the CPanel and phpMyAdmin interfaces. There are also plugins available such as UpdraftPlus that make this task very easy. This readme file was developed as a way to learn how to accomplish this through the command line.

The following assumes the developer is using an Apache web server with cPanel and a WordPress installation.

## 1. Backing Up The Files
### Backup The Database:  
Create backup files for the database and the WordPress files. This can be done through the cPanel terminal or through `ssh` if available.
 - To create a backup of the database, run:
  ```
  mysqldump -u <target_db_user> -p <target_db_pass> <db_name> > </path/to/destination/filename.sql> --no-tablespaces
  ```
  - Database credentials can be stored in a `.my.cnf` file. If doing this, replace the `-u <target_db_user> -p <target_db_pass>` with `--defaults-file=~/.my.cnf`
  - Example `.my.cnf` file:
  ```
  [client]
  user=target_db_user
  password=target_db_pass
  ```
  - Example mysqldump command using a `.my.cnf` file:
  ```
  mysqldump --defaults-file=~/.my.cnf pjswebwe_wp158 --no-tablespaces > /home/user/db-backup.sql
  ```
- See https://stackoverflow.com/questions/13484667/export-mysql-dump-from-command-line for more examples.

- Alternatively, this can be done through phpMyAdmin by exporting the appropriate database.

### Backup The Web Files:
  - To create a backup of the web files, run:
  ```
  tar -czf /path/to/target/filename.tar.gz /path/to/source/directory_or_file
  ``` 

#### Security Notes:
- Ensure that backup files are stored in a secure location and have appropriate permissions to prevent unauthorized access. This also applies to the `.my.cnf` file. For example, you can set the permissions for the `.my.cnf` file to be readable only by the owner:
```
chmod 600 ~/.my.cnf
```

## 2. Importing the Backed up Database
### Prepare The Desination Database:
 The destination database can refer to either a new database or an existing database that may be used for staging. If using an existing datbase, clear all tables from it and then import the data. Depending on the level of access, this may need to be done through the cPanel and phpMyAdmin interfaces.

 ### Clearing an existing database
  If an existing database will be used:
  1. In phpMyAdmin, select the destination database.
  2. At the bottom of the table list, there is an option to select all tables. Check the box and select `Drop` from the dropdown.
  3. Confirm the action.


### Creating a New Database
  If a new database needs to be created, it can be created in cPanel:
  1. In the cPanel dashboard, go to `Manage My Databases` under `Databases`.
  2. Under `Create New Database`, enter the name of the new database and click `Create Database`.
  3. Create a new user under `Add New User`.
  4. Go back to the `Manage My Databases` screen and add the newly created user to the newly created database under `Add User To Database`.
  5. You will be brought to a `Manage User Priveleges` screen. Select the appropriate permissions, such as `ALL PRIVELEGES`. Then click `Make Changes`.
  6. Go back to the `Manage My Databases` screen and verify the user has been added to the desired database.

### Importing The Database File
Once the desintation database is prepared, the previously backed up .`sql` file can be imported.
- Via phpMyAdmin:
1. Select the destination database.
2. Select the `Import` tab in the interface.
3. Choose the file to be uploaded. Note: If the file already exists on the web server, it may need to be downloaded in order to be uploaded.
4. Click on `Import`

- Via the command line. This assumes the file exists on the web server :
  ```bash
  mysql -u username -p staging_database_name < live_db_backup.sql
  ```


## 3. Importing the Web Files
- **Via SSH/Rsync:** If you have SSH access, use Rsync to copy files from the live site directory to the staging site directory. Keep in mind that the entire web directory may not need to be synced, specific directories may be synced.
  ```bash
  rsync -avz --progress /path/to/live/ /path/to/staging/
  ```
- **Dry Run:** You can perform a "dry run" with `rsync` to see what files would be copied without actually copying them. Add the `--dry-run` option to your command:
  ```bash
  rsync -avz --progress --dry-run /path/to/web/directory/ /path/to/destination/directory/
  ```
- Example:
  ```
  rsync -avz --progress --dry-run /home/user/source-directory/wp-content/ /home/user/destination-directory/wp-content/
  ```
- **Permissions and Ownership:** After running `rsync`, check the permissions and ownership of the copied files to ensure they match what's needed by your web server. You might need to adjust these with `chown` or `chmod` commands if the files aren't accessible or visible on your staging site.

- **Via FTP/SFTP:** If you don’t have SSH access, use an FTP client to download all files from the live site and upload them to the staging directory.

## 4. Update the WordPress Configuration
- **wp-config.php:** Update the `wp-config.php` file in the staging site directory. You'll need to change the database name, user, and password to match the staging database credentials. Also, check the WordPress Address (URL) and Site Address (URL) settings in the WordPress dashboard to ensure they point to the staging URL.

## 5. Search and Replace URLs
- **Run Search-Replace:** The URLs and file paths in the database still point to the live site. Use a plugin like "Better Search Replace" or WP-CLI to search for the live site URL and replace it with the staging site URL. For WP-CLI, the command would be:
  ```bash
  wp search-replace 'https://live.example.com' 'https://staging.example.com' --path=/path/to/staging --precise --recurse-objects --all-tables
  ```
## 6. Fix Permalinks
- **Refresh Permalinks:** Sometimes, after a migration, permalinks need to be refreshed. Go to Settings > Permalinks in the WordPress dashboard and simply save the settings again to flush rewrite rules.

## 7. Address Security and Visibility
- **Discourage Search Engines:** To prevent search engines from indexing your staging site, go to Settings > Reading in your WordPress dashboard and check the box next to "Discourage search engines from indexing this site."

## 8. Test the Staging Site
- **Thorough Testing:** Browse the staging site to make sure everything works as expected. Check all pages, posts, plugins, and functionality.

## Changelog
### Version 1.0.0 - 2024-06-22
### Added
- Initial release of the README file detailing steps for backing up a WordPress production site, creating a staging environment, and migrating the site to another server.
- Sections included:
  - Backing up the files and database.
  - Importing the backed-up database and files to the staging environment.
  - Updating the WordPress configuration in the staging environment.
  - Performing search-replace operations on URLs.
  - Refreshing permalinks and addressing security settings.
  - Comprehensive testing of the staging site.