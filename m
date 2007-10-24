Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXJXKdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXJXKdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXJXKc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:32:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbXJXKc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:32:58 -0400
Date: Wed, 24 Oct 2007 12:32:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Bogus KERN_ALERT on oops
Message-ID: <20071024103246.GA18741@elte.hu>
References: <20071022115704.GA6271@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022115704.GA6271@localhost.sw.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1013]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> printing eip: f881b9f3 *pdpt = 0000000000003001 <1>*pde = 000000000480a067 *pte = 0000000000000000
> 						^^^

thanks, added this to the x86 queue.

	Ingo
