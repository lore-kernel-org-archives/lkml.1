Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbXLMAPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbXLMAPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXLMAPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:15:22 -0500
Received: from relais.videotron.ca ([24.201.245.36]:46878 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXLMAPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:15:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 12 Dec 2007 19:15:17 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Dave Jones <davej@redhat.com>
Cc: Peter Stahlir <peter.stahlir@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel history from 0.0.1
In-reply-to: <20071212234640.GA452@redhat.com>
Message-id: <alpine.LFD.0.99999.0712121911490.20487@xanadu.home>
References: <fbe8b1780712121410u41517699v6e0b991d1a262ffd@mail.gmail.com>
 <20071212234640.GA452@redhat.com>
User-Agent: Alpine 0.99999 (LFD 814 2007-11-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007, Dave Jones wrote:

> For a while I've been pulling together some scripts to create
> a git repo with every single ancient Linux version up to 2.4
> before we had an SCM tracking commits.
> (from 0.01, up to 2.4.0, including every -pre,-test and -rc along
>  the way as a separate commit).
> 
> And now for the really crazy part:
> 
>     With actual changelogs for as many commits as possible.
> 
> This seemed like a fun idea at first, then about a third the way through
> I began to think this was nuts.  At halfway, I'd decided I'd gone too far
> to not finish it, and this is the result.   There's still a lot of
> un-changelogged commits, but I've sat on this for about a month
> making slow further progress. (It's getting harder to find changelogs)
> 
> About halfway through, in September of 2007, someone called
> 'Gonsolo' did something similar to all this.  [http://lwn.net/Articles/250699/]
> Though his version lacked changelogs, and missed a ton of prepatches.
> It was also around this time, I found that I'm not the only person loony
> enough to attempt this, and stumbled across
>  git://git.kernel.org/pub/scm/linux/kernel/git/nico/archive.git
> Nico's archive had some bits I missed, and there were some bits
> in his that I had got, so where possible, I stole some of his changelogs.
> I think my variant is as complete as we're going to get.

Good!  I'll certainly have a look.

I was a bit sad not being able to continue my archive, but this became 
really too time consuming for me.  I always planned to get back to it 
but...


Nicolas
