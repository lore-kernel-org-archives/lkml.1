Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXJXRVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXJXRVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbXJXRVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:21:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbXJXRVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:21:15 -0400
Date: Wed, 24 Oct 2007 19:20:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make kernel/sched.c:account_guest_time() static
Message-ID: <20071024172055.GB6135@elte.hu>
References: <20071024162517.GW30533@stusta.de> <20071024165027.GA32682@elte.hu> <20071024170001.GA30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024170001.GA30533@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> > btw., how about adding your 'check static functions' scripts to the 
> > kernel, via a "make checkstatic" pass or something like that? That 
> > way people could check this for themselves and could avoid letting 
> > them into the kernel.
> 
> It is not my script, it was written by Keith Owens.
> 
> It is already available as "make namespacecheck" since kernel 2.6.9.

heh, *blush* :-) I'll start using it :)

	Ingo
