Return-Path: <linux-kernel-owner+w=401wt.eu-S1751088AbXBMVbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbXBMVbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXBMVbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:31:51 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46700 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbXBMVbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:31:50 -0500
Date: Tue, 13 Feb 2007 16:31:43 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Sergei Organov <osv@javad.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?iso-8859-1?B?Si5BLiBNYWdhbGzDw8Kzbg==?= <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Message-ID: <20070213213143.GA24625@havoc.gtf.org>
References: <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org> <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org> <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org> <87ps8end9b.fsf@javad.com> <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com> <87bqjxooog.fsf@javad.com> <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com> <87fy99n6mf.fsf@javad.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fy99n6mf.fsf@javad.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:29:44PM +0300, Sergei Organov wrote:
> Sorry, what do you do with "variable 'xxx' might be used uninitialized"
> warning when it's false? Turn it off? Annotate the source? Assign fake
> initialization value? Change the compiler so that it does "the effort"
> for you? Never encountered false positive from this warning?

You pull git://git.kernel.org/...jgarzik/misc-2.6.git#gccbug

	Jeff



