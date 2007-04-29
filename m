Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXD2GEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXD2GEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 02:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbXD2GEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 02:04:36 -0400
Received: from 1wt.eu ([62.212.114.60]:2333 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbXD2GEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 02:04:34 -0400
Date: Sun, 29 Apr 2007 08:01:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429060106.GV943@1wt.eu>
References: <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org> <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:58:09AM +0200, Markus Rechberger wrote:
> On 4/29/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >
> >On Sat, 28 Apr 2007, Adrian Bunk wrote:
> >>
> >> We are already quite good at ignoring bug reports that come through
> >> linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more
> >> than 1600 open bugs because this tells how bad we are at handling bugs.
> >
> >No, it just shows that bugzilla doesn't matter for most of the kernel.
> >
> >Don't say that "bugzilla tells how bad we are at handling bugs". It tells
> >how bad *bugzilla* is for handling bugs, nothing more.
> >
> 
> I totally disagree here, bugzilla is a very good tool. If someone is
> too lazy to look at it it's his problem.

I'm glad we finally found _the_ person using it !

More seriously, it's so much a complicated interface ! It's hard to
bring more people into a discussion, it's hard to comment on code or
suggested patches, etc... Mail is by far more adapted to the job !

See how many times people do public patch reviews here. You get one
comment every 5-10 lines. I have yet to see how this could be done
in bugzilla.

And maintainers have to _think_ about going there. Mail comes in
without deliberate action. This is especially important because
only your eye is involved in noticing bugs affecting areas where
you can help.

What _may_ be useful would be to send digests or batches of recently
open bugs to LKML. But not all of them. Maybe doing this once a week
in the same way we post patches lists for review. We could have a batch
of "[BUG 1/23] quick subject". At least more people will notice them
and will be able to comment on them. And given the number of people
reading LKML, the bugs should only be posted once. Because if a bug
posted to LKML in a noticeable manner does not get assigned in a week,
it will never be.

Personally, I got used to review Greg & Chris' announces of stable
patches to find if some of them could affect 2.4. It's far easier
to ask for precisions in a mail you weren't expecting than it is to
go somewhere search for something you don't know exists.

Willy

