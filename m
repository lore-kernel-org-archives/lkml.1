Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbXEaUBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbXEaUBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbXEaUBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:01:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759623AbXEaUBY (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:01:24 -0400
Date: Thu, 31 May 2007 22:01:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "K.R. Foley" <kr@cybsft.com>
Cc: Linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: patch-2.6.21.3-rt9 misnamed?
Message-ID: <20070531200109.GA8715@elte.hu>
References: <465EE33B.4070502@cybsft.com> <20070531153821.GA712@elte.hu> <465EFE31.30904@cybsft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465EFE31.30904@cybsft.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* K.R. Foley <kr@cybsft.com> wrote:

> Ingo Molnar wrote:
> > * K.R. Foley <kr@cybsft.com> wrote:
> > 
> >> Ingo,
> >>
> >> I believe that patch-2.6.21.3-rt9 is misnamed. It applies cleanly to 
> >> 2.6.21 but seems to contain stuff that is already in 2.6.21.3.
> > 
> > yes - it includes all of 2.6.21.3.
> > 
> > 	Ingo
> > 
> 
> So actually it is not really misnamed, it's just done a bit 
> differently than previous versions. Sorry.

yeah. Maybe we should make the 2.6.21.3 -rt patches relative to 2.6.21.3 
- but that would be one extra patching step for people who already have 
a 2.6.21 tree. But ... maybe that makes the most sense after all.

	Ingo
