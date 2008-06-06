Return-Path: <linux-kernel-owner+w=401wt.eu-S1763127AbYFFAIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763127AbYFFAIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 20:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYFFAI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 20:08:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbYFFAI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 20:08:26 -0400
Date: Fri, 6 Jun 2008 02:08:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [patch 0/7] speculative page references, lockless pagecache, lockless gup
Message-ID: <20080606000822.GA16356@wotan.suse.de>
References: <20080605094300.295184000@nick.local0.net> <alpine.LFD.1.10.0806051031580.3473@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806051031580.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 10:33:15AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 5 Jun 2008, npiggin@suse.de wrote:
> > 
> > I've decided to submit the speculative page references patch to get merged.
> > I think I've now got enough reasons to get it merged. Well... I always
> > thought I did, I just didn't think anyone else thought I did. If you know
> > what I mean.
> 
> So I'd certainly like to see these early in the 2.6.27 series. 
 
Oh good ;) So would I!


> Nick, will you just re-send them once 2.6.26 is out? Or do they cause 
> problems for Andrew and he wants to be part of the chain? I'm fine with 
> either.

Andrew has picked them up by the looks, and he's my favoured channel to
get mm work merged. Let's see how things go between now and 2.6.26,
which I assume should be a few weeks away?

