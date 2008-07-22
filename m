Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYGVMiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYGVMiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYGVMin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:38:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46178 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbYGVMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:38:43 -0400
Date: Tue, 22 Jul 2008 14:38:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86: declaration fixes - version 2
Message-ID: <20080722123820.GA23140@elte.hu>
References: <1216729673.5338.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216729673.5338.2.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> Here is updated patches for x86-tip.
> 
> The following changes since commit 087115517d43c25e7286a62bf4d458becef5a244:
>   Ingo Molnar (1):
>         Merge branch 'xen-64bit'
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/jaswinder/linux-2.6-tip.git master

pulled, thanks Jaswinder.

I've rebased it back to -git [Linus pulled most of the pending x86 
topics yesterday so this was possible cleanly] and pushed it out into 
tip/x86/prototypes.

I'll give it some build testing in tip/master.

	Ingo
