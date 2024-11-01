const esbuild = require('esbuild')

payload = async() => {
  const path = require('path');

  const context = await esbuild.context({
    entryPoints: ['application.js'],
    outdir: path.join(process.cwd(), 'app/assets/builds'),
    absWorkingDir: path.join(process.cwd(), 'app/javascript'),
    bundle: true,
    sourcemap: true,
    logLevel: 'debug',
  })

  // Manually do an incremental build
  await context.rebuild()

  // Enable watch mode
  await context.watch()

  // Enable serve mode
  await context.serve()
}

payload()
