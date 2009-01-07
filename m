Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbZAGQPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbZAGQPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbZAGQPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:15:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbZAGQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:15:04 -0500
Subject: Re: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090107151522.GA5341@elte.hu>
References: <1231329368.17961.29.camel@jaswinder.satnam>
	 <20090107125152.GA3529@elte.hu> <20090107133327.GA4911@elte.hu>
	 <3f9a31f40901070557r336020dctbe9549e8634b167@mail.gmail.com>
	 <20090107150351.GB27606@elte.hu> <20090107151223.GA4899@elte.hu>
	 <20090107151522.GA5341@elte.hu>
Content-Type: text/plain; charset=utf8
Date: Wed, 07 Jan 2009 21:42:46 +0530
Message-Id: <1231344766.3770.12.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 16:15 +0100, Ingo Molnar wrote:
> note, i kept these:
> 
> 6e5385d: x86: smp.h move prefill_possible_map declartion to cpu.h
> dacf733: x86: smp.h move zap_low_mappings declartion to tlbflush.h
> 7760ec7: x86: smp.h remove obsolete function declaration
> 
> as they seem fairly safe.

I send new 4 patches:

﻿[PATCH -tip 1/4 V2] x86: smp.h move stack_processor_id declartion to cpu.h
﻿[PATCH -tip 2/4 V2] x86: smp.h move safe_smp_processor_id declartion to cpu.h
﻿[PATCH -tip 3/4 V2] x86: smp.h move cpu_physical_id declartion to cpu.h
﻿[PATCH -tip 4/4 V2] x86: smp.h move boot_cpu_id declartion to cpu.h

Please accept them.

Thanks,
--
JSR

