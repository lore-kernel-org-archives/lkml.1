Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbXDZRi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbXDZRi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXDZRi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:38:56 -0400
Received: from mail.tmr.com ([64.65.253.246]:47880 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbXDZRiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:38:55 -0400
Message-ID: <4630E3C4.20003@tmr.com>
Date: Thu, 26 Apr 2007 13:39:16 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> In other words, there's a _reason_ we have staggered development. We have 
> the "crazy development trees" (aka -mm and various other trees), we have 
> the "development tree" (aka Linus' tree), and we have the -stable tree. If 
> the stable tree has a dozen known issues that they'll have to sort out 
> over the next two months, that's *fine*. That's kind of the point of the 
> stable tree.
> 
If the result is fixing things which then don't get fixed in mainline, 
as Adrian notes, then there is something wrong with the process, and why 
will people bother to work on stable if they have doubts that there will 
be long term benefit.

With all the effort the regressions list takes and the stable group puts 
into fixes, someone in charge should insist that regressions fixed in 
stable be fixed in mainline. Since there's only one "someone in charge" 
of policy, I think that's a reasonable commitment to the people doing 
the work.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
