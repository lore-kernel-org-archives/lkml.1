Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbXDZVV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbXDZVV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbXDZVV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:21:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:29593 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbXDZVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qRSQx+fzkLBtiXo3wNVng7kSD7mKFeqg3DuylrzxVHOjt3NLQONFB3XGaGJpHDqugiUw9PDQ3t02yzcZy1g8K0GSq0CagrHs3NAMHsaqBzmZz0v/fyql0Jb3p22wkqSYh0Zd6mzkugl2qhhKKgwgMGbP39++xqDBGU9Cq20IHHY=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: [patch] CFS scheduler, -v6
Date: Thu, 26 Apr 2007 17:21:22 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
References: <20070425214704.GA32572@elte.hu> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost>
In-Reply-To: <1177618164.14496.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261721.22758.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007, Kasper Sandberg wrote:
>On Thu, 2007-04-26 at 10:41 -0400, Gene Heskett wrote:
><snip>
>
>> Compared to mainline?  I still think this is a 100% keeper for desktop
>> users like me.
>
>Here its alot worse, just playing an ogg with ogg123 even without
>anything reniced (X is 0), just pressing a link in konqueror can make
>audio skip (ogg123 fails to fill the alsa buffer, and thus it skips).
>this is something that simply does not happen for me on vanilla,
>staircase or SD.
>
>it just doesent seem to work properly..

I wish I could throw a clue about what I might be doing different, but every 
skip I've heard so far has been an mplayer artifact due to a spastic dls 
connection.  Every locally sourced audio or avi type file I've tried so far 
has worked very smoothly.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
PIZZA!!
