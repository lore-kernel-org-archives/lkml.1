Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbXEJEsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbXEJEsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXEJEsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:48:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43723 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbXEJEsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:48:00 -0400
Date: Thu, 10 May 2007 06:47:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Markus Dahms <dahms@fh-brandenburg.de>
Subject: Re: remove broken URLs from net drivers' output
Message-ID: <20070510044759.GG23574@stusta.de>
References: <200705092102.l49L2Re6028694@hera.kernel.org> <46424E12.9070307@garzik.org> <9a8748490705091604l32b0e6depbc079f69897b34e0@mail.gmail.com> <20070510040739.GF23574@stusta.de> <46429E23.6050404@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46429E23.6050404@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:22:59AM -0400, Jeff Garzik wrote:
> Adrian Bunk wrote:
>> I thought it was just an informal tag to mark which people did agree with 
>> the patch (and the line between your "Makes good sense to me." and a "Feel 
>> free to add my ACK to this" is really thin).
>
> No, the line is easy and obvious:  if there is any doubt, DO NOT ASSUME.
> 
> If they do not explicitly ACK it, then do not presume to speak for them.

There is no doubt that Jesper did explicitly ACK the patch.
We are ONLY discussing whether his informal ACK can be translated into 
an "Acked-by:" line.

The line I mentioned only exists if "Acked-by:" is considered a formal 
tag someone must explicitely give, and not an informal indication that 
someone agrees with the patch. But in this case, we should better 
require people to give explicit "Acked-by:" lines, like we already 
require for "Signed-off-by:" lines.

I've seen many cases where people other than me added "Acked-by:" tags 
when there was only a "Makes good sense to me." or "Fine with me.", but 
no formal "Acked-by:" given.

If "Acked-by:" should be considered a formal tag, it
- should be documented in Documentation/SubmittingPatches and
- the practice must change to always require people to give
  a formal "Acked-by:".

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

