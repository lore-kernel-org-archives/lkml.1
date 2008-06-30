Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYF3GvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYF3GvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYF3GvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:51:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbYF3GvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:51:12 -0400
Date: Mon, 30 Jun 2008 08:50:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Friesen <cfriesen@nortel.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-ID: <20080630065056.GB9561@elte.hu>
References: <20080627154340.GC18957@cvg> <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl> <20080627165937.2f1fb661@lxorguk.ukuu.org.uk> <4865160C.2040403@nortel.com> <20080627165125.GE18957@cvg> <20080627203204.2bdd7aed@lxorguk.ukuu.org.uk> <20080627200020.GG18957@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627200020.GG18957@cvg>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Alan Cox - Fri, Jun 27, 2008 at 08:32:04PM +0100]
> | > > The following sounds better to me: "In kernels prior to 2.4.2-ac18 the 
> | > > NMI-oopser is enabled..."  In this context the phrase itself is in the 
> | > > present, but we point to past kernels.
> | 
> | Agreed.
> | 
> | > And the winner is? I'm not native English speaker so I can't select
> | > a better candidate in {is,was} limited set.
> | 
> | The suggestion above.
> | 
> | Alan
> | 
> 
> Thanks Alan, I've already sent the updated version. Hope you will find 
> it in your mbox /I thought I've Cc'ed you/ ;)

applied to tip/x86/nmi-watchdog - thanks everyone.

	Ingo
