Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYBPWzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYBPWzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 17:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYBPWzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 17:55:47 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:63082 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYBPWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 17:55:46 -0500
Date: Sat, 16 Feb 2008 22:56:37 +0000
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
Message-ID: <20080216225637.GE24479@shadowen.org>
References: <20080215165244.GA28358@elte.hu> <200802151815.44050.ak@suse.de> <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de> <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 12:27:33PM +0200, Pekka Enberg wrote:
> Hi,
> 
> On Feb 16, 2008 12:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > People, who do cleanups - I'm not talking about running lindent here -
> > read through the code while they fix it up.
> >
> > Actually they find bugs that way or at least come up with useful
> > questions about code which is not obvious in the first place.
> >
> > Discouraging such cleanups with a pretty offensive warning is
> > counterproductive.
> 
> Well, it's not just about cleanup patches submitted by "newbies". I
> use checkpatch for development too and the warning is real PITA for
> that.

The warning is suppressed on -q as its a pain indeed if one is using it
to check files and you are not intending a single file cleanup.

Is the concensus the warning is useful, or unhelpful.

-apw
