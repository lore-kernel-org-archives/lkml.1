Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYBRKHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYBRKHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYBRKHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:07:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:60350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbYBRKHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:07:32 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
Date: Mon, 18 Feb 2008 11:07:27 +0100
User-Agent: KMail/1.9.6
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andy Whitcroft" <andyw@uk.ibm.com>
References: <20080215165244.GA28358@elte.hu> <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de> <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com>
In-Reply-To: <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181107.27731.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008 11:27:33 Pekka Enberg wrote:
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

Just use --file-force then. That will shut it up.

-Andi
 


