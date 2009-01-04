Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZADLIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZADLIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZADLHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:07:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53083 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZADLHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:07:50 -0500
Date: Sun, 4 Jan 2009 12:07:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       astarikovskiy@suse.de, jbarnes@sgi.com, pazke@orbita1.ru,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/7] x86 rename mpc_config_X to mpc_X
Message-ID: <20090104110725.GA24454@elte.hu>
References: <1230977793.6138.17.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230977793.6138.17.camel@jaswinder.satnam>
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

> These are first set of patches for cleanup related to mpspec as suggested by Ingo Molnar.
> Once these are approved and applied then I will send next set of patches.
> 
> The following changes since commit 6ea161d36b1a3615f10a52bd5b19fac41653eea4:
>   Ingo Molnar (1):
>         Merge branch 'linus'
> 
> Jaswinder Singh Rajput (7):
>       x86: rename mp_config_table to mpc_table
>       x86: rename mpc_config_bus to mpc_bus
>       x86: rename mpc_config_processor to mpc_cpu
>       x86: rename mpc_config_ioapic to mpc_ioapic
>       x86: rename mpc_config_intsrc to mpc_intsrc
>       x86: rename mpc_config_lintsrc to mpc_lintsrc
>       x86: rename mpc_config_oemtable to mpc_oemtable

i'm wondering, will you also try the other, more structural cleanups i 
suggested?

	Ingo
