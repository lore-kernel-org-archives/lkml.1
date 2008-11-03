Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYKCJLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYKCJLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYKCJLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:11:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbYKCJLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:11:09 -0500
Date: Mon, 3 Nov 2008 10:11:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081103091101.GK11730@elte.hu>
References: <20081031165751.GA13558@x200.localdomain> <20081031182411.GR28946@ZenIV.linux.org.uk> <20081031184822.GS28946@ZenIV.linux.org.uk> <20081031185526.GT28946@ZenIV.linux.org.uk> <20081031190608.GU28946@ZenIV.linux.org.uk> <20081031195040.GV28946@ZenIV.linux.org.uk> <alpine.DEB.1.10.0810311604040.28774@gandalf.stny.rr.com> <20081031201315.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031201315.GW28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0719]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Oct 31, 2008 at 04:05:01PM -0400, Steven Rostedt wrote:
> > 
> > Ingo,
> > 
> > I guess this is needed to make alph (and perhasp others compile).
> 
> ... and shitloads more than alpha.  Itanic, parisc, all embedded ones,
> m68k, uml, sparc32...

queued it up in tip/tracing/urgent, thanks guys.

	Ingo
