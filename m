Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0BWMg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:36:58 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34206 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0BWMg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:36:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=nv0RYKoM54Nyrl+7XbIjIOXCuxyFuGtKDn2SMo0xqZuC/iZvPvFqRf3NMx7V0rfjTa
         p3oYd8DN8zDIizrDbI2McQTpQc3Po0KtF4njwS7SmXlXm2tiCiTKWcv81kU3wgFBjU1M
         zOe+8Dws4nEjJu/uQA1BLkut4ZZ6zKxmd1k+A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patch] atang tree: fix 2.6.32 SSD performance regression
Date: Tue, 23 Feb 2010 13:36:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Benjamin S." <sbenni@gmx.de>
References: <201002222224.35860.bzolnier@gmail.com> <201002231317.01128.bzolnier@gmail.com> <20100223122320.GZ1025@kernel.dk>
In-Reply-To: <20100223122320.GZ1025@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002231336.04901.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010 01:23:20 pm Jens Axboe wrote:
> On Tue, Feb 23 2010, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 23 February 2010 07:23:24 am Jens Axboe wrote:
> > > On Mon, Feb 22 2010, Bartlomiej Zolnierkiewicz wrote:
> > > > DISCLAIMER: the fact of getting patches merged into atang tree means
> > > > that from now on they will be getting updates for changes happening
> > > > in atang tree and it should not be treated as an indication regarding
> > > > decisions taken by 'upstream' kernel trees
> > > > 
> > > > 
> > > > Fix 2.6.32 regression bringing back the desired SSD performance.
> > > > 
> > > > [ 'upstream' may want to wait for a proper resolution, for atang tree
> > > >   performance of big non-ATA boxes owned by a very few people is not
> > > >   of such a big concern as a major regression on a commodity hardware ]
> > > 
> > > What is the point of this, other than continuing your past history of
> > > political tirades?
> > 
> > I worry that you may be reading too much into it -- I don't use Linus'
> > tree or linux-next tree any longer so the next kernel I would see fix
> > for the issue is most likely 2.6.34 and there is a little point from my
> > personal perspective in waiting for such long time..
> 
> It'll go into 2.6.33, I already prepared an updated for-linus branch
> this morning and will send it out later today.

Great!  I'll just drop my patch during re-base to 2.6.33 then..

--
Bartlomiej Zolnierkiewicz
