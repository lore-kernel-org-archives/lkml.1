Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXCJWe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXCJWe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXCJWez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:34:55 -0500
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:38921 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbXCJWez convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:34:55 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [PATCH][RSDL-mm 0/6]  Rotating Staircase DeadLine scheduler   for -mm
Date: Sun, 11 Mar 2007 10:01:15 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <1173527368.3380.1.camel@rousalka.dyndns.org> <200703110103.21224.kernel@kolivas.org> <1173545608.4143.10.camel@rousalka.dyndns.org>
In-Reply-To: <1173545608.4143.10.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703111001.15682.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 03:53, Nicolas Mailhot wrote:
> Le dimanche 11 mars 2007 à 01:03 +1100, Con Kolivas a écrit :
> > On Saturday 10 March 2007 22:49, Nicolas Mailhot wrote:
> > > Oops
> > >
> > > ⇒ http://bugzilla.kernel.org/show_bug.cgi?id=8166
> >
> > Thanks very much. I can't get your config to boot on qemu, but could you
> > please try this debugging patch? It's not a patch you can really run the
> > machine with but might find where the problem occurs. Specifically I'm
> > looking for the warning MISSING STATIC BIT in your case.
> >
> > http://ck.kolivas.org/patches/crap/sched-rsdl-0.28-stuff.patch
>
> I attached a screenshot of the patched kernel boot

Thanks. Darn the debugging didn't catch anything. Did you see any BUG during 
the boot earlier than that screenshot? Probably not. 

If you have the time I would appreciate you testing 2.6.20 with the rsdl 0.28 
patch for it with a config as close to this -mm2 one as possible.

http://ck.kolivas.org/patches/staircase-deadline/2.6.20-sched-rsdl-0.28.patch

and see if the bug recurs please?

Thanks!

-- 
-ck
