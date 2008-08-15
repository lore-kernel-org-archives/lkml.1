Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYHOM2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYHOM2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYHOM16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:27:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYHOM16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:27:58 -0400
Date: Fri, 15 Aug 2008 14:27:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: crane cai <crane.cai@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, vojtech@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
	platform
Message-ID: <20080815122744.GG20442@elte.hu>
References: <1218683616.20466.13.camel@crane-laptop> <alpine.LFD.1.10.0808141206130.3243@apollo.tec.linutronix.de> <1218766167.5646.55.camel@crane-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218766167.5646.55.camel@crane-laptop>
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


* crane cai <crane.cai@amd.com> wrote:

> Hi Thomas,
> 
> Your modification has been checked OK on our SB700 platform. Thank 
> you. Now could you help us to merge your patch to kernel source? Or do 
> I need to resubmit a patch on it?

it's all fine - it's queued up for v2.6.27 merging, in a few days. You 
might want to check the end result in tip/master:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
