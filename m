Return-Path: <linux-kernel-owner+w=401wt.eu-S1946567AbXD3SZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946567AbXD3SZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423605AbXD3SZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:25:53 -0400
Received: from DENETHOR.UNI-MUENSTER.DE ([128.176.180.180]:38813 "EHLO
	denethor.uni-muenster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423624AbXD3SZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:25:48 -0400
Date: Mon, 30 Apr 2007 20:13:54 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070430181354.GC4772@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070428195320.GZ3468@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 09:53:20PM +0200, Adrian Bunk wrote:
> On Thu, Apr 26, 2007 at 02:13:08PM -0700, Linus Torvalds wrote:
> >...
> > (I've said this before, but I'll say it again: one thing that would 
> > already make bugzilla better is to just always drop any bug reports that 
> > are more than a week old and haven't been touched. It wouldn't need *much* 
> > touching, but if a reporter cannot be bothered to say "still true with 
> > current snapshot" once a week, then it shouldn't be seen as being somehow 
> > up to those scare resources we call "developers" to have to go through 
> > it).
> >...
> 
> And if it's a bug in an unmaintained subsystem, a user could do this for 
> 100 weeks without any effect.
> There's no value in keeping reporters busy with useless tasks. [1]
> 
> Don't forget:
> A good bug report is an important contribution.
> 
> We are already quite good at ignoring bug reports that come through 
> linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
> than 1600 open bugs because this tells how bad we are at handling bugs.
> How many thousand bug reports have been ignored during the same time on 
> linux-kernel?

... and it gets better: I've been trying to fix/improve stuff I can, with
my limited abilities as coder for some time now in the linux kernel, but there
are simply cases where, although you're trying to even come up with a proper fix
and adhere to all the kernel coding standards and _even_ produce a patch which
can serve as rough cut for a probable fix, your mail simply disappears into the
void unanswered. Then you send again, and again, yet it remains unreplied and then you
give up and turn to something else. Some of those patches, for example, were the
rework of the debugging scheme of libata i did more than a year ago which got
reviewed and then .. forgotten, some kernel janitor cleanups, etc...

-- 
Regards/Gruﬂ,
    Boris.
