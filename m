Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYJPXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYJPXG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYJPXGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:06:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:40250 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199AbYJPXGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:06:45 -0400
Subject: Re: [git pull] core kernel updates for v2.6.28
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <becky.bruce@freescale.com>
In-Reply-To: <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
References: <20081015125023.GA6702@elte.hu>
	 <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 10:05:02 +1100
Message-Id: <1224198302.7654.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 15:32 -0700, Linus Torvalds wrote:
> 
> On Wed, 15 Oct 2008, Ingo Molnar wrote:
> > 
> > Please pull the latest core-v28-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-v28-for-linus
> > 
> > this is a combination of the following topics:
> >    ...
> >    core/resources
> 
> Ok, the resource_size_t -> generic phys_addr_t changes conflicted with the 
> PowerPC changes I had merged yesterday. The resolution wasn't overly 
> complex, but I'm sure I screwed something up anyway. Can the involved 
> Power people take a look (looks like BenH, Kumar, Becky to me), and 
> Jeremy/Ingo on the generic resource side?

Will do as soon as I manage to get off meetings...

Cheers,
Ben.


