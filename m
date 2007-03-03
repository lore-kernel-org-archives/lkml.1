Return-Path: <linux-kernel-owner+w=401wt.eu-S1030665AbXCCPrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030665AbXCCPrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030666AbXCCPrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:47:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:40275 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030665AbXCCPri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:47:38 -0500
Cc: akpm@linux-foundation.org, eranian@hpl.hp.com, bunk@stusta.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       jirislaby@gmail.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 03 Mar 2007 16:47:37 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <200703011831.26520.mws@linuxtv.org>
Message-ID: <20070303154737.65380@gmx.net>
MIME-Version: 1.0
References: <20070301143407.29950@gmx.net> <200703011831.26520.mws@linuxtv.org>
Subject: Re: [linux-dvb] 2.6.21-rc1-git2 is incompilable
To: Marcel Siegert <mws@linuxtv.org>, linux-dvb@linuxtv.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/yJ6UEDGjyo2wszRJBw2id1cgeN3YkfeB7kbWeJ4
 WPpmhCE5EJoo8XW/EoRFlkfnksn+psnv8aTg== 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Thu, 1 Mar 2007 18:31:25 +0100
Von: Marcel Siegert <mws@linuxtv.org>
An: linux-dvb@linuxtv.org
CC: "Uwe Bugla" <uwe.bugla@gmx.de>, torvalds@linux-foundation.org, Slaby <jirislaby@gmail.com>, venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org, bunk@stusta.de, Stephane Eranian <eranian@hpl.hp.com>, akpm@linux-foundation.org
Betreff: Re: [linux-dvb] 2.6.21-rc1-git2 is incompilable

> On Thursday 01 March 2007, Uwe Bugla wrote:
> > Hi folks,
> > trying to compile kernel 2.6.21-rc1-git2 is impossible. The broken
> module where the compiler gives up is /arch/i386/kernel/io_apic.c.
> > 
> > Regards
> > 
> > Uwe
> > 
> > P. S.: Wouldn't it be a good idea to test at least error-free
> compilation before stuff like this is being published?
> > 
> 
> hi uwe,
> 
> according to kernel.org 
> 2.6.21-rc2-git1 is an actual snapshot
> 
> but, those are iirc auto generated. thus not being able to compile can
> happen.
> it also depends on your special .config
> 
> best regards
> marcel
> 
> p.s. wouldn't it be a good idea to check your mail recipients instead of
> sending mails to e.g. linux-dvb that do 
>       have no use with fixes of floppy drivers and or compile status in
> io_apic? :)
> 
> dont take it too hard man...
But I take it very hard as I want quality!

Ciao

Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
