Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbZHXHGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbZHXHGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZHXHGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:06:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:49070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZHXHGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:06:30 -0400
Subject: git send-email defaults
From: Peter Zijlstra <peterz@infradead.org>
To: Junio C Hamano <junio@pobox.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <7vfxbj1car.fsf@alter.siamese.dyndns.org>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
	 <1250769861.8282.182.camel@twins> <20090820120858.GJ12579@kernel.dk>
	 <1250770571.8282.186.camel@twins> <7vfxbj1car.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 09:04:50 +0200
Message-Id: <1251097490.7538.127.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-22 at 19:42 -0700, Junio C Hamano wrote:
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

And here I was thinking it was settled when no objections came ;-)

> But we are talking about 1.7.0 to become a release to correct wrong
> defaults we have had once and for all ;-), and I am tempted to roll this
> topic into the mix.  Here is what I queued to my 'next' branch tonight.

The sooner this hits the distros the better.. 

Thanks for committing the change, looking fwd to 1.7
