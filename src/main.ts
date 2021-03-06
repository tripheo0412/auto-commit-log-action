import * as core from '@actions/core'
import {spawn} from 'child_process'
import path from 'path'
const exec = async (cmd: string, args: string[]): Promise<String> =>
  new Promise((resolve, reject) => {
    try {
      core.debug(`Started: ${cmd} ${args.join(' ')}`)
      const app = spawn(cmd, args, {stdio: 'inherit'})
      app.on('close', async code => {
        if (code !== 0) {
          const err = new Error(`Invalid status code: ${code}`)
          return reject(err)
        }
        return resolve(code.toString())
      })
    } catch (error) {
      core.setFailed(error.message)
    }
  })

const main = async (): Promise<void> => {
  await exec('bash', [path.join(__dirname, '../src/log-commit.sh')])
}

main().catch(err => {
  core.setFailed(err)
  process.exit(err.code || -1)
})
