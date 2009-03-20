Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZCTSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZCTSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZCTSJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:09:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZCTSJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:09:15 -0400
Date: Fri, 20 Mar 2009 19:08:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
       Christopher Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
       Hannes Eder <hannes@hanneseder.net>, linux-kernel@vger.kernel.org
Subject: Re: Nasal demons in preprocessor use (Re: [PATCH] test-suite: new
	preprocessor test case)
Message-ID: <20090320180853.GA24154@elte.hu>
References: <20090319175544.13691.42362.stgit@f10box.hanneseder.net> <20090319182628.GB28946@ZenIV.linux.org.uk> <154e089b0903191151q37ab7b20o43838845af12966f@mail.gmail.com> <20090319190730.GC28946@ZenIV.linux.org.uk> <20090319192758.GB24318@elte.hu> <19f34abd0903191320qdd73530ud85081d23e17b266@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0903191320qdd73530ud85081d23e17b266@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> I guess this means that kmemcheck branch should be withdrawn from 
> linux-next, at least temporarily, as I have no immediate 
> workarounds/alternatives. Stephen, can you drop it?

Al Viro, well done :-(

	Ingo
