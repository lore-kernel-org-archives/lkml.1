Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYGZOdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYGZOdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 10:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGZOd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 10:33:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYGZOdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 10:33:25 -0400
Date: Sat, 26 Jul 2008 16:33:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add setup_ioapic_ids for numaq in x86_quirks
Message-ID: <20080726143306.GI4401@elte.hu>
References: <200807250214.28786.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807250214.28786.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1430]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied your 5 patches to tip/x86/core, thanks Yinghai.

	Ingo
