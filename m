Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZHXIE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZHXIE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZHXIE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:04:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57369 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZHXIE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:04:27 -0400
Date: Mon, 24 Aug 2009 10:04:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Junio C Hamano <junio@pobox.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/6] Lazy workqueues
Message-ID: <20090824080429.GC12579@kernel.dk>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com> <1250769861.8282.182.camel@twins> <20090820120858.GJ12579@kernel.dk> <1250770571.8282.186.camel@twins> <7vfxbj1car.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vfxbj1car.fsf@alter.siamese.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 22 2009, Junio C Hamano wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Thu, 2009-08-20 at 14:08 +0200, Jens Axboe wrote:
> > ...
> >> That's pretty new... But perhaps I should complain too, it's been
> >> annoying me forever.
> >
> > http://marc.info/?l=git&m=123457137328461&w=2
> >
> > Apparently it didn't happen, nor did I ever see a reply to that posting.
> >
> > Junio, what happened here?
> 
> Nothing happened.
> 
> I do not recall anybody objecting to, but then when nothing happened in
> neither 1.6.3 nor 1.6.4, nobody jumped up-and-down demanding the change of
> default either.  So overall impression I got from this was that nobody
> really cared deeply enough either way.

That's some strange logic right there :-). Of course nobody complained,
they thought it was a done deal.

> But we are talking about 1.7.0 to become a release to correct wrong
> defaults we have had once and for all ;-), and I am tempted to roll this
> topic into the mix.  Here is what I queued to my 'next' branch tonight.

OK that's at least something, looking forward to being able to prune
that argument from my scripts. It completely destroys viewability of
larger patchsets.

-- 
Jens Axboe

