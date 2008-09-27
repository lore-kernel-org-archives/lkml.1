Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYI0Q5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYI0Q5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYI0Q5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:57:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56818 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYI0Q5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:57:06 -0400
Date: Sat, 27 Sep 2008 18:56:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86:  print out irq nr for msi/ht v3
Message-ID: <20080927165646.GI4600@elte.hu>
References: <1222368791-16522-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222368791-16522-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> v2: fix hpet compiling error
> v3: Bjorn want to use dev_printk instead
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied, thanks Yinghai!

	Ingo
