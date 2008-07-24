Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYGXKjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYGXKjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYGXKjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:39:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbYGXKjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:39:44 -0400
Date: Thu, 24 Jul 2008 12:39:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix up a comment in ack_APIC_irq()
Message-ID: <20080724103931.GH28817@elte.hu>
References: <Pine.LNX.4.55.0807210125341.24038@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807210125341.24038@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1013]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Adjust a comment in ack_APIC_irq() according to the recent removal of 
> CONFIG_X86_GOOD_APIC.

applied to tip/x86/cleanups, thanks Maciej.

	Ingo
