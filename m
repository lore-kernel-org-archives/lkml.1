Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbXEUK36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbXEUK36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXEUK3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:29:48 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:53263
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbXEUK3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:29:47 -0400
Date: Mon, 21 May 2007 03:28:56 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521102856.GA20136@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org> <20070521093639.GA29025@elte.hu> <20070521101946.GC4593@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521101946.GC4593@gnuppy.monkey.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 03:19:46AM -0700, Bill Huey wrote:
> On Mon, May 21, 2007 at 11:36:39AM +0200, Ingo Molnar wrote:
> > you got the history wrong i think: the first version of lockdep was 
> > released to lkml a year ago (May 2006), while the first time you 
> > mentioned your lock contention patch was November 2006 and you released 
> > it to lkml in December 2006 - so it was _you_ who was "replicating the 
> > same work", not lockdep :-) And this was pointed out to you very early 
> > on, many months ago.
> 
> Yeah, and where do we disagree here again ? So I take it you're disagreeing
> with my agreement with you that lockdep came first ? Geez, think about that
> one for a bit. (chuckle) :)

Yeah, sorry about the wording reversal. It was unintentional. I tend to drop
minor words like "not" and stuff which can create confusion.

bill

