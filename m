Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0BWMXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:23:23 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39910 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab0BWMXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:23:22 -0500
Date: Tue, 23 Feb 2010 13:23:20 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Benjamin S." <sbenni@gmx.de>
Subject: Re: [git patch] atang tree: fix 2.6.32 SSD performance regression
Message-ID: <20100223122320.GZ1025@kernel.dk>
References: <201002222224.35860.bzolnier@gmail.com> <20100223062324.GI1025@kernel.dk> <201002231317.01128.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002231317.01128.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23 2010, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 23 February 2010 07:23:24 am Jens Axboe wrote:
> > On Mon, Feb 22 2010, Bartlomiej Zolnierkiewicz wrote:
> > > DISCLAIMER: the fact of getting patches merged into atang tree means
> > > that from now on they will be getting updates for changes happening
> > > in atang tree and it should not be treated as an indication regarding
> > > decisions taken by 'upstream' kernel trees
> > > 
> > > 
> > > Fix 2.6.32 regression bringing back the desired SSD performance.
> > > 
> > > [ 'upstream' may want to wait for a proper resolution, for atang tree
> > >   performance of big non-ATA boxes owned by a very few people is not
> > >   of such a big concern as a major regression on a commodity hardware ]
> > 
> > What is the point of this, other than continuing your past history of
> > political tirades?
> 
> I worry that you may be reading too much into it -- I don't use Linus'
> tree or linux-next tree any longer so the next kernel I would see fix
> for the issue is most likely 2.6.34 and there is a little point from my
> personal perspective in waiting for such long time..

It'll go into 2.6.33, I already prepared an updated for-linus branch
this morning and will send it out later today.

-- 
Jens Axboe

