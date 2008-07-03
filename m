Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYGCNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYGCNid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYGCNiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:38:24 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:57341 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYGCNiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:38:22 -0400
Date: Thu, 3 Jul 2008 10:16:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: + arch-x86-mm-init_64c-early_memtest-fix-types.patch added to
	-mm tree
Message-ID: <20080703081616.GA22246@elte.hu>
References: <200807030807.m63871VU027421@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807030807.m63871VU027421@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> Subject: arch/x86/mm/init_64.c: early_memtest(): fix types
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> arch/x86/mm/init_64.c: In function 'early_memtest':
> arch/x86/mm/init_64.c:524: warning: passing argument 2 of 'find_e820_area_size' from incompatible pointer type

applied to tip/x86/urgent - thanks Andrew,

	Ingo
