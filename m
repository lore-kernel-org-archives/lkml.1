Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYK1NyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYK1NyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYK1NyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:54:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54824 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYK1NyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:54:12 -0500
Date: Fri, 28 Nov 2008 14:54:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: entry_64.S - trivial: space, comments fixup
Message-ID: <20081128135403.GD28138@elte.hu>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com> <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com> <fbfac26820d86fa887adfbfa8ac80b369de00075.1227725632.git.gorcunov@gmail.com> <1227782341.31610.1287042073@webmail.messagingengine.com> <20081127120230.GB4259@elte.hu> <20081127181008.GB23593@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127181008.GB23593@localhost>
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

> [Ingo Molnar - Thu, Nov 27, 2008 at 01:02:34PM +0100]
> | > > From: Cyrill Gorcunov <gorcunov@gmail.com>
> | > > 
> | > > Impact: cleanup
> | > > 
> | > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> | > 
> | > Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
> | 
> | Cyrill, could you please rework the still relevant bits against latest 
> | tip/master? Alexander's wider patch got in the way.
> | 
> | Thanks,
> | 
> | 	Ingo
> | 
> 
> Here is an updated version
> ---
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: x86: entry_64.S - trivial: space, comments fixup
> 
> Impact: cleanup

applied, thanks Cyrill!

	Ingo
