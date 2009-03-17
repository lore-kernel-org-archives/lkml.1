Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbZCQSyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbZCQSyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZCQSyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:54:17 -0400
Received: from www.tglx.de ([62.245.132.106]:41484 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbZCQSyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:54:16 -0400
Date: Tue, 17 Mar 2009 19:53:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: mpparse cleanup
In-Reply-To: <1237314836.3212.10.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903171952400.29264@localhost.localdomain>
References: <1237314836.3212.10.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Jaswinder Singh Rajput wrote:

> The following changes since commit 0ca0f16fd17c5d880dd0abbe03595b0c7c5b3c95:
>   Ingo Molnar (1):
>         Merge branches 'x86/apic', 'x86/asm', 'x86/cleanups', 'x86/debug', 'x86/kconfig', 'x86/mm', 'x86/ptrace', 'x86/setup' and 'x86/urgent'; commit 'v2.6.29-rc8' into x86/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core
> 
> Jaswinder Singh Rajput (1):
>       x86: mpparse cleanup
> 
>  arch/x86/kernel/mpparse.c |  311 +++++++++++++++++++++------------------------
>  1 files changed, 146 insertions(+), 165 deletions(-)

   -ENOPATCH
 
