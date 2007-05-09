Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbXEIWle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbXEIWle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXEIWl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:41:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49530 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbXEIWl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:41:27 -0400
Message-ID: <46424E12.9070307@garzik.org>
Date: Wed, 09 May 2007 18:41:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: remove broken URLs from net drivers' output
References: <200705092102.l49L2Re6028694@hera.kernel.org>
In-Reply-To: <200705092102.l49L2Re6028694@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2c2a8c531e953c753b06605c8ad6a9161ca527fa
> Commit:     2c2a8c531e953c753b06605c8ad6a9161ca527fa
> Parent:     b96687768a9ac0fdd005c7700093ebb24b93450f
> Author:     Markus Dahms <dahms@fh-brandenburg.de>
> AuthorDate: Wed May 9 07:58:10 2007 +0200
> Committer:  Adrian Bunk <bunk@stusta.de>
> CommitDate: Wed May 9 08:58:18 2007 +0200
> 
>     remove broken URLs from net drivers' output
>     
>     Remove broken URLs (www.scyld.com) from network drivers' logging output.
>     URLs in comments and other strings are left intact.
>     
>     Signed-off-by: Markus Dahms <dahms@fh-brandenburg.de>
>     Acked-by: Jesper Juhl <jesper.juhl@gmail.com>
>     Acked-by: Alan Cox <alan@redhat.com>
>     igned-off-by: Adrian Bunk <bunk@stusta.de>
> ---
>  drivers/net/3c509.c     |    5 ++---
>  drivers/net/3c59x.c     |    2 +-
>  drivers/net/atp.c       |    8 +++-----
>  drivers/net/eepro100.c  |    2 +-
>  drivers/net/epic100.c   |   10 ++++------
>  drivers/net/natsemi.c   |    1 -
>  drivers/net/ne2k-pci.c  |    3 +--
>  drivers/net/sundance.c  |    3 +--
>  drivers/net/yellowfin.c |    1 -
>  9 files changed, 13 insertions(+), 22 deletions(-)

Grumble...  This stuff should go through my tree.

	Jeff


