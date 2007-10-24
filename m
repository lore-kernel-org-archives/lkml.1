Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXJXMDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXJXMDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXJXMDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:03:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbXJXMDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:03:11 -0400
Date: Wed, 24 Oct 2007 14:03:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/12] X86: fix nvidia HPET warning
Message-ID: <20071024120300.GB21681@elte.hu>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223635.24CE01F81A1@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071023223635.24CE01F81A1@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> arch/x86/kernel/early-quirks.c:40: warning: 
> ‘nvidia_hpet_check’ defined but not used

thanks, applied.

	Ingo
