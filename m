Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYFDK1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYFDK1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbYFDK1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:27:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51784 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760052AbYFDK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:27:18 -0400
Date: Wed, 4 Jun 2008 12:27:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: 32 bit use e820_register_active_regions
Message-ID: <20080604102703.GE22971@elte.hu>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031934.01198.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806031935.05202.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0272]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> so 32bit is more like 64bit, and more smart with combining e820 and numa.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied, thanks.

	Ingo
