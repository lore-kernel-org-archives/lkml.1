Return-Path: <linux-kernel-owner+w=401wt.eu-S1946212AbXBCBj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946212AbXBCBj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946216AbXBCBj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:39:29 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59062 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946212AbXBCBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:39:28 -0500
Date: Sat, 3 Feb 2007 02:39:30 +0100
From: Adrian Bunk <bunk@stusta.de>
To: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: reiserfs-dev@namesys.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How many people are using 2.6.16?
Message-ID: <20070203013930.GP3754@stusta.de>
References: <45BE5948.6060403@redhat.com> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org> <20070131070237.GT3754@stusta.de> <200702011513.04627.vs@namesys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011513.04627.vs@namesys.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 03:13:03PM +0300, Vladimir V. Saveliev wrote:
> Hello

Hi Vladimir,

> On Wednesday 31 January 2007 10:02, Adrian Bunk wrote:
>...
> > reiserfs:
> > commit de14569f94513279e3d44d9571a421e9da1759ae
> >   [PATCH] resierfs: avoid tail packing if an inode was ever mmapped
> > backport to 2.6.16 required
> 
> Here it goes:
>...

thanks a lot, applied to 2.6.16.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

