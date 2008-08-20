Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYHTKFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYHTKFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYHTKFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:05:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYHTKFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:05:02 -0400
Date: Wed, 20 Aug 2008 12:04:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Dave Airlie <airlied@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "dri-users@lists.sourceforge.net" <dri-users@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080820100440.GE28492@elte.hu>
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819190757.GA17470@linux-os.sc.intel.com>
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> > I'd really like a reply from the AGP or PAT side right about now.
> 
> Hmm. Looks like there are more than 16000 entries in the PAT list!

hm, btw., why is that?

	Ingo
