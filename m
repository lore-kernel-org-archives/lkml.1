Return-Path: <linux-kernel-owner+w=401wt.eu-S936463AbXGLAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936463AbXGLAr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXGLArs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:47:48 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:40999 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXGLArr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:47:47 -0400
Date: Wed, 11 Jul 2007 17:46:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stable Team <stable@kernel.org>
Subject: Re: [stable] generic clockevents/ (hr)time(r) patches was Re: -mm
	merge plans for 2.6.23
Message-ID: <20070712004622.GG4306@sequoia.sous-sol.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070711165751.b703f003.akpm@linux-foundation.org> <1184198662.12353.201.camel@chaos> <200707120243.09999.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707120243.09999.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> Ok by me, although I suspect a lot of the cases where the hpet one
> was needed got resolved with the PCI HPET resource fix But it's still
> safer to check.
> 
> However I don't think patches should go into stable before they 
> hit Linus' tree.

Agreed, we're just waiting ;-)

thanks,
-chris
