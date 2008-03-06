Return-Path: <linux-kernel-owner+w=401wt.eu-S934471AbYCFNgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471AbYCFNgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbYCFNgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:36:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46399 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910AbYCFNgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:36:08 -0500
Date: Thu, 6 Mar 2008 14:35:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH][x86] rdc321x: remove watchdog file
Message-ID: <20080306133547.GA23933@elte.hu>
References: <200802251144.08962.florian.fainelli@telecomint.eu> <20080225105408.GB5648@elte.hu> <200803061424.13024.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803061424.13024.florian.fainelli@telecomint.eu>
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


* Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> Hi Ingo,
> 
> Le lundi 25 février 2008, Ingo Molnar a écrit :
> > thanks, applied. I guess i should push this change upstream only once
> > the new watchdog driver has been committed to drivers/watchdog/ ?
> 
> Can you please trigger the patch now. Wim has accepted the RDC built-in 
> watchdog driver. See : 
> http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-mm.git;a=commit;h=b2de97cf901162e0a5936b2bbdae27ec1e55455d
> 
> Thank you very much.

should i do this now, or once Wim's tree has been merged into Linus's 
tree?

	Ingo
