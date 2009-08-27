Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZH0DXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZH0DXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZH0DXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:23:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:60553 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbZH0DXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:23:05 -0400
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <1251342735.20467.2.camel@pasglop>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1250142522.3587.110.camel@pasglop>
	 <20090813160625B.fujita.tomonori@lab.ntt.co.jp>
	 <20090813074131.GH12143@elte.hu> <1250150981.3587.157.camel@pasglop>
	 <20090813085505.GA10671@elte.hu>  <1251342735.20467.2.camel@pasglop>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 13:17:50 +1000
Message-Id: <1251343070.20467.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 13:12 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2009-08-13 at 10:55 +0200, Ingo Molnar wrote:
> 
> > Ok! We could also stage it a bit (one or two weeks) in a separate 
> > branch and allow a rebase, should you find any bugs during testing?
> 
> Allright so after various delays and sidetracking on my side, the
> patches have been in my -test branch for long enough, I'm happy for them
> to go in either way now.
> 
> I'm going to take them out of powerpc test for now and not put them in
> my -next right away until I'm sure I have the right source to pull, at
> which point I can just put from tip iommu.

IE. I think I was not clear :-)

I mean, I plan to pull tip/iommu into powerpc-next and then apply the
patches, but I want just your final word that this is a
"stable" (non-rebase) branch and from Fujita that the patches are still
good and haven't changed from those currently on patchwork.

Cheers,
Ben.


