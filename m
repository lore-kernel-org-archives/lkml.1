Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYGWPBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYGWPBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYGWPBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:01:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYGWPBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:01:21 -0400
Date: Wed, 23 Jul 2008 17:01:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/genx2apic_uv_x.c: Removed duplicated include
Message-ID: <20080723150102.GA8763@elte.hu>
References: <20080723215912.9422.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723215912.9422.WEIYI.HUANG@gmail.com>
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


* Huang Weiyi <weiyi.huang@gmail.com> wrote:

> Removed duplicated include file <linux/kernel.h> in 
> arch/x86/kernel/genx2apic_uv_x.c.

applied to tip/x86/x2apic, thanks!

	Ingo
