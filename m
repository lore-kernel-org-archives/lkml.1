Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbYAHHQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbYAHHQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYAHHQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:16:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYAHHQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:16:43 -0500
Date: Tue, 8 Jan 2008 08:16:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 boot : export boot_params via debugfs for
	debugging
Message-ID: <20080108071621.GC31838@elte.hu>
References: <1199770820.11041.6.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199770820.11041.6.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Huang, Ying <ying.huang@intel.com> wrote:

> This patch export the boot parameters via debugfs for debugging.
> 
> The files added are as follow:
> 
> boot_params/data    :  binary file for struct boot_params
> boot_params/version :  boot protocol version
> 
> This patch is based on 2.6.24-rc5-mm1 and has been tested on i386 and
> x86_64 platform.
> 
> This patch is based on the Peter Anvin's proposal.

thanks, applied.

	Ingo
