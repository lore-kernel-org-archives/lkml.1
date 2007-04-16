Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXDPASx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXDPASx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXDPASx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:18:53 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:5400 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbXDPASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bGhdBjUM5HA5jIq0zOFXV2BBPcbRD9q5kOEucNgURDmJ+srHEG11UBV5l4UgX+LiVRiNRuqotZDtyU6Y0xCkofZDUgx1jW9fWzstTILM09BkDGPMQseBQav5uOWRmvxqjzUiZh3Li26sv5UOS11rf8CSUP8KDr6KTjgtRdfhhPY=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Sun, 15 Apr 2007 20:18:48 -0400
User-Agent: KMail/1.9.6
Cc: Con Kolivas <kernel@kolivas.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704151258.48857.gene.heskett@verizon.net> <1176660032.6364.32.camel@Homer.simpson.net>
In-Reply-To: <1176660032.6364.32.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704152018.48500.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007, Mike Galbraith wrote:
>On Sun, 2007-04-15 at 12:58 -0400, Gene Heskett wrote:
>> Chuckle, possibly but then I'm not anything even remotely close to an
>> expert here Con, just reporting what I get.  And I just rebooted to
>> 2.6.21-rc6 + sched-mike-5.patch for grins and giggles, or frowns and
>> profanity as the case may call for.
>
>Erm, that patch is embarrassingly buggy, so profanity should dominate.
>
>	-Mike

Chuckle, ROTFLMAO even.

I didn't run it that long as I immediately rebuilt and rebooted when I found 
I'd used the wrong patch, and in fact had tested that one and found it 
sub-optimal before I'd built and ran Con's -0.40 version.  As for bugs of the 
type that make it to the screen or logs, I didn't see any.  OTOH, my eyesight 
is slowly going downhill, now 20/25.  It was 20/10 30 years ago.  Now thats 
reason for profanity...

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Unix weanies are as bad at this as anyone.
             -- Larry Wall in <199702111730.JAA28598@wall.org>
