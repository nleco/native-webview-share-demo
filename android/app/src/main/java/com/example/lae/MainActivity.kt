package com.example.lae

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.View
import android.webkit.JavascriptInterface
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import org.json.JSONObject


const val EXTRA_MESSAGE = "com.example.myfirstapp.MESSAGE"

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val webView = findViewById<WebView>(R.id.webView);
        webView.webViewClient = WebViewClient()
        webView.settings.javaScriptEnabled = true
        webView.addJavascriptInterface(JavascriptInterface(), "JSI")
        webView.loadUrl("https://tmh.red:8089")
    }

    fun sendMessage(view: View) {
        val editText = findViewById<EditText>(R.id.editText)
        val message = editText.text.toString()

        val webView = findViewById<WebView>(R.id.webView)
        webView.loadUrl("""javascript:(function f() {
            |debug("$message")
            |})()""".trimMargin())
        Log.d("send to wb", message)
    }

    fun reloadView(view: View) {
        val webView = findViewById<WebView>(R.id.webView)
        webView.reload()
    }

    private inner class JavascriptInterface {
        @android.webkit.JavascriptInterface
        fun showToast(text: String) {
            val appTextView = findViewById<TextView>(R.id.appTextView)
            appTextView.setText(text)

            val toast = Toast.makeText(applicationContext, "This was sent to the app", Toast.LENGTH_SHORT)
            toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
            toast.show();

            Log.d("WEBVIEW", text.toString());
        }

        @android.webkit.JavascriptInterface
        fun share(title: String?, text: String?, url: String?) {
            val txt = text.toString() + "\n" + url.toString()

            val intent = Intent()
            intent.action = Intent.ACTION_SEND
            intent.data = Uri.parse("smsto:")
            intent.putExtra(Intent.EXTRA_TITLE, title.toString())
            intent.putExtra(Intent.EXTRA_TEXT, txt)

            Log.d("WEBVIEW", text.toString());


            intent.type="text/plain"
            startActivity(Intent.createChooser(intent,"Share To:"))
        }
    }
}

