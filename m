Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYGOQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYGOQNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYGOQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:13:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbYGOQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:13:46 -0400
Date: Tue, 15 Jul 2008 09:13:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <alpine.LFD.1.10.0807150904290.3017@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807150907480.3017@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487C242B.19490.17F690F7@pageexec.freemail.hu>, <alpine.LFD.1.10.0807141924020.3017@woody.linux-foundation.org> <487CDEDD.21049.1ACFDAEA@pageexec.freemail.hu>
 <alpine.LFD.1.10.0807150904290.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Linus Torvalds wrote:
> 
> So as far as I'm concerned, "disclosing" is the fixing of the bug. It's 
> the "look at the source" approach.

Btw, and you may not like this, since you are so focused on security, one 
reason I refuse to bother with the whole security circus is that I think 
it glorifies - and thus encourages - the wrong behavior.

It makes "heroes" out of security people, as if the people who don't just 
fix normal bugs aren't as important.

In fact, all the boring normal bugs are _way_ more important, just because 
there's a lot more of them. I don't think some spectacular security hole 
should be glorified or cared about as being any more "special" than a 
random spectacular crash due to bad locking.

Security people are often the black-and-white kind of people that I can't 
stand. I think the OpenBSD crowd is a bunch of masturbating monkeys, in 
that they make such a big deal about concentrating on security to the 
point where they pretty much admit that nothing else matters to them.

To me, security is important. But it's no less important than everything 
*else* that is also important!

			Linus
