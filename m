Return-Path: <linux-kernel-owner+w=401wt.eu-S1765957AbYEGXFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765957AbYEGXFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbYEGXEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:04:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762435AbYEGXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:04:30 -0400
Date: Wed, 7 May 2008 16:03:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Roland Dreier <rdreier@cisco.com>, npiggin@suse.de, chrisw@redhat.com,
       rusty@rustcorp.com.au, a.p.zijlstra@chello.nl, marcelo@kvack.org,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, aliguori@us.ibm.com,
       paulmck@us.ibm.com, linux-mm@kvack.org, holt@sgi.com,
       general@lists.openfabrics.org, hugh@veritas.com,
       Andrew Morton <akpm@linux-foundation.org>, dada1@cosmosbay.com,
       clameter@sgi.com
Subject: Re: [ofa-general] Re: [PATCH 01 of 11] mmu-notifier-core
In-Reply-To: <20080507223914.GG8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805071601090.3024@woody.linux-foundation.org>
References: <patchbomb.1210170950@duo.random> <e20917dcc8284b6a07cf.1210170951@duo.random> <20080507130528.adfd154c.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071324570.3024@woody.linux-foundation.org> <20080507215840.GB8276@duo.random>
 <alpine.LFD.1.10.0805071509270.3024@woody.linux-foundation.org> <20080507222758.GD8276@duo.random> <adaej8du4pf.fsf@cisco.com> <20080507223914.GG8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Andrea Arcangeli wrote:
> 
> Ok so I see the problem Linus is referring to now (I received the hint
> by PM too), I thought the order of the signed-off-by was relevant, it
> clearly isn't or we're wasting space ;)

The order of the signed-offs are somewhat relevant, but no, sign-offs 
don't mean authorship.

See the rules for sign-off: you can sign off on another persons patches, 
even if they didn't sign off on them themselves. That's clause (b) in 
particular.

So yes, quite often you'd _expect_ the first sign-off to match the author, 
but that's a correlation, not a causal relationship.

		Linus
