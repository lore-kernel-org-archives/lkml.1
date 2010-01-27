Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088Ab0A0Jw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0A0Jw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039Ab0A0Jwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:52:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0A0Jwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:52:54 -0500
Date: Wed, 27 Jan 2010 10:52:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.33
Message-ID: <20100127095240.GC24915@elte.hu>
References: <20100125192922.GQ2014@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125192922.GQ2014@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile fixes for v2.6.33 from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Thanks,
> 
> -Robert
> 
> The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
>   Linus Torvalds (1):
>         Linux 2.6.33-rc5
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Andi Kleen (1):
>       oprofile/x86: add Xeon 7500 series support
> 
> Suravee Suthikulpanit (1):
>       oprofile/x86: fix crash when profiling more than 28 events
> 
>  arch/x86/oprofile/nmi_int.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Pulled, thanks a lot Robert!

	Ingo
