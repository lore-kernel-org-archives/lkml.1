Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbXEJE6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbXEJE6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXEJE6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:58:32 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43728 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754682AbXEJE6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:58:31 -0400
Date: Thu, 10 May 2007 06:58:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: remove broken URLs from net drivers' output
Message-ID: <20070510045831.GH23574@stusta.de>
References: <200705092102.l49L2Re6028694@hera.kernel.org> <46424E12.9070307@garzik.org> <20070510035733.GE23574@stusta.de> <46429E59.1050505@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46429E59.1050505@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:23:53AM -0400, Jeff Garzik wrote:
> Adrian Bunk wrote:
>> It had been sent twice to both linux-kernel and netdev, and when going 
>> through old linux-kernel emails I considered it trivial enough (people 
>> might argue about dead email addresses, but not about dead URLs).
>> I could send such patches to Andrew for that he includes them in -mm and 
>> therefore will include them in his huge list of "forward again and again 
>> to the maintainer until there is any reaction" patches.
>> But IMHO for such trivial patches it's enough if the maintainer had the 
>> chance to veto them.
>
>
> Please follow the rule that everybody else follows:  send to me and netdev. 
>  It's that simple :)

This doesn't answer the main question:
How often, if there's no maintainer reaction?

It happens that Andrew forwards patches from me in -mm 5 or 10 times to 
a maintainer until he gets any reaction from the maintainer.

Before I'd start the same with trivial patches, it would be easier to 
change the "trivial@kernel.org" mail alias to point to Andrew so that 
trivial patches can also become part of his "forward patches to 
maintainers again and again until there's any reaction" process.

That's not meant as a threat or anything like that, it's a serious 
suggestion to avoid duplicated work.

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

