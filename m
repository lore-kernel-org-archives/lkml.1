Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbXH2EFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbXH2EFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXH2EF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:05:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53748 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXH2EFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:05:25 -0400
Date: Wed, 29 Aug 2007 06:05:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Hugh Dickins <hugh@veritas.com>
Subject: Re: Linux 2.6.23-rc4, maxcpus=1 regression
Message-ID: <20070829040512.GA5762@elte.hu>
References: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org> <20070829035554.GA838@elte.hu> <alpine.LFD.0.999.0708282101540.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708282101540.25853@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > reverting that commit makes the system boot again. I've attached the 
> > .config.
> 
> Did you try -rc4? Commit 813409771731d80e6fa94199adf99f2269a4afc0 in 
> particular ("fix maxcpus=N parsing") was supposed to fix that commit.

ah ... indeed my tree is a few commits ahead of rc4. Checking.

	Ingo
