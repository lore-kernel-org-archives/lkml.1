Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbXEUJ4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbXEUJ4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:56:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXEUJzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:55:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35954 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbXEUJzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:55:54 -0400
Date: Mon, 21 May 2007 10:55:47 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bill Huey <billh@gnuppy.monkey.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521095547.GA10697@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org> <20070521093639.GA29025@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521093639.GA29025@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 11:36:39AM +0200, Ingo Molnar wrote:
> you got the history wrong i think: the first version of lockdep was 
> released to lkml a year ago (May 2006), while the first time you 
> mentioned your lock contention patch was November 2006 and you released 
> it to lkml in December 2006 - so it was _you_ who was "replicating the 
> same work", not lockdep :-) And this was pointed out to you very early 
> on, many months ago.

And lockmeter, the very first patch of this sort is from the 90s, but
got mostly ignored here on lkml, of course :)

