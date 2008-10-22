Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYJVLaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYJVLaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJVLaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:30:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48394 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbYJVLae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:30:34 -0400
Date: Wed, 22 Oct 2008 13:30:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kleen@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: enable GBPAGES option by default
Message-ID: <20081022113017.GA4583@elte.hu>
References: <20081022103316.GB27862@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022103316.GB27862@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> DIRECT_GBPAGES was under DEBUG_KERNEL && EXPERIMENTAL and disabled by 
> default. Turn it on by default and put it under EMBEDDED.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

applied to tip/x86/mm, thanks Nick!

	Ingo
