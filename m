Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbXHBT0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbXHBT0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXHBT0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:26:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbXHBT0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:26:38 -0400
Date: Thu, 2 Aug 2007 21:26:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Carlo Florendo <subscribermail@gmail.com>
Cc: Lenar =?iso-8859-1?Q?L=F5hmus?= <lenar@city.ee>,
       Klaus Schulz <Klaus.Schulz@web.de>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org, Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: ck vs. cfs : realtime audio performance
Message-ID: <20070802192625.GA17944@elte.hu>
References: <1185870355.7933.55.camel@klaus-laptop> <1185886161.7397.11.camel@klaus-laptop> <46AF3111.7090206@city.ee> <46B17937.1050401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B17937.1050401@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Carlo Florendo <subscribermail@gmail.com> wrote:

>>>> With CFS I also experienced XRUNS from time to time, what never 
>>>> happened with ck.
> 
> See, this is exactly the problem of the SD ranters.  A ranter posts a 
> problem, doesn't give reproducability hints, and neither provides 
> technical detail, not even the slightest relevant stats.  And the most 
> irritating part is that the code that the OP wrote (or at least its 
> relevant parts) is not even available for download.

actually, there was no "SD ranting" going on at all. Klaus reported a 
problem, Martin forwarded it to me, i replied to it and Klaus gave me 
lots of debug info in a very professional way. So please calm down and 
lets get back to the tech topics, ok? (and i'd like to apologize here to 
Karl and Martin for the rough and unjust treatment they received on 
lkml.)

	Ingo
