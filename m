Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYJEJUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYJEJUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYJEJT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:19:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbYJEJT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:19:56 -0400
Date: Sun, 5 Oct 2008 11:19:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: gart iommu have direct mapping when agp is
	present too
Message-ID: <20081005091943.GC16819@elte.hu>
References: <1223160912-5069-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223160912-5069-1-git-send-email-yhlu.kernel@gmail.com>
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

> move init_memory_mapping out of init_k8_gatt.
> 
> for: http://bugzilla.kernel.org/show_bug.cgi?id=11676
>     2.6.27-rc2 to rc8, apgart fails, iommu=soft works, regression
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/urgent, thanks Yinghai!

	Ingo
