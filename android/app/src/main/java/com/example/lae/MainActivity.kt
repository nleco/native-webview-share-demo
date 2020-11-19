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
        val webView = findViewById<WebView>(R.id.webView);
        val editText = findViewById<EditText>(R.id.editText)
        val message = editText.text.toString()
        webView.loadUrl("javascript:(function() { document.getElementById('fromNativeAppText').innerHTML = (+new Date()) + ' " + message + "'; })()".trimMargin())
        webView.loadUrl("""javascript:(function f() { debug("$message") })()""".trimMargin())
        _log(message)
    }

    fun reloadView(view: View) {
        val webView = findViewById<WebView>(R.id.webView)
        val message = "weView Reloaded"
        webView.reload()
        _log("webView reloaded")
    }

    fun _log(message: String) {
        showToast(message)
        Log.d("webView", message);
    }

    fun showToast(text: String) {
        val toast = Toast.makeText(applicationContext, text, Toast.LENGTH_SHORT)
        toast.show();
    }

    private inner class JavascriptInterface {


        @android.webkit.JavascriptInterface
        fun jsOnShare(json: String) {
            val params = JSONObject(json);
            val intent = Intent()
            val text = params.getString("text");
            val url = params.getString("url");

            val message = text  + "\n" + url;

            intent.action = Intent.ACTION_SEND
            intent.type="text/plain"
            if (!params.isNull("title")) {
                val title = params.optString("title", )
                if (title.isNotEmpty()) {
                    intent.putExtra(Intent.EXTRA_TITLE, title )
                }
            }
            intent.putExtra(Intent.EXTRA_TEXT, message)
            startActivity(Intent.createChooser(intent,"Share To:"))
            _log(message)
        }

        @android.webkit.JavascriptInterface
        fun jsOnBackPressed(json: String) {
            val message = "jsOnBackPressed() called";
            _log(message)
        }

        @android.webkit.JavascriptInterface
        fun jsHandler(json: String) {
            val params = JSONObject(json);
            val message = params.getString("message");

            val appTextView = findViewById<TextView>(R.id.appTextView)
            appTextView.setText(message)
            _log(message)
        }
    }
}

