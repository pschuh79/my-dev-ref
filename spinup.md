## Spin up new website from backup files

#### ChatGPT chat - Backup and restore site

To spin up a new website using the backups you've created, you'll need to follow a series of steps. Here's a general guide:

1. **Transfer the Backup Files**:
   - Transfer the `backup.tar.gz` file and `filename.sql` to the new server where you want to spin up the website.

2. **Restore the Database**:
   - First, you need to make sure you have a target database created along with a database user with appropriate permissions.
   - Restore the MySQL database from the SQL dump file (`filename.sql`). 
   
   Use the following command:
     ```
     mysql -u <new_username> -p <new_password> new_database_name < /path/to/the/filename.sql
     ```
     Replace `<new_username>`, `<new_password>`, and `<new_database_name>` with the appropriate values for your new server. This command will create a new database using the SQL dump.

    In order to do the above, the root user in mysql must be accessible. If not, do this through Cpanel
    Create db
    create user, assign permissions, and link to newly created database

3. **Extract Website Files**:
   - Extract the website files from the `backup.tar.gz` file using the following command:
     ```
     tar -xzf /target-path/to/place/backup.tar.gz -C /path/to/extract
     ```
     This will extract the files into the specified directory (`/path/to/extract`). See note below regarding --strip-component=3

4. **Configure Web Server**:
   - Configure your web server (e.g., Apache or Nginx) to serve the website from the directory where you extracted the files.
   - This needs more research but DNS settings may need to be updated if using something like Cloudflare. 

5. **Database Configuration**:
   - Update the configuration files of your website (e.g., `config.php`, `wp-config.php`) to point to the newly restored database with the correct credentials.
   use wp cli to change url to appropriate url. 
   ```
   wp search-replace 'https://pjswebwerks.com' 'https://staging.pjswebwerks.com' --path=/home/pjswebwe/staging.pjswebwerks.com/ --precise --recurse-objects --all-tables --dry-run
   ```


6. **Permissions**:
   - Make sure file permissions are correctly set for the website files to ensure proper functioning.

7. **Testing**:
   - It may take some time for any updates made to DNS to propagate. 
   - Test the website thoroughly to ensure that everything is working as expected.

By following these steps, you should be able to spin up a new website using the backups you've created. Make sure to adapt the commands and configurations according to your specific setup and requirements.

### Commands I learned while doing this

***me** I ran this command
tar -xzf /home/pjswebwe/backups/wp-backup.tar.gz -C /home/pjswebwe/testing.pjswebwerks.com

The files I backed up are in this path
/home/pjswebwe/testing.pjswebwerks.com/home/pjswebwe/public_html/<wordpressfiles>

I want the files extracted to this path
/home/pjswebwe/testing.pjswebwerks.com/<wordpressfiles>

To extract the files directly into `/home/pjswebwe/testing.pjswebwerks.com` without including the intermediate directory `public_html`, you can do this by modifying the extraction command slightly. Here's the revised command:

```bash
tar -xzf /home/pjswebwe/backups/wp-backup.tar.gz -C /home/pjswebwe/testing.pjswebwerks.com --strip-components=3
```

In this command:

- `-C /home/pjswebwe/testing.pjswebwerks.com` specifies the target directory where the files will be extracted.
- `--strip-components=3` instructs `tar` to strip off the first 3 components of the file paths, effectively removing the `home/pjswebwe/public_html` part. This will ensure that the files are directly extracted into `/home/pjswebwe/testing.pjswebwerks.com`. Adjust the number `3` if the depth of the directory structure is different. 

With this modification, the WordPress files should be extracted directly into `/home/pjswebwe/testing.pjswebwerks.com`.

wp search-replace 'https://pjswebwerks.com' 'https://testing.pjswebwerks.com' --path=/home/pjswebwe/testing.pjswebwerks.com --precise --recurse-objects --all-tables --dry-run

### What I should do to make a staging site for vision or any other site

**This will need revision, I'm using actual commands. Need to make this more general**

1. In cPanel, create a new domain

    run:
    ```shell
    rsync -avz --progress /home/cages/visionproducts.us/ /home/cages/testing.visionproducts.us/
    ```
   - **Trailing Slash on Source:** Notice the trailing slash (`/`) at the end of `/home/pjswebwe/public_html/`. This is crucial because it tells `rsync` to copy the contents of the directory, rather than the directory itself.

2. Create new database through cPanel interface. 
3. Create new user, add user to the new database and apply appropriate permissions.

4. Get backup of live database
    ```
    mysqldump -u cages_visionproducts -p cages_visionproducts > /home/cages/vision_db_backup.sql --no-tablespaces
    ```
5. Export datbase into new database
    ```shell
    mysql -u cages_vision_test -p cages_vision_test < /home/cages/vision_db_backup.sql
    ```
6. Update `wp-config.php`. Salts may also need to be updated
7. Run search and replace to update the url that will be used. This may need to be ran for other strings that need to be replaced. Remove `--dry-run` to make the changes permananent. 
    ```
   wp search-replace 'https://www.visionproducts.us' 'https://testing.visionproducts.us' --path=/home/cages/testing.visionproducts.us --recurse-objects --all-tables --dry-run
    ```
8. DNS records may also need to be added or updated.

**I had this problem with basic auth window showing up on the live site. Cancelling the window did not result in a 401 error and allowed the user to continue. I don't know why this showed on the live site. Perhaps I didn't have something updated in the wp-config file. Update - somehow the the url to the testing site made it into the live database. I'm not sure how that happened.**