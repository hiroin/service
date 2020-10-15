#!/sin/sh
wp core install --url=http://wordpress-service:5050/wordpress/ --title=test --admin_user=admin --admin_password=admin --admin_email=admin@example.com  --allow-root --path=/usr/share/webapps/wordpress/
wp language core install ja --allow-root --path=/usr/share/webapps/wordpress/
wp site switch-language ja --allow-root --path=/usr/share/webapps/wordpress/
wp user create bob bob@example.com --role=editor --user_pass=bob --allow-root --path=/usr/share/webapps/wordpress/
wp user create alice alice@example.com --role=author --user_pass=alice --allow-root --path=/usr/share/webapps/wordpress/