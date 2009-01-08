Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbZAHOio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbZAHOio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758916AbZAHOiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:38:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913AbZAHOiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:38:19 -0500
Date: Thu, 8 Jan 2009 15:38:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       astarikovskiy@suse.de, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/2] x86: rename intel_mp_floating and its all
	fields
Message-ID: <20090108143801.GA18120@elte.hu>
References: <1231409488.7119.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231409488.7119.2.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> The following changes since commit 91506140696f1bc1a48258b17f2a768aa2090af5:
>   Ingo Molnar (1):
>         Merge branch 'linus'
> 
> Jaswinder Singh Rajput (2):
>       x86: rename intel_mp_floating to mpf_intel
>       x86: rename all fields of mpf_intel mpf_X to X
> 
>  arch/x86/include/asm/mpspec_def.h |   23 +++++++------
>  arch/x86/kernel/mpparse.c         |   62 ++++++++++++++++++------------------
>  2 files changed, 43 insertions(+), 42 deletions(-)

applied to tip/x86/cleanups, thanks!

	Ingo
