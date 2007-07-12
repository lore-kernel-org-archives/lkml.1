Return-Path: <linux-kernel-owner+w=401wt.eu-S937485AbXGLAQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937485AbXGLAQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbXGLAQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:16:36 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:54837 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763017AbXGLAQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:16:35 -0400
Date: Wed, 11 Jul 2007 17:15:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070712001539.GD4306@sequoia.sous-sol.org>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos> <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org> <20070711233618.GD25510@one.firstfloor.org> <20070711235852.GA625@elte.hu> <20070712000720.GA26585@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712000720.GA26585@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> The equivalent to the powerpc way would be essentially to report i386
> into the x86-64 code base and leave the really old hardware only
> in arch/i386. I've considered doing it, but it would be an awful
> lot of work and to tempt distributions to actually use the new
> port would require going back quite a long time. And at least
> immediately it would end up with three cases to do things instead
> of two like currently.

Well that's just silly.  The right way will never create 3 ways, but
always keep the limit to the existing 2 where the differences aren't
worth reconciling, and 1 for anything that is common.

It will be a fair amount of work, so any constructive input you have
upfront would be helpful.

thanks,
-chris
