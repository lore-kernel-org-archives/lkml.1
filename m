Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKDI7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKDI7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYKDI7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:59:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53945 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYKDI7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:59:37 -0500
Date: Tue, 4 Nov 2008 09:59:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: print out memmap number only it is not zero
Message-ID: <20081104085921.GB23790@elte.hu>
References: <490FA7EA.2060305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490FA7EA.2060305@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: cleanup

Impact: simplify debug printk output

> not print out for non used zone on nodes other than node0
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

looks good to me.

	Ingo
