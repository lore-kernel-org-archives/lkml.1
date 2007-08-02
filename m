Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXHBPXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXHBPXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXHBPXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:23:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbXHBPXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:23:01 -0400
Date: Thu, 2 Aug 2007 17:22:57 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Hua Zhong <hzhong@gmail.com>,
       "'Carlo Florendo'" <subscribermail@gmail.com>,
       "'Roman Zippel'" <zippel@linux-m68k.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'jos poortvliet'" <jos@mijnkamer.nl>,
       "'Michael Chang'" <thenewme91@gmail.com>,
       "'Kasper Sandberg'" <lkml@metanurb.dk>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1 -- It does not matter who's code gets merged!
Message-ID: <20070802152257.GH6910@v2.random>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707282003.45142.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org> <200707282128.39906.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org> <Pine.LNX.4.64.0708010539230.1818@scrub.home> <46B01E3F.6050401@gmail.com> <005001c7d403$8d7601a0$a86204e0$@com> <1185951901.2754.12.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185951901.2754.12.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 12:05:01AM -0700, Arjan van de Ven wrote:
> I've had several cases myself where I spent quite some time solving a
> problem, just to get some random remark from someone smart on lkml
> saying "if you had done <this simple thing> you would have had <this
> simple and superior solution>". Was I pissed off that my patch didn't
> get merged but that this better approach got picked? NO! The problem
> that I needed to solve got solved in a really good way. Mission
> accomplished.

Hey to me it even happened I had this nice and safe pte-highmem patch
but the buggy highpte was merged instead, go figure. Con got lucky.
