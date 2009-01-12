Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZALKpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZALKpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZALKox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:44:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34312 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZALKow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:44:52 -0500
Date: Mon, 12 Jan 2009 11:44:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       "H. Peter Anvin" <hpa@kernel.org>, tigran@aivazian.fsnet.co.uk,
       shaohua.li@intel.com, rusty@rustcorp.com.au,
       Andi Kleen <andi@firstfloor.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL -tip] x86: fix style problems in microcode_intel.c,
	msr.c and module_XX.c
Message-ID: <20090112104429.GE10405@elte.hu>
References: <1231753169.7087.5.camel@jaswinder.satnam> <20090112102011.GB10405@elte.hu> <3f9a31f40901120243u5ca60bc6n31dee913a02a081a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901120243u5ca60bc6n31dee913a02a081a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2363]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Mon, Jan 12, 2009 at 3:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > hm, are the mpparse.c structural cleanups that i suggested some time ago
> > still on your list? I think the functions replace_intsrc_all(),
> > smp_scan_config() and smp_read_mpc() need those cleanups.
> >
> 
> Yes, it is still in my TODO list. But before that I need to submit
> patches to get some extra space:
> 0001-x86-replacing-mp_config_ioapic-with-mpc_ioapic.patch
> 0002-x86-replacing-mp_config_intsrc-with-mpc_intsrc.patch
> 
> And then I will make final changes in mpparse.c

ok.

	Ingo
