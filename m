Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbXEJD5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbXEJD5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEJD5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:57:34 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43708 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754478AbXEJD5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:57:33 -0400
Date: Thu, 10 May 2007 05:57:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: remove broken URLs from net drivers' output
Message-ID: <20070510035733.GE23574@stusta.de>
References: <200705092102.l49L2Re6028694@hera.kernel.org> <46424E12.9070307@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46424E12.9070307@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 06:41:22PM -0400, Jeff Garzik wrote:
> Linux Kernel Mailing List wrote:
>> Gitweb:     
>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2c2a8c531e953c753b06605c8ad6a9161ca527fa
>> Commit:     2c2a8c531e953c753b06605c8ad6a9161ca527fa
>> Parent:     b96687768a9ac0fdd005c7700093ebb24b93450f
>> Author:     Markus Dahms <dahms@fh-brandenburg.de>
>> AuthorDate: Wed May 9 07:58:10 2007 +0200
>> Committer:  Adrian Bunk <bunk@stusta.de>
>> CommitDate: Wed May 9 08:58:18 2007 +0200
>>     remove broken URLs from net drivers' output
>>         Remove broken URLs (www.scyld.com) from network drivers' logging 
>> output.
>>     URLs in comments and other strings are left intact.
>>         Signed-off-by: Markus Dahms <dahms@fh-brandenburg.de>
>>     Acked-by: Jesper Juhl <jesper.juhl@gmail.com>
>>     Acked-by: Alan Cox <alan@redhat.com>
>>     igned-off-by: Adrian Bunk <bunk@stusta.de>
>> ---
>>  drivers/net/3c509.c     |    5 ++---
>>  drivers/net/3c59x.c     |    2 +-
>>  drivers/net/atp.c       |    8 +++-----
>>  drivers/net/eepro100.c  |    2 +-
>>  drivers/net/epic100.c   |   10 ++++------
>>  drivers/net/natsemi.c   |    1 -
>>  drivers/net/ne2k-pci.c  |    3 +--
>>  drivers/net/sundance.c  |    3 +--
>>  drivers/net/yellowfin.c |    1 -
>>  9 files changed, 13 insertions(+), 22 deletions(-)
>
> Grumble...  This stuff should go through my tree.

It had been sent twice to both linux-kernel and netdev, and when going 
through old linux-kernel emails I considered it trivial enough (people 
might argue about dead email addresses, but not about dead URLs).

I could send such patches to Andrew for that he includes them in -mm and 
therefore will include them in his huge list of "forward again and again 
to the maintainer until there is any reaction" patches.

But IMHO for such trivial patches it's enough if the maintainer had the 
chance to veto them.

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

