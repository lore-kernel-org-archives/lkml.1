Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYKMVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYKMVVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYKMVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:21:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38575 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYKMVVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:21:42 -0500
Date: Thu, 13 Nov 2008 22:21:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
Message-ID: <20081113212124.GA4662@elte.hu>
References: <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <20081110015511.453a801e.akpm@linux-foundation.org> <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu> <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu> <491C8B38.9060901@kernel.org> <20081113131850.d94fb229.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113131850.d94fb229.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch is HHHHHUUUUUUUUUUGGGGGEEE!  Did it really need to be a 
> single megapatch?

i asked Yinghai to do that for now, instead of sending a 50-patch 
series 10 times over - so that we can see the overall structure.

	Ingo
