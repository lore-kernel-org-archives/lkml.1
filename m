Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYD2WF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYD2WF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYD2WFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:05:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYD2WFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:05:46 -0400
Date: Wed, 30 Apr 2008 00:05:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86/pci: remove flag in pci_cfg_space_size_ext
Message-ID: <20080429220529.GG2302@elte.hu>
References: <20080426185516.GA32364@elte.hu> <200804281334.16713.jbarnes@virtuousgeek.org> <200804281627.23566.yhlu.kernel@gmail.com> <200804290914.16742.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804290914.16742.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Monday, April 28, 2008 4:27 pm Yinghai Lu wrote:
> > so let pci_cfg_space_size call it directly without flag.
> >
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Thanks Yinghai.
> 
> Ingo, I assume you'll roll this in?

no, i sent the tested tree to Linus, which was unmodified from 3 days 
ago. Could you queue up this cleanup into the PCI tree please?

	Ingo
