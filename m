Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYJJOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYJJOqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbYJJOqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:46:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756540AbYJJOqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:46:05 -0400
Date: Fri, 10 Oct 2008 16:45:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Message-ID: <20081010144540.GC11695@elte.hu>
References: <20081010002203.GA23238@linux-os.sc.intel.com> <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com> <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com> <20081010090100.GC319@elte.hu> <aa79d98a0810100416q72ec10d5q7d841e02dc4d4f81@mail.gmail.com> <alpine.LFD.1.10.0810101221580.19747@ftp.linux-mips.org> <20081010115655.GC19487@elte.hu> <20081010123838.GB7328@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010123838.GB7328@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0142]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> ok, what the conclusion will be on divisor side? I think
> something like that maybe. Maciej?

looks good to me - could you please send it with a proper subject line 
and changelog, etc?

	Ingo
