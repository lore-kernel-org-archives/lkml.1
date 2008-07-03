Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbYGCNKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbYGCNKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYGCNKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:10:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36560 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbYGCNKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:10:02 -0400
Date: Thu, 3 Jul 2008 15:09:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: remove unnecessary #ifdef CONFIG_X86_32...#else
Message-ID: <20080703130927.GA5770@elte.hu>
References: <20080625070319.GA15059@quasar.las>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625070319.GA15059@quasar.las>
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


* Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br> wrote:

> Remove the #ifdef conditional because this comparison is already done 
> in user_mode_vm().
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>

applied to tip/x86/cleanups - thanks Gustavo.

	Ingo
