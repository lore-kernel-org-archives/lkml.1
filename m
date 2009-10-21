Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZJUL0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZJUL0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZJUL0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:26:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39906 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZJUL0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:26:36 -0400
Date: Wed, 21 Oct 2009 13:26:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 0/2] x86 insn decoder bugfixes
Message-ID: <20091021112619.GA16586@elte.hu>
References: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Ingo,
> 
> Here are x86 insn decoder bugfixes.
> I checked it with your config and allyesconfig too.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (2):
>       x86: Add AES opcodes to opcode map
>       x86: Fix group attribute decoding bug
> 
> 
>  arch/x86/lib/inat.c             |    2 +-
>  arch/x86/lib/x86-opcode-map.txt |   10 ++++++++--
>  2 files changed, 9 insertions(+), 3 deletions(-)

Applied to tip:perf/probes, thanks Masami!

	Ingo
