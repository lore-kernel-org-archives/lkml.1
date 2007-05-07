Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXEGAFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXEGAFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXEGAFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:05:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:34461 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbXEGAFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:05:15 -0400
Message-ID: <463E6D18.1080902@tmr.com>
Date: Sun, 06 May 2007 20:04:40 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Damien Wyart <damien.wyart@free.fr>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch] CFS scheduler, -v8
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu> <20070503132932.GA4204@localhost.localdomain>
In-Reply-To: <20070503132932.GA4204@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Damien Wyart wrote:
> Hello,
> 
> * Ingo Molnar <mingo@elte.hu> [2007-05-03 15:02]:
>> great! So it seems -v8 does improve OpenGL handling too :-)
> 
> What are your thoughts/plans concerning merging CFS into mainline ? Is
> it a bit premature to get it into 2.6.22 ? I remember Linus was ok to
> change the default scheduler rapidly (the discussion was about sd at
> that time) to get more testing than in -mm.
> 
It would seem that a number of us are testing the variants and reporting 
results (I now have to pull all the new versions and redo stuff, but I 
have a new test I'm going to run as well).

Given that and the fact that there is another idea which can be tested 
from Tong Li, I think that decision can be postponed, Linus willing. 
There appear to be enough testers to be driving evolution now, authors 
may disagree, of course.

Several folks added to cc list...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
