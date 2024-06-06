# Backup and migrate A WordPress Production Site to Staging Site

This is a general guide to manually backup a production website and create a staging environment or possibly migrate a website to a different web server. The following assumes the developer is using an Apache web server with cPanel and a WordPress installation.

## 1. Backing Up The Files
### Backup The Database:  
Create backup files for the database and the WordPress files. This can be done through the cPanel terminal or through `ssh` if available.
 - To create a backup of the database, run:
  ```
  mysqldump -u <target_db_user> -p <target_db_pass> <db_name> > </path/to/destination/filename.sql> --no-tablespaces
  ```
  - It's a good idea to store the database credentials in a `.my.cnf` file. If doing this, replace the `-u <target_db_user> -p <target_db_pass>` with `--defaults-file=~/.my.cnf`
  - Example `.my.cnf` file:
  ```
  [client]
  user=target_db_user
  password=target_db_pass
  ```
  - Example mysqldump command using a `.my.cnf` file:
  ```
  mysqldump --defaults-file=~.my.cnf pjswebwe_wp158 --no-tablespaces
  ```
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
 The destination database can refer to either a new database or an existing database that may be used for staging. If using an existing datbase, clear all tables from it and then import the data using phpMyAdmin or the command line:


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

- Via the command line:
  ```bash
  mysql -u username -p staging_database_name < live_db_backup.sql
  ```


## 3. Importing the Web Files
- **Via SSH/Rsync:** If you have SSH access, use Rsync to copy files from the live site directory to the staging site directory. 
  ```bash
  rsync -avz --progress /path/to/live/ /path/to/staging/
  ```
- **Via FTP/SFTP:** If you don’t have SSH access, use an FTP client to download all files from the live site and upload them to the staging directory.

## 4. Update the WordPress Configuration
- **wp-config.php:** Update the `wp-config.php` file in the staging site directory. You'll need to change the database name, user, and password to match the staging database credentials. Also, check the WordPress Address (URL) and Site Address (URL) settings in the WordPress dashboard to ensure they point to the staging URL.

## 5. Search and Replace URLs
- **Run Search-Replace:** The URLs and file paths in the database still point to the live site. Use a plugin like "Better Search Replace" or WP-CLI to search for the live site URL and replace it with the staging site URL. For WP-CLI, the command would be:
  ```bash
  wp search-replace 'https://live.example.com' 'https://staging.example.com' --path=/path/to/staging --precise --recurse-objects --all-tables
  ```

## 6. Test the Staging Site
- **Thorough Testing:** Browse the staging site to make sure everything works as expected. Check all pages, posts, plugins, and functionality.

## 7. Fix Permalinks
- **Refresh Permalinks:** Sometimes, after a migration, permalinks need to be refreshed. Go to Settings > Permalinks in the WordPress dashboard and simply save the settings again to flush rewrite rules.

## 8. Address Security and Visibility
- **Discourage Search Engines:** To prevent search engines from indexing your staging site, go to Settings > Reading in your WordPress dashboard and check the box next to "Discourage search engines from indexing this site."

By following these steps, you can successfully update your staging site with the current state of your live WordPress site, allowing for safe testing and development. If you run into any specific issues during this process, feel free to ask for more detailed help!

## 9. Configuring the Staging Site
- **Update Configuration Files:** Adjust configuration files for the CMS or framework you are using (like `wp-config.php` for WordPress) to point to the new database and environment settings.
- **Modify Hosts File:** To preview the site without changing DNS, modify your local `hosts` file to point the domain to the staging server’s IP address.

## 10. Testing the Staging Site
- **Check Functionality:** Thoroughly test the staging site to ensure everything is working as expected. Check links, forms, and other functionalities.
- **Resolve Issues:** Fix any issues that arise to ensure the staging site is an accurate replica of the production site.



**me**ok so here's the situation. I have a simple live wordpress website. On the same webserver, I have a staging site that is months old and no longer has the same plugins or content. I want to  copy my live site over to the staging site

Migrating your live WordPress site to an outdated staging site on the same webserver involves several steps to ensure the staging environment is updated correctly without losing any data or functionality. Here’s a detailed step-by-step guide to achieve this:

### 1. Backup Both Sites
- **Live Site:** Use a WordPress backup plugin like UpdraftPlus, or manually backup by copying all WordPress files and exporting the database.
- **Staging Site:** Even though it's outdated, it's good practice to backup the staging site before making changes.

### 2. Prepare the Staging Environment
- **Clean Up:** Since the staging site is outdated, you might want to clean it up. Delete all files in the staging site directory and drop all tables in the staging site’s database. This prepares the environment for a fresh copy of the live site.




**me** going back to this line - rsync -avz --progress /path/to/live/ /path/to/staging/ - I entered /home/pjswebwe/public_html /home/pjswebwe/staging.pjswebwerks.com for the path. In my staging.pjswebwerks.com directory, I have the public_html directory and then all of my wordpress files. I want all of my wordpress files to be under the staging.pjswebwerks.com directory. How do i do this?

It sounds like you want to ensure that the WordPress files are directly under the `staging.pjswebwerks.com` directory, not nested inside another `public_html` directory within it. To achieve this with `rsync`, you need to adjust the paths in your command to ensure the files are copied to the correct location.

Here's how you can structure the `rsync` command based on your description:

```bash
rsync -avz --progress /home/pjswebwe/public_html/ /home/pjswebwe/staging.pjswebwerks.com/
```

### Additional Tips:
- **Verify Paths:** Before running the command, verify both the source and destination paths. You can list the contents of the directories with `ls -l /path/to/directory` to make sure everything is in order.
- **Dry Run:** You can perform a "dry run" with `rsync` to see what files would be copied without actually copying them. Add the `--dry-run` option to your command:
  ```bash
  rsync -avz --progress --dry-run /home/pjswebwe/public_html/ /home/pjswebwe/staging.pjswebwerks.com/
  ```
- **Permissions and Ownership:** After running `rsync`, check the permissions and ownership of the copied files to ensure they match what's needed by your web server. You might need to adjust these with `chown` or `chmod` commands if the files aren't accessible or visible on your staging site.

Running the `rsync` command as above should place all your WordPress files directly under the `staging.pjswebwerks.com` directory as intended. Make sure to check the staging site after running the command to verify that everything is working as expected. If you encounter any issues, feel free to ask for further assistance!

