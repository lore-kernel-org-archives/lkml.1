Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYKDNtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYKDNtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 08:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYKDNtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 08:49:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYKDNtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:49:22 -0500
Date: Tue, 4 Nov 2008 14:49:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: remove noirqbalance param docs
Message-ID: <20081104134905.GA12842@elte.hu>
References: <1225802763.6532.34.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225802763.6532.34.camel@blaa>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark McLoughlin <markmc@redhat.com> wrote:

> irqbalance was removed by:
> 
>   commit 8b8e8c1bf7275eca859fe551dfa484134eaf013b
>   Author: Yinghai Lu <yhlu.kernel@gmail.com>
>   Date:   Tue Aug 19 20:50:23 2008 -0700
> 
> Remove the associated documentation for noirqbalance.
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

applied to tip/x86/urgent, thanks Mark!

	Ingo
