Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYABTyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYABTyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYABTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:54:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbYABTyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:54:45 -0500
Date: Wed, 2 Jan 2008 20:54:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: clean up apic_32/64.c
Message-ID: <20080102195425.GA31700@elte.hu>
References: <477BD875.2090508@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477BD875.2090508@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0664]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> White space and coding style clean up. Make apic_32/64.c similar.

thanks, applied. FYI, there's still a bit left in apic_32.c:

 total: 5 errors, 1 warnings, 1566 lines checked

we might as well go for all of them? :-)

	Ingo
