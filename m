Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXA3U1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXA3U1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXA3U1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:27:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXA3U1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:27:14 -0500
Date: Tue, 30 Jan 2007 21:25:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John <shill@free.fr>
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com, johnstul@us.ibm.com,
       akpm@osdl.org
Subject: Re: One-shot high-resolution POSIX timer periodically late
Message-ID: <20070130202506.GB1246@elte.hu>
References: <fa.mtUvfgenNQkCc8835prYbwyiPQs@ifi.uio.no> <fa.lwkMc548uRMcUjd9KZ2pC1DMKT4@ifi.uio.no> <fa.dTtI0ctv1nu+tCWiK6jGPnrX69k@ifi.uio.no> <fa.CMU3scpnLxfHVWRFPcmfRl2CjhA@ifi.uio.no> <45BF8290.6010602@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BF8290.6010602@free.fr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4691]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John <shill@free.fr> wrote:

> John Stultz wrote:
> 
> >Also do check the -rt tree as Ingo suggested. I mis-read your earlier
> >email and thought you were running it.
> 
> I've been pulling my hair over a related issue for the past two days.
> 
> (I think I may be tickling a -hrt bug...)
> 
> I'm working with 2.6.18.6 + patch-2.6.18-rt7

2.6.18-rt7 is pretty old, do you see the problem in 2.6.20-rc6-rt5 too?

	Ingo
