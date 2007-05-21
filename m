Return-Path: <linux-kernel-owner+w=401wt.eu-S1764462AbXEUKWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764462AbXEUKWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762415AbXEUKWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:22:21 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:58235
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763062AbXEUKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:22:20 -0400
Date: Mon, 21 May 2007 03:21:49 -0700
To: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521102149.GD4593@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org> <20070521093639.GA29025@elte.hu> <20070521095547.GA10697@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521095547.GA10697@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 10:55:47AM +0100, Christoph Hellwig wrote:
> On Mon, May 21, 2007 at 11:36:39AM +0200, Ingo Molnar wrote:
> > you got the history wrong i think: the first version of lockdep was 
> > released to lkml a year ago (May 2006), while the first time you 
> > mentioned your lock contention patch was November 2006 and you released 
> > it to lkml in December 2006 - so it was _you_ who was "replicating the 
> > same work", not lockdep :-) And this was pointed out to you very early 
> > on, many months ago.
> 
> And lockmeter, the very first patch of this sort is from the 90s, but
> got mostly ignored here on lkml, of course :)

Unfortunately, it's not nearly as cool as my patch by default because I wrote
it. :)

bill

