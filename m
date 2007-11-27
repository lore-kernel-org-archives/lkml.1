Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXK0RJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXK0RJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbXK0RJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:09:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbXK0RJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:09:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mmc: Add missing sg_init_table() call
Date: Tue, 27 Nov 2007 18:27:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com> <20071127065703.63fea228@poseidon.drzeus.cx> <20071127085456.GC5029@kernel.dk>
In-Reply-To: <20071127085456.GC5029@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271827.04319.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of November 2007, Jens Axboe wrote:
> On Tue, Nov 27 2007, Pierre Ossman wrote:
> > On Mon, 26 Nov 2007 21:29:55 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > Pierre, I can queue this up but if you merge it into your tree I shall drop
> > > it and shall lose track of it.  So it's then all down to you to remember to
> > > get the fix into 2.6.24.
> > > 
> > > (Except this particular bug looks like a post-2.6.23 regression, so I can cc
> > > the Rafael which never forgets, so it will then get tracked all the way into
> > > Linus's tree)
> > > 
> > 
> > Jens said he applied it, so I figured the issue was handled. Jens,
> > what happened to it?
> 
> It's in my for-linus branch, it was applied when I wrote that reply. So
> it's going upstream, the pull request has been sent to Linus.
> 
> My error here was not updating the for-akpm branch that Andrew pulls, so
> he doesn't notice the patch. That is also updated now.

OK, so I'm not going to list it.

Thanks,
Rafael
