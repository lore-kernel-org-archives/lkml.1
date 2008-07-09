Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGIGHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGIGHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYGIGH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:07:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYGIGH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:07:28 -0400
Date: Wed, 9 Jul 2008 08:07:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic_32.c - add lapic resource
Message-ID: <20080709060716.GF9760@elte.hu>
References: <20080701174352.GB7043@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701174352.GB7043@cvg>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Add lapic resource into kernel resource map and mark it as busy

applied to tip/x86/core, thanks Cyrill.

> I've started to unify apic code but it will require a huge amount of 
> time and will not be done soon but this patch is usefull even now I 
> think.

agreed, unifying the apic code is quite non-trivial.

	Ingo
