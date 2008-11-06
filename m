Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYKFIge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYKFIge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYKFIgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:36:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbYKFIgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:36:21 -0500
Date: Thu, 6 Nov 2008 09:35:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Message-ID: <20081106083555.GB32214@elte.hu>
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu> <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com> <4912943C.2090801@zytor.com> <86802c440811052300y279bd289t74b437a2053b97d1@mail.gmail.com> <491296B2.6090700@zytor.com> <49129E90.7050004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49129E90.7050004@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> [PATCH] x86: remove VISWS and PARAVIRT around NR_IRQS puzzle
> 
> Impact: fix warn when PARAVIRT is set in config
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

applied to tip/x86/urgent, thanks Yinghai!

	Ingo
