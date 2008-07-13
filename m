Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYGMG2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYGMG2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 02:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYGMG2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 02:28:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYGMG2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 02:28:32 -0400
Date: Sun, 13 Jul 2008 08:28:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make 64bit have get_apic_id
Message-ID: <20080713062802.GC2534@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807111843.11157.yhlu.kernel@gmail.com> <200807111844.17084.yhlu.kernel@gmail.com> <200807120101.20554.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807120101.20554.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> and read_apic_id become macro
> GET_APIC_ID(apic_read(APIC_ID))

applied to tip/x86/x2apic, thanks Yinghai.

	Ingo
