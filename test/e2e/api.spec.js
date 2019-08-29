const request = require('supertest');
const server = require('../../src/index.js');
const expect = require('chai').expect;

// Before Step: Insert sql/setup.sql data
describe('Test API', function() {

    describe('Test endpoint', function () {
        it('should return a 200 Http response', async function () {
            await request(server)
                .get('/hello/test')
                .expect(200)
        })
    });

    describe('Login Endpoint', function () {
        it('should return 200 Http response and user id if login successful', async function () {
            await request(server)
                .post('/login')
                .send({
                    email: 'gandalf@theshire.com',
                    password: 'You should not pass',
                })
                .set('Content-Type', 'application/json')
                .expect(200)
                .then(res => {
                    expect(res.body).to.have.property('id');
                    expect(res.body.id).to.be.an('Number');
                })
        })

        //TODO: Test unauthorised request
    });

    describe('Get Completed challenges', function () {
        it('should return 200 Http response and completed challenges if any', async function () {
            await request(server)
                .get('/user/1/challenges/completed')
                .set('Content-Type', 'application/json')
                .expect(200)
                .then(res => {
                    expect(res.body).to.be.an('Array');
                    expect(res.body).to.be.empty;
                })
        })
    });

});