Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbYHVG4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbYHVG4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYHVGz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:55:59 -0400
Received: from 8bytes.org ([88.198.83.132]:41470 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYHVGz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:55:59 -0400
Date: Fri, 22 Aug 2008 08:55:11 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH] x86: make gart_alloc_coherent return zeroed memory
Message-ID: <20080822065511.GE7257@8bytes.org>
References: <20080821225038E.fujita.tomonori@lab.ntt.co.jp> <1219339707-30592-1-git-send-email-joerg.roedel@amd.com> <20080822081517F.fujita.tomonori@lab.ntt.co.jp> <20080822063530.GA16706@8bytes.org> <20080822064107.GS14110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822064107.GS14110@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 08:41:07AM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joro@8bytes.org> wrote:
> 
> > > This should be foiled to the first patch in the patchset. No good 
> > > reason to push a patch that might cause a problem.
> > 
> > The reason is, that in my experience, Ingo prefers update patches 
> > instead replacements once he has merged something.
> 
> yeah, that's very true - but i can also fold back things if it's done in 
> a reasonably short amount of time, when there's no other commits mixed 
> in inbetween. (as in this case)

Ah ok, fine for me. Good to know :-)

Joerg

