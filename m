Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYGaVVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYGaVVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYGaVVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:21:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYGaVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:21:08 -0400
Date: Thu, 31 Jul 2008 23:20:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: print per_cpu data address
Message-ID: <20080731212055.GE2729@elte.hu>
References: <200807290037.11101.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807290037.11101.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> to make sure per_cpu data on correct node.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/debug - thanks Yinghai.

	Ingo
