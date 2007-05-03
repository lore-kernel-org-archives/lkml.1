Return-Path: <linux-kernel-owner+w=401wt.eu-S1766494AbXECPbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766494AbXECPbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767405AbXECPbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:31:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:59620 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1766494AbXECPbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:31:31 -0400
Cc: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, mchehab@infradead.org,
       mrechberger@gmail.com, mkrufky@linuxtv.org, xyzzy@speakeasy.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 03 May 2007 17:31:29 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <4639F554.1040505@gmail.com>
Message-ID: <20070503153129.268110@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<4636E0E2.5020601@simon.arlott.org.uk>
	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net>
 <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>
 <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>
 <4639F554.1040505@gmail.com>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
To: Manu Abraham <abraham.manu@gmail.com>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/OYRwnJN3OjSVviMIbf9eHtT/DccNGMrSWgABg3q
 kQj7ux5MxzWxbh1GqAPtMPOAZS1+xJxRnoPw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: MGxRLvI9TlI8RGzrCGhriAZOU2poZZmh
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Thu, 03 May 2007 18:44:36 +0400
Von: Manu Abraham <abraham.manu@gmail.com>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical points	about ...)

> Uwe Bugla wrote:
> 
> > On the technical layer I noticed that I heard some Pinnacle relais click
> during testing, but there were some i2c_bus symbols missing during
> compilation. So I guess those missing symbols are responsible for getting neither
> picture nor sound.
> 
> Can you send your compile warnings ? I couldn't find the same in my
> mailbox any report on the same. Maybe my mail filter did something.

I can certainly send compile warnings and dmesg and whatever you need.

But at first I need another link WHERE I can download the actual cx878 code.

Is it thaddathil.net or where the hell has it gone?

Just send me one link please, otherwise I do not have any chance to help you, OK?

> 
> > A. If you are really interested I can send you my basic puzzle parts in
> short, opening a new thread on this issue. Just give me a short response if
> you are interested.
> > 
> > B. If you want to continue the cx878 project please drop me a short note
> where I can download it to test and enlarge it with my own ideas as good
> as I can.
> > 
> > Must not be immediately (no sweat please), but I am looking forward to
> receive a response from you.
> > 
> 
> What i would like to do is like this: Have the current state frozen as
> it is, such that there is a fallback case (The dst is quite fragile and
> change at some place would break another. ie, what looks good for one
> DST variant is bad for the other). Work on a new tree (CX878) and
> migrate stuff to it. Remove the old one, once things are done.
> 
> I wouldn't want to mess up the current working situation and hence.

Hi Manu,

But it would be an acceptable compromise FOR NOW, wouldn't it?
So please don't turn your back on it, even if it may be incomplete for your needs.
Just add your SOB and then focus on cx878 with full power, OK?
Anything else would be terrible in pschological terms, you know?
Just think about Trent, Markus, me, so many others, you know.
Do I expect too much? Hope I do not!

Plus:

If I should help you it would be a pleasure for me if you could offer an acceptable time window that fulfills the following aims:

a. not to exhaust or threaten or bug you or nerve you (noone wants that, you know)
b. give me and others a feeling for when things of whatever issue are done and resolved, you know.

So at least for me it's very hard to continue if the whole thing looks like a never ending story, you know? So please give us a chance. And please do better this time.
Just learn and develop, you know.
And be more transparent and eloquent this time, but do not crawl back into a snail house, OK?

Waiting for your link meanwhile to download that hopeful project...
CCing some other persons who are perhaps interested in this....

Yours sincerely
Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
