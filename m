Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZAGPEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZAGPEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZAGPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:04:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbZAGPEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:04:06 -0500
Date: Wed, 7 Jan 2009 16:03:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
Message-ID: <20090107150351.GB27606@elte.hu>
References: <1231329368.17961.29.camel@jaswinder.satnam> <20090107125152.GA3529@elte.hu> <20090107133327.GA4911@elte.hu> <3f9a31f40901070557r336020dctbe9549e8634b167@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901070557r336020dctbe9549e8634b167@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> Hello Ingo,
> 
> On Wed, Jan 7, 2009 at 7:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> applied to tip/x86/cleanups:
> >
> > excluded it again from tip/master, due to this build failure:
> >
> 
> Please accept only first 4 patches:
> 
> 1.  x86: smp.h remove obsolete function declaration
> 2.  x86: smp.h move zap_low_mappings declartion to tlbflush.h
> 3.  x86: smp.h move prefill_possible_map declartion to cpu.h
> 4.  x86: smp.h move stack_processor_id declartion to cpu.h
> 
> Then it will easier for me to to focus on only few things.

ok, i dropped the others.

	Ingo
