Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYEIJhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYEIJhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYEIJhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:37:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbYEIJhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:37:36 -0400
Date: Fri, 9 May 2008 11:37:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, arjan@infradead.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Remove 6 bank limitation in 64 bit MCE reporting
	code
Message-ID: <20080509093706.GA16037@elte.hu>
References: <20080508211836.GA26353@linux-os.sc.intel.com> <4823705E.1040401@zytor.com> <20080508221659.GA2759@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508221659.GA2759@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> It was tried earlier
> http://www.ussg.iu.edu/hypermail/linux/kernel/0505.2/0982.html
> but never made it.

yeah - it had some test failures iirc.

> Yes. Will add that to the todo list.

great.

queued up this patch of yours as well.

	Ingo
