const md5 = require('md5');
require('../db');


class UserService {
    login(email, encryptedPassword) {
        return new Promise((resolve, reject) => {
            db.query('SELECT id FROM users WHERE email = $1 AND password = $2',
                [email, encryptedPassword]
                , function (error, result) {
                    if (error) {
                        console.log(error);
                        reject(new Error('Failed to login user'));
                        return;
                    }

                    if (result.rowCount > 0) {
                        return resolve({id: result.rows[0].id});
                    } else {
                        return resolve({})
                    }
                });
        });
    }

    async register(userData) {
        const {rows} = await db.query(`INSERT INTO users
                                           (full_name, email, password, title, image_url)
                                       VALUES ($1, $2, $3, $4, $5)
                                       RETURNING id, full_name, email, title, image_url`,
            [userData.full_name,
                userData.email,
                md5(userData.password),
                userData.title,
                userData.image_url]);
        return rows[0]
    }

    async getProfile(profileId) {
        try {
            const {rows} = await db.query('select u.full_name, u.email, u.title, u.image_url, c.id as company_id, c.name as company_name,  ' +
                'c.url, c.image_url from users u join companies c on u.company_id = c.id where u.id =  $1',
                [profileId]);
            const profile = rows[0];
            profile.total_points = 0;

            return profile
        } catch (error) {
            console.log(error)
            throw  Error('Failed to get profile')
        }
    }

    async removeUser(userId) {
        db.query("DELETE FROM users where id = $1", [userId])
    }
}

module.exports = UserService;
