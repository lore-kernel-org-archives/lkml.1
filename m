Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbZAURn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbZAURn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZAURnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:43:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42988 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZAURnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:43:20 -0500
Date: Wed, 21 Jan 2009 18:42:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "pageexec@freemail.hu" <pageexec@freemail.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Daniel.Beschorner@facton.com" <Daniel.Beschorner@facton.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch] x86: fix PTE corruption issue while mapping RAM using
	/dev/mem
Message-ID: <20090121174254.GA3428@elte.hu>
References: <20090112235135.GA22722@elte.hu> <496BDDFD.27997.A74B06@pageexec.freemail.hu> <20090113003147.GA18115@elte.hu> <20090113182130.GC13157@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113182130.GC13157@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, Jan 12, 2009 at 04:31:47PM -0800, Ingo Molnar wrote:
> > 
> > Suresh, could you please resend against tip/master? Thanks,
> 
> Ok. Here it is:

applied to tip/x86/urgent, thanks Suresh!

	Ingo
