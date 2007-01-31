Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXAaRYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXAaRYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030377AbXAaRYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:24:07 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53436 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030351AbXAaRYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:24:04 -0500
Date: Wed, 31 Jan 2007 18:24:10 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
Message-ID: <20070131172410.GV3754@stusta.de>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p7364anpkz5.fsf_-_@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 11:08:14AM +0100, Andi Kleen wrote:
> Greg KH <greg@kroah.com> writes:
> > 
> > What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> > that floppy.c is?  Do you want everyone just to run screaming from
> > kernel development never to be seen again?
> 
> Doing a from-scratch rewrite of floppy.c only supporting new
> hardware and no obscure formats ("newfloppy.c") would be an excellent 
> newbie project imho.  This means for someone who is still pretty
> new, but wants to get their fingers wet with more complicated changes.
> 
> Then over time (old-)floppy.c could be phased out.
>...

Considering how widespread floppies are, these two sentences are
contradictions.

If the goal is to phase out the old floppy driver, a new driver will 
have to gain support for more or less all hardware the old driver 
supports...

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

