package com.example.flicker_pip_demo;

import android.app.PendingIntent;
import android.app.PictureInPictureParams;
import android.app.RemoteAction;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Rational;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "enterChannelPip";


    @Override
    protected void onCreate(Bundle savedInstance){
        super.onCreate(savedInstance);
        MethodChannel methodChannel=new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(),CHANNEL);
        methodChannel.setMethodCallHandler((call,result)->{
            if (call.method.equals("enterPip")){
                enterPip();
                result.success(null);
            }else{
                result.notImplemented();
            }
        }

    );
    }

    private void enterPip(){
        if(Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            Rational aspectRatio=new Rational(16,9);
            PictureInPictureParams.Builder pipBuilder = new PictureInPictureParams.Builder();
            pipBuilder.setAspectRatio(aspectRatio);

            enterPictureInPictureMode(pipBuilder.build());
        }
    }

    @Override
    public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode, Configuration newConfig){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            super.onPictureInPictureModeChanged(isInPictureInPictureMode,newConfig);
        }


        }
    }




