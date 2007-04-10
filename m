Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbXDJOXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbXDJOXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030579AbXDJOXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:23:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030581AbXDJOXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:23:13 -0400
Date: Tue, 10 Apr 2007 16:23:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com
Subject: Re: 2.6.20-rt8 patch tweaked for 2.6.20.5
Message-ID: <20070410142302.GA1519@elte.hu>
References: <461672D8.7090100@free.fr> <20070406173639.GA2929@elte.hu> <461B53CD.1030603@free.fr> <20070410131724.GA18553@elte.hu> <461B9CA6.8030707@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461B9CA6.8030707@free.fr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John <linux.kernel@free.fr> wrote:

> > sure, i can put it there.
> 
> Great! Can you tell me how you generate the original -rt patch, so I 
> can provide an updated version when a new 2.6.20 kernel is released?

they should be generated the way you did: apply the 2.6.20 baseline -rt 
kernel patch to the later patches and fix up rejects. For later kernels 
just do the same.

> If I understand correctly, removing that specific patch from 
> patch-2.6.20-rt8 is the appropriate course of action then?

yes.

	Ingo
