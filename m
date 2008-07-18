Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYGRR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYGRR0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759295AbYGRR0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:26:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47549 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871AbYGRRZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:25:59 -0400
Date: Fri, 18 Jul 2008 19:25:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       kernel-janitors@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] arch/x86/kernel/cpu/common_64.c: remove double
	inclusions
Message-ID: <20080718172546.GN6875@elte.hu>
References: <a4423d670807091128t3a03b739y66fcffcfcf961f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670807091128t3a03b739y66fcffcfcf961f8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0119]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> x86: remove double inclusions in arch/x86/kernel/cpu/common_64.c

applied to tip/x86/cleanups, thanks.

	Ingo
