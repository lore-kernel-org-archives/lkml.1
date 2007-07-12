Return-Path: <linux-kernel-owner+w=401wt.eu-S936766AbXGLA1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936766AbXGLA1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936293AbXGLASS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:18:18 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:54864 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964950AbXGLASO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:18:14 -0400
Date: Wed, 11 Jul 2007 17:17:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stable Team <stable@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [stable] generic clockevents/ (hr)time(r) patches was Re: -mm
	merge plans for 2.6.23
Message-ID: <20070712001718.GE4306@sequoia.sous-sol.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <1184195008.12353.182.camel@chaos> <20070711165751.b703f003.akpm@linux-foundation.org> <1184198662.12353.201.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184198662.12353.201.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> Andrew,
> 
> On Wed, 2007-07-11 at 16:57 -0700, Andrew Morton wrote:
> > They all look pretty innocuous to me.
> > 
> > Could you please take a second look, decide if any of them should also be
> > in 2.6.22.x and let me know?
> 
> i386-hpet-check-if-the-counter-works.patch
> pcspkr-use-the-global-pit-lock.patch
> 
> are the only candidates.

yup, come through -stable a few times, be great to get them upstream,
and into .22.y

thanks,
-chris
