Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbYBNQaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbYBNQaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYBNQa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:30:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbYBNQa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:30:28 -0500
Date: Thu, 14 Feb 2008 17:25:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@argo.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
Message-ID: <20080214162510.GA29570@elte.hu>
References: <20080213155725.GA19523@elte.hu> <661de9470802130819i61dfe317jf3725a49d8a314b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661de9470802130819i61dfe317jf3725a49d8a314b4@mail.gmail.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Ingo, could you also please consider the KVM build fix at 
> http://marc.info/?l=linux-kernel&m=120262794315024&w=2 which has been 
> acked by Avi. I suspect this patch should be route through git-x86 
> since it affects arch/x86/Kconfig.

thanks, applied - this first looked like a KVM item, that's why i havent 
added it. [Btw., feel free to push it via kvm.git as well - as long as 
you are sure it does not break the build ;-) ]

	Ingo
