Return-Path: <linux-kernel-owner+w=401wt.eu-S1762991AbZFQWui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762991AbZFQWui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbZFQWu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:50:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44918 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444AbZFQWu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:50:27 -0400
Date: Wed, 17 Jun 2009 18:50:23 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: dm-devel@redhat.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: init_emergency_isa_pool calling mempool_create in non-sleeping
	context
Message-ID: <20090617225022.GC9405@redhat.com>
References: <4A396195.8060503@goop.org> <0f79c2d4513c50184383e223d3d2ee97.squirrel@neil.brown.name> <20090617224219.GA9405@redhat.com> <4A3971FE.7040700@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3971FE.7040700@goop.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17 2009 at  6:45pm -0400,
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 06/17/09 15:42, Mike Snitzer wrote:
> > This has been resolved and is waiting to be pushed along with the rest
> > of the DM changes for 2.6.31.
> >
> > See:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-table-establish-queue-limits-by-copying-table-limits.patch
> >   
> 
> OK, good to know.
> 
> > Maybe this fix should go now rather than wait a day or so for the larger
> > DM push?
> >   
> 
> The machine booted fine with no apparent badness, so I don't think its
> urgent.  I just reported it for diligence's sake.

OK, thanks.

Mike
