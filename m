Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZBRMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZBRMhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBRMhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:37:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51450 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZBRMhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:37:33 -0500
Date: Wed, 18 Feb 2009 13:37:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com, kaber@trash.net,
       rick.jones2@hp.com, dada1@cosmosbay.com, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, tglx@linutronix.de,
       gandalf@wlug.westbo.se, linux-kernel@vger.kernel.org
Subject: Re: [RFT 2/4] Add mod_timer_noact
Message-ID: <20090218123714.GA28028@elte.hu>
References: <20090218110144.GA4100@elte.hu> <20090218113953.GB5408@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218113953.GB5408@ff.dom.local>
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


* Jarek Poplawski <jarkao2@gmail.com> wrote:

> On 18-02-2009 12:01, Ingo Molnar wrote:
> ...
> > that straight away. Instead you forced me into wasting time on 
> > this rather long email (and you also forced the very unnecessary 
> > public embarrasment of a contributor), for what should have been 
> > an 'oops, right, will fix' routine matter.
> 
> No problem! But next time use this shorter routine, please...

Correct, the "oops, right, will fix" should have come as a reply 
to my mail, obviously - i did not submit the patch after all. 
Instead i got this accusatory mail from davem which certainly 
did not help bring the issue forward ...

Thanks,

	Ingo
