import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import 'bootstrap'
// Stimulusアプリケーションの開始
const application = Application.start()

// controllersフォルダから全てのコントローラを読み込む
const context = require.context("./controllers", true, /\.js$/)
context.keys().forEach((key) => {
  const controller = context(key).default
  const controllerName = key
    .replace("./", "")
    .replace("_controller.js", "")
    .replace(".js", "")
  application.register(controllerName, controller)
})