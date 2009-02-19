Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZBSJNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZBSJNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZBSJMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:12:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326AbZBSJMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:12:41 -0500
Date: Thu, 19 Feb 2009 10:12:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: fix double declaration
Message-ID: <20090219091234.GA2354@elte.hu>
References: <1235026809.23776.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235026809.23776.2.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> The following changes since commit cc2d1a5b2dbb2a3ccbb24e17a454ed1aa1b8ece4:
>   Ingo Molnar (1):
>         Merge branch 'timers/new-apis'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tipclean.git master
> 
> Jaswinder Singh Rajput (1):
>       x86: include/asm/processor.h remove double declaration of print_cpu_info
> 
>  arch/x86/include/asm/processor.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Pulled into tip:x86/cleanups, thanks Jaswinder!

	Ingo
