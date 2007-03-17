Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbXCQFQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbXCQFQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 01:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933342AbXCQFQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 01:16:16 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45750 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbXCQFQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 01:16:16 -0400
Date: Sat, 17 Mar 2007 01:15:41 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL v0.31
In-reply-to: <200703171557.53700.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, Al Boldi <a1426z@gawab.com>,
       ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200703170115.43210.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
 <200703170740.07530.a1426z@gawab.com> <200703171557.53700.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Con & company;

I built and rebooted to 2.6.20.3-rdsl-0.31 earlier this evening, but 
purposely waited till amanda was well underway to make a report.

The report is that I really really have to work hard to tell that amanda 
is running even though the cpu according to gkrellm is running between 97 
and 99%.

For my loading then, this is as much an improvement over the -ck1 patch as 
it was over the un-patched but same version of the kernel.  FWIW, I'd 
also built a 2.6.20.3-rdsl-0.30 and ran it for a day but it was nearly as 
spastic as no patch.

Did I say I like this yet? :)

Now I'm waiting for 2.6.21-rc4 to make the mirrors & see if tar is still 
broken.  Based on the clues I've been able to find, I bz'd the tar since 
that's a fedora supplied rpm install.  Humm, I just now recalled that I 
have a tarball built tar-1.15.1 on another drive, I was using it when I 
was running FC2, so that might be something else to bisect against, and I 
will, bet on it.

Many thanks Con, this is very nice.  I've only seen one split second when 
the screen was about 2 chars behind my typing.  This is great. :-)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
When a cow laughs, does milk come out of its nose?
