Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXEJEHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXEJEHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbXEJEHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:07:41 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43715 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568AbXEJEHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:07:38 -0400
Date: Thu, 10 May 2007 06:07:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Markus Dahms <dahms@fh-brandenburg.de>
Subject: Re: remove broken URLs from net drivers' output
Message-ID: <20070510040739.GF23574@stusta.de>
References: <200705092102.l49L2Re6028694@hera.kernel.org> <46424E12.9070307@garzik.org> <9a8748490705091604l32b0e6depbc079f69897b34e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a8748490705091604l32b0e6depbc079f69897b34e0@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:04:24AM +0200, Jesper Juhl wrote:
> On 10/05/07, Jeff Garzik <jeff@garzik.org> wrote:
>> Linux Kernel Mailing List wrote:
>> > Gitweb:     
>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2c2a8c531e953c753b06605c8ad6a9161ca527fa
>> > Commit:     2c2a8c531e953c753b06605c8ad6a9161ca527fa
>> > Parent:     b96687768a9ac0fdd005c7700093ebb24b93450f
>> > Author:     Markus Dahms <dahms@fh-brandenburg.de>
>> > AuthorDate: Wed May 9 07:58:10 2007 +0200
>> > Committer:  Adrian Bunk <bunk@stusta.de>
>> > CommitDate: Wed May 9 08:58:18 2007 +0200
>> >
>> >     remove broken URLs from net drivers' output
>> >
>> >     Remove broken URLs (www.scyld.com) from network drivers' logging 
>> output.
>> >     URLs in comments and other strings are left intact.
>> >
>> >     Signed-off-by: Markus Dahms <dahms@fh-brandenburg.de>
>> >     Acked-by: Jesper Juhl <jesper.juhl@gmail.com>
>> >     Acked-by: Alan Cox <alan@redhat.com>
>> >     igned-off-by: Adrian Bunk <bunk@stusta.de>
>> > ---
>> >  drivers/net/3c509.c     |    5 ++---
>> >  drivers/net/3c59x.c     |    2 +-
>> >  drivers/net/atp.c       |    8 +++-----
>> >  drivers/net/eepro100.c  |    2 +-
>> >  drivers/net/epic100.c   |   10 ++++------
>> >  drivers/net/natsemi.c   |    1 -
>> >  drivers/net/ne2k-pci.c  |    3 +--
>> >  drivers/net/sundance.c  |    3 +--
>> >  drivers/net/yellowfin.c |    1 -
>> >  9 files changed, 13 insertions(+), 22 deletions(-)
>>
>> Grumble...  This stuff should go through my tree.
>>
>>         Jeff
>>
>
> Note, just for the record; I never explicitly added an Acked-by to
> this patch, I only said in a conversational email that it made sense
> to me...
> I don't actually mind, in this case, to have an Acked-by tagged on
> with my name,  but in general I think that such lines should only be
> added when people explicitly say Acked-by: John Doe, or something like
> "Feel free to add my ACK to this" etc.

Did I miss that "Acked-by:" is considered to be a formal tag like 
"Signed-off-by:"?

I thought it was just an informal tag to mark which people did agree 
with the patch (and the line between your "Makes good sense to me." 
and a "Feel free to add my ACK to this" is really thin).

> Jesper Juhl

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

