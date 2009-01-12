Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZALKVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZALKVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZALKUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:20:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60045 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZALKUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:20:51 -0500
Date: Mon, 12 Jan 2009 11:20:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, tigran@aivazian.fsnet.co.uk,
       shaohua.li@intel.com, rusty@rustcorp.com.au,
       Andi Kleen <andi@firstfloor.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL -tip] x86: fix style problems in microcode_intel.c,
	msr.c and module_XX.c
Message-ID: <20090112102011.GB10405@elte.hu>
References: <1231753169.7087.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231753169.7087.5.camel@jaswinder.satnam>
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

> Hello Ingo,
> 
> These are safe cleanup patches, please pull them.
> 
> The following changes since commit bb3d7f3c5e418992c9012a850d16d2e11fe43f7e:
>   Ingo Molnar (1):
>         Merge branch 'linus'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> 
> Jaswinder Singh Rajput (4):
>       x86: microcode_intel.c fix style problems
>       x86: msr.c fix style problems
>       x86: module_32.c fix style problems
>       x86: module_64.c fix style problems

hm, are the mpparse.c structural cleanups that i suggested some time ago 
still on your list? I think the functions replace_intsrc_all(), 
smp_scan_config() and smp_read_mpc() need those cleanups.

	Ingo
