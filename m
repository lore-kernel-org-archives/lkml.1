Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZHDIc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZHDIc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZHDIcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:32:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbZHDIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:32:24 -0400
Date: Tue, 4 Aug 2009 10:32:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] perf tools: allow top users to switch between weighted
	and individual counter display
Message-ID: <20090804083219.GA18081@elte.hu>
References: <1248422990.28486.3.camel@marge.simson.net> <1248425937.6987.0.camel@twins> <1248431821.9722.4.camel@marge.simson.net> <20090802200049.GF24486@elte.hu> <1249276178.17959.67.camel@marge.simson.net> <1249374083.10069.18.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249374083.10069.18.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Mon, 2009-08-03 at 07:09 +0200, Mike Galbraith wrote:
> 
> > Not sure I like waiting for input at start though, maybe just 
> > display and sleep a couple seconds would be friendlier.
> 
> I find both really annoying, so just go straight into displaying.  
> That kind of usage information belongs in the man page.  I've 
> updated same to reflect the current implementation, and will 
> submit separately.

yeah - will apply both patches, thanks Mike.

I'm wondering, have you seen the 'tig' tool before? It puts the 
console into raw mode too and has a rather pleasant text interface. 
Since it's a relatively young project it might have a compact code 
base that could be imported (assuming the license is compatible and 
assuming what i say is true - have not checked yet).

	Ingo

