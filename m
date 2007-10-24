Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbXJXQmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbXJXQmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbXJXQZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760017AbXJXQZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:36 -0400
Date: Wed, 24 Oct 2007 18:25:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make cpu_shares_{show,store}() static
Message-ID: <20071024162516.GA25670@elte.hu>
References: <20071024162347.GW30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162347.GW30533@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1057]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> cpu_shares_{show,store}() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

thanks, applied.

	Ingo
