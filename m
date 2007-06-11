Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbXFKCV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbXFKCV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 22:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762947AbXFKCVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 22:21:20 -0400
Received: from pumpkin.explorerforum.com ([209.209.36.42]:40538 "EHLO
	pumpkin.explorerforum.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763203AbXFKCVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 22:21:19 -0400
X-Greylist: delayed 2517 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2007 22:21:19 EDT
Message-ID: <466CA75B.4040803@nersc.gov>
Date: Sun, 10 Jun 2007 18:37:31 -0700
From: Thomas Davis <tdavis@nersc.gov>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
Subject: Re: Jinxed VAIO wreckage - current state of affairs
References: <1181418873.4404.402.camel@chaos> <200706092259.50694.rjw@sisk.pl> <20070609200827.635fec79.akpm@linux-foundation.org>
In-Reply-To: <20070609200827.635fec79.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (pumpkin.explorerforum.com [209.209.36.42]); Sun, 10 Jun 2007 18:38:06 -0700 (PDT)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 9 Jun 2007 22:59:49 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
>> Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?
> 
> People would have heard if it was busted ;)
> 
> Have seen occasional hangs in e100 resume-from-RAM, and occasional
> all-black-and-dead symptoms after resume-from-RAM, but it seems to work at
> least 90% of the time.

You doing than I am on my S580p.

if AHCI is loaded, damn thing will not turn off.  Goofy part is, another 
Sony S80p at work does NOT have this probelm - same bios, same drive 
firmware.

Suspend to disk mostly works - sometimes when you return, the screen is 
kinda wonky.

Suspend to ram - going in appears to work, coming out it's dead.

thomas
