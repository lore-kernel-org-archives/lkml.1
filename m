Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbXA2NFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbXA2NFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXA2NFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:05:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbXA2NFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:05:47 -0500
Date: Mon, 29 Jan 2007 07:58:55 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Duncan <1i5t5.duncan@cox.net>, Neil Brown <neilb@suse.de>,
       mingo@redhat.com, linux-raid@vger.kernel.org,
       cpufreq@lists.linux.org.uk, lenb@kernel.org, linux-acpi@vger.kernel.org,
       Jan Altenberg <jan@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Andrew Clayton <andrew@digital-domain.net>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.20-rc6: known regressions with patches
Message-ID: <20070129125855.GA30599@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Duncan <1i5t5.duncan@cox.net>, Neil Brown <neilb@suse.de>,
	mingo@redhat.com, linux-raid@vger.kernel.org,
	cpufreq@lists.linux.org.uk, lenb@kernel.org,
	linux-acpi@vger.kernel.org, Jan Altenberg <jan@linutronix.de>,
	Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
	Andrew Clayton <andrew@digital-domain.net>,
	Trond Myklebust <trond.myklebust@fys.uio.no>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <20070126181853.GO17836@stusta.de> <20070129084548.GA10578@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129084548.GA10578@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 09:45:48AM +0100, Ingo Molnar wrote:
 > 
 > * Adrian Bunk <bunk@stusta.de> wrote:
 > 
 > > Subject    : ACPI: fix cpufreq regression
 > > References : http://lkml.org/lkml/2007/1/16/120
 > > Submitter  : Ingo Molnar <mingo@elte.hu>
 > > Caused-By  : Dave Jones <davej@redhat.com>
 > >              commit 0916bd3ebb7cefdd0f432e8491abe24f4b5a101e
 > > Handled-By : Ingo Molnar <mingo@elte.hu>
 > > Patch      : http://lkml.org/lkml/2007/1/16/120
 > > Status     : patch available
 > 
 > this is commit e4233dec749a3519069d9390561b5636a75c7579 meanwhile.

Thanks for pushing this on in my absense btw.
FWIW, it has my belated ACK :)
I've asked for it to be in 19.3 too as the same bug exists there.

		Dave

-- 
http://www.codemonkey.org.uk
