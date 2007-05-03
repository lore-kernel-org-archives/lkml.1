Return-Path: <linux-kernel-owner+w=401wt.eu-S376163AbXECQFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376163AbXECQFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376169AbXECQFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:05:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:55274 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S376163AbXECQFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:05:15 -0400
Cc: xyzzy@speakeasy.org, mkrufky@linuxtv.org, mrechberger@gmail.com,
       mchehab@infradead.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 03 May 2007 18:05:14 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <463A0462.5070106@gmail.com>
Message-ID: <20070503160514.184710@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<4636E0E2.5020601@simon.arlott.org.uk>
	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net>
 <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>
 <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>
 <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net>
 <463A0462.5070106@gmail.com>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
To: Manu Abraham <abraham.manu@gmail.com>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19oQD1B4ZBo8LdLRRQR0k1qkDGb3O/MNx2lLeU3ym
 p/RDfD5fTDH6D8R5ITEkkEiF3lbzL/ET+QKA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: bUxwAW8va2AoTGC4SHQy1ls6OWhhaoeH
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Thu, 03 May 2007 19:48:50 +0400
Von: Manu Abraham <abraham.manu@gmail.com>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, mchehab@infradead.org, mrechberger@gmail.com, mkrufky@linuxtv.org, xyzzy@speakeasy.org
Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical points	about ...)

> Uwe Bugla wrote:
> 
> > Hi Manu,
> > 
> > But it would be an acceptable compromise FOR NOW, wouldn't it?
> 
> 
> The reason is i do not wish to make changes to it, till i can fix it. It
> is indeed hard to fix things that support a lot of devices, with
> different issues. There are enough of issues in there.
> 
> You can look at all those frontend not found issues on the DVB ML.
> 
> The people who make all these noise, do nothing but just play politics.
> Just do a search on the linux-dvb ML at gmane.org. You can easily find
> them.
> 
> > Waiting for your link meanwhile to download that hopeful project...
> 
> http://thadathil.net:8000/cgi-bin/hgwebdir.cgi/cx878_41?ca=43abfe89c2c9;type=bz2

Sorry Manu,

incorrect link!
Why?

If you download the thing as tar.bz2 you get a zero file down.

However, if you download the thing as tar.gz you will succeed in getting it.

I'll sit down this evening, try to make changes to imply it into the actual mercurial tree, produce necessary patches and give you a bug report as far as the compilation errors are concerned.

I am really looking forward to see this fantastic thing finished....
It's worth it for a thousands of very good reasons, not only RAM optimization, but also stability and many many others...

So gimme some time, and perhaps please supply a tar.bz2 version if you can, or fix the download error (zero file) if there is any other reason that I cannot see.

OKIDOK so far?

Uwe



-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
