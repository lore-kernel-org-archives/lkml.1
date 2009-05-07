Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbZEGOTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbZEGOTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZEGOTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:19:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZEGOTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:19:09 -0400
Date: Thu, 7 May 2009 16:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: security: rename ptrace_may_access => ptrace_access_check
Message-ID: <20090507141748.GK481@elte.hu>
References: <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> On Thu, 7 May 2009, Ingo Molnar wrote:
> 
> > > Boot tested with SELinux.
> > 
> > thanks! Below are the two patches i wrote and tested.
> 
> Do you need these in your tree, or are they ok going into 
> linux-next via mine?

Sure, feel free to queue them up if everyone else is fine with them 
too.

	Ingo
