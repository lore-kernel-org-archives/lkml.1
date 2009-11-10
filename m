Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZKJRyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZKJRyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZKJRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:54:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbZKJRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:54:34 -0500
Date: Tue, 10 Nov 2009 09:53:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
In-Reply-To: <20091110172202.GB25581@elte.hu>
Message-ID: <alpine.LFD.2.01.0911100952480.31845@localhost.localdomain>
References: <20091110034831.GB26809@elte.hu> <20091110041452.GA25575@suse.de> <20091110042032.GD29454@elte.hu> <1257863432.4184.223.camel@mulgrave.site> <20091110172202.GB25581@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Nov 2009, Ingo Molnar wrote:
> 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > Can you give me the commit id in your tree so I can run a few tests?
> 
> Let me re-quote what you quoted above:
> 
> > > > > I've attached the full commit below. [...]

Let me re-quote James:

 "Can you give me the commit id in your tree so I can run a few tests?"

He wanted the tree. So that he can run tests on his machinery. His 
machinery that does _not_ take some emailed commit description, but works 
on git trees.

So Ingo, if you want to be snarky about quoting people, at least be snarky 
with a reason.

		Linus
