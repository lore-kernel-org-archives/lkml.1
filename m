Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZIURId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZIURId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZIURI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:08:29 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:64498 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZIURI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=xGLA4D7zWWPNWEbCePPCjBh4wP1/ogQPsnWjd1ZPw9z2xfEAOQw+Xf8makPVrb4A9i
         NV9+3FkUEUnr1hnMK5V/Ei0E1uI2i4Pp+ob9a6TUkQS/TfE75b3iDHXThecIirquopXO
         lhkvrjVKBLNwh71AoSsq7b2n3+ETrKT0+H790=
MIME-Version: 1.0
In-Reply-To: <dfeb90390909211003h3b16e984q1fdf94450bdb39@mail.gmail.com>
References: <1253215662-11404-1-git-send-email-getarunks@gmail.com> 
	<f17812d70909180210xdceaf22u7901befa23cd89c7@mail.gmail.com> 
	<771cded00909210049g6c7c8075pe4ca331184e39415@mail.gmail.com> 
	<dfeb90390909211003h3b16e984q1fdf94450bdb39@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 22 Sep 2009 01:08:11 +0800
Message-ID: <f17812d70909211008j62967af7qdf3456be722a9e13@mail.gmail.com>
Subject: Re: [PATCH] Adding LED1 & LED2 control for DA9034 backlight driver
To: Arun KS <getarunks@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org,
       rpurdie@rpsys.net, eric.miao@marvell.com, mike@compulab.co.il
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Apparently there is a bug in the hardware design on my custom board. We are
> using LED1 for backlight control.
> Thanks Haojian for clarification.
>

Now you know that :-)

Either let your hardware engineer change the design, or there are still
workarounds, you can control the LED1/2 through the sysfs entries.

- eric
