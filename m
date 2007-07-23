Return-Path: <linux-kernel-owner+w=401wt.eu-S933787AbXGWSET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbXGWSET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764471AbXGWSEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:04:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764336AbXGWSD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:03:59 -0400
Date: Mon, 23 Jul 2007 11:02:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>, Jon Smirl <jonsmirl@gmail.com>,
       Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git tree for old kernels from before the current tree
In-Reply-To: <alpine.LFD.0.999.0707231343350.6355@xanadu.home>
Message-ID: <alpine.LFD.0.999.0707231057480.3607@woody.linux-foundation.org>
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
 <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
 <20070722211314.GA13850@linux-sh.org> <Pine.LNX.4.64.0707222344540.32367@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707230000170.32367@fbirervta.pbzchgretzou.qr>
 <46A3D5EA.2050600@zytor.com> <alpine.LFD.0.999.0707230950340.3607@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707231343350.6355@xanadu.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jul 2007, Nicolas Pitre wrote:
> 
> I started this once.
> 
> I have (sort of) a GIT tree with all Linux revisions that I could find 
> from v0.01 up to v1.0.9.  But the most interesting information and also 
> what is the most time consuming is the retrieval of announcement 
> messages for those releases in old mailing list or newsgroup archives to 
> serve as commit log data.  It seems to be even arder to find for post 
> v1.0 releases.

Yes, I agree. Google finds some of them, but (a) I was never very good 
about announcements anyway and (b) there's nothing really good to search 
for, so it's very hit-and-miss.

Some of the really early release notes are easy to find, just because I 
made them available with the sources, but mostly I'd just have posten to 
the newsgroup/mailing lists.

If somebody creates a reasonably good tree (ie all the trees, easily 
diffable, tied together with at least *some* commit history and the most 
easily found release notes), I'm willing to try to spend some time just 
writing down recollections from looking at the diffs. Not very reliable, 
but better than nothing. This is the kind of thing that the "notes" thing 
could be useful for, since there are others around who might also be 
interested in adding their commentary.

		Linus
