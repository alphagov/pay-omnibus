#!/usr/bin/env node

const fs = require('fs')
const AWS = require('aws-sdk')

const sts = new AWS.STS()

const run = async function run () {
  const assumeRoleResponse = await sts.assumeRole({
    RoleArn: process.env.AWS_ROLE_ARN,
    RoleSessionName: process.env.AWS_ROLE_SESSION_NAME
  }).promise()
  const tempCreds = assumeRoleResponse.Credentials

  fs.writeFileSync('assume-role/assume-role.json', JSON.stringify({
    AWS_ACCESS_KEY_ID: tempCreds.AccessKeyId,
    AWS_SECRET_ACCESS_KEY: tempCreds.SecretAccessKey,
    AWS_SESSION_TOKEN: tempCreds.SessionToken
  }))
}

run()
