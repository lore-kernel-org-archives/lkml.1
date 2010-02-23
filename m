Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0BWMV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:21:29 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63342 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0BWMVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:21:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=mm28tYBnzaW8d0S0g2GA3Fqs/1i1QEA1cPBugEfhKsP3x+U22LQOe+6yaDVPCbcrOq
         MNopBX4/U7iy2IQn4mZPdBpLfPvVjGSy1sbENuPj4A1tjArGRD40XBAaKjozXHFN7Kue
         EjBEnQatI7Z3d+L/4yH/zR++4lrRZBrgmcF24=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patch] atang tree: fix 2.6.32 SSD performance regression
Date: Tue, 23 Feb 2010 13:17:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Benjamin S." <sbenni@gmx.de>
References: <201002222224.35860.bzolnier@gmail.com> <20100223062324.GI1025@kernel.dk>
In-Reply-To: <20100223062324.GI1025@kernel.dk>
MIME-Version: 1.0
Message-Id: <201002231317.01128.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010 07:23:24 am Jens Axboe wrote:
> On Mon, Feb 22 2010, Bartlomiej Zolnierkiewicz wrote:
> > DISCLAIMER: the fact of getting patches merged into atang tree means
> > that from now on they will be getting updates for changes happening
> > in atang tree and it should not be treated as an indication regarding
> > decisions taken by 'upstream' kernel trees
> > 
> > 
> > Fix 2.6.32 regression bringing back the desired SSD performance.
> > 
> > [ 'upstream' may want to wait for a proper resolution, for atang tree
> >   performance of big non-ATA boxes owned by a very few people is not
> >   of such a big concern as a major regression on a commodity hardware ]
> 
> What is the point of this, other than continuing your past history of
> political tirades?

I worry that you may be reading too much into it -- I don't use Linus'
tree or linux-next tree any longer so the next kernel I would see fix
for the issue is most likely 2.6.34 and there is a little point from my
personal perspective in waiting for such long time..

--
Bartlomiej Zolnierkiewicz
