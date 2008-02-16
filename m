Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYBPKTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYBPKTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYBPKTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:19:23 -0500
Received: from www.tglx.de ([62.245.132.106]:58175 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbYBPKTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:19:21 -0500
Date: Sat, 16 Feb 2008 11:18:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <andyw@uk.ibm.com>
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
In-Reply-To: <200802151815.44050.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de>
References: <20080215165244.GA28358@elte.hu> <200802151815.44050.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Andi Kleen wrote:
> > In the past few months we frequently mentioned checkpatch.pl --file to 
> > arch/x86 newbies and it's been a great source of cleanup patches and it 
> > has become an integral part of our workflow. Newbies should start with 
> > small baby steps, with trivial patches, they should learn to write clean 
> > code, they should learn how to interact with other Linux developers and 
> > then they'll evolve over time towards larger changes.
>
> On the other hand I found that people who already know enough C and start 
> hacking code directly do not really need the "white space only" stage.
> They just start hacking code directly. They usually need some education
> on how to properly send patches, but that can be always done with
> real bug fixes or changes they did.

People, who do cleanups - I'm not talking about running lindent here -
read through the code while they fix it up.

Actually they find bugs that way or at least come up with useful
questions about code which is not obvious in the first place.

Discouraging such cleanups with a pretty offensive warning is
counterproductive.

Thanks,

	tglx
