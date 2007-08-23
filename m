Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbXHWNy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbXHWNy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXHWNyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:54:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40654 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbXHWNyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:54:21 -0400
Date: Thu, 23 Aug 2007 15:53:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Shrink task_struct if CONFIG_FUTEX=n
Message-ID: <20070823135347.GA15224@elte.hu>
References: <20070823132735.GE31289@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823132735.GE31289@localhost.sw.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4624]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> robust_list, compat_robust_list, pi_state_list, pi_state_cache are 
> really used if futexes are on.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

looks good to me.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
