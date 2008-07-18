Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYGRUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYGRUJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbYGRUJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:09:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56136 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbYGRUJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:09:00 -0400
Date: Fri, 18 Jul 2008 22:08:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86_64: ia32_signal.c: remove signal number conversion
Message-ID: <20080718200843.GB27176@elte.hu>
References: <487EACAB.2070805@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487EACAB.2070805@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0046]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> This was old code that was needed for iBCS and x86-64 never supported 
> that.

applied to tip/x86/cleanups, thanks Hiroshi.

	Ingo
