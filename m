Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbYCaTfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbYCaTfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYCaTfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:35:34 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40612 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYCaTfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:35:34 -0400
Date: Mon, 31 Mar 2008 22:35:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <lkml@rtr.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git5: Reported regressions from 2.6.24
Message-ID: <20080331193516.GC23259@cs181133002.pp.htv.fi>
References: <200803310228.11027.rjw@sisk.pl> <47F123DF.10204@rtr.ca> <20080331191733.GB23259@cs181133002.pp.htv.fi> <47F13A5A.7040305@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47F13A5A.7040305@rtr.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 03:24:10PM -0400, Mark Lord wrote:
> Adrian Bunk wrote:
>> On Mon, Mar 31, 2008 at 01:48:15PM -0400, Mark Lord wrote:
>>> Rafael,
>>>
>>> Add this one to the list?
>>
>>
>> That's not a regression from 2.6.24
> ..
>
> 2.6.24 does not flood my syslog with those messages.
> 2.6.25-rc* does.   Looks like a regression.
>
> The original bug was a hidden regression in 2.6.23,
> which nobody bothered to identify until now.

Let's try to get this patch into Linus' tree without arguing 
whether it might be called a post 2.6.24 regression or not.  ;)

> Just because some code "gets away with" a regression
> for a kernel or two, doesn't mean that regression shouldn't be fixed.

No disagreement on this one.

We already have over 200 known (and many more once reported) regressions 
in the kernel, and all of them should be fixed...

> Cheers

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

