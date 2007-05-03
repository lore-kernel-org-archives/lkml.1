Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXECQQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXECQQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXECQQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:16:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbXECQQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:16:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NSLvU/p+WjctVwEx0pnzQKP60ln7HyBKFtu8ErCAP8yAvZhpfwtPS9/p6JkkefljShzhkBEIHM6oXYhw5qpoiuDtdhnw1cINybghW3RxeUIw0UfLk94AtH7pEAKZ/0f7YcI5sGdOOxiludlUhz0OVqMpPC8b5WThtr0klb3vzp4=
Message-ID: <463A0AB7.5030704@gmail.com>
Date: Thu, 03 May 2007 20:15:51 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: xyzzy@speakeasy.org, mkrufky@linuxtv.org, mrechberger@gmail.com,
       mchehab@infradead.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	<4636E0E2.5020601@simon.arlott.org.uk>	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net> <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net> <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net> <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net> <463A0462.5070106@gmail.com> <20070503160514.184710@gmx.net>
In-Reply-To: <20070503160514.184710@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla wrote:
> -------- Original-Nachricht --------
> Datum: Thu, 03 May 2007 19:48:50 +0400
> Von: Manu Abraham <abraham.manu@gmail.com>
> An: Uwe Bugla <uwe.bugla@gmx.de>
> CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, mchehab@infradead.org, mrechberger@gmail.com, mkrufky@linuxtv.org, xyzzy@speakeasy.org
> Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical points	about ...)
> 
>> Uwe Bugla wrote:
>>
>>> Hi Manu,
>>>
>>> But it would be an acceptable compromise FOR NOW, wouldn't it?
>>
>> The reason is i do not wish to make changes to it, till i can fix it. It
>> is indeed hard to fix things that support a lot of devices, with
>> different issues. There are enough of issues in there.
>>
>> You can look at all those frontend not found issues on the DVB ML.
>>
>> The people who make all these noise, do nothing but just play politics.
>> Just do a search on the linux-dvb ML at gmane.org. You can easily find
>> them.
>>
>>> Waiting for your link meanwhile to download that hopeful project...
>> http://thadathil.net:8000/cgi-bin/hgwebdir.cgi/cx878_41?ca=43abfe89c2c9;type=bz2
> 
> Sorry Manu,
> 
> incorrect link!
> Why?
> 
> If you download the thing as tar.bz2 you get a zero file down.

I think could be a bug in hgweb probably.

> 
> However, if you download the thing as tar.gz you will succeed in getting it.
> 

Ok. The gzip archive should be as good as the bzip archive, just that it
is slightly larger.

> I'll sit down this evening, try to make changes to imply it into the actual mercurial tree, produce necessary patches and give you a bug report as far as the compilation errors are concerned.
> 
> I am really looking forward to see this fantastic thing finished....
> It's worth it for a thousands of very good reasons, not only RAM optimization, but also stability and many many others...
> 
> So gimme some time, and perhaps please supply a tar.bz2 version if you can, or fix the download error (zero file) if there is any other reason that I cannot see.
> 

Let me see why hgweb gives a zero length archive

