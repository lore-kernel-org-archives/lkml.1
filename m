Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbZAOVKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbZAOVKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763645AbZAOVCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:02:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41663 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239AbZAOVCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:02:34 -0500
Date: Thu, 15 Jan 2009 22:02:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
Message-ID: <20090115210224.GB22416@elte.hu>
References: <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org> <496BCD14.3020201@sgi.com> <20090114111949.GO2913@elte.hu> <496E4211.6040503@sgi.com> <20090114201152.GA31581@elte.hu> <496E587E.6010503@sgi.com> <20090115094938.GB5833@elte.hu> <496FA24B.5050306@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496FA24B.5050306@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> This all started because you wanted a more descriptive changelog for 
> Yinghai's probe_nr_irqs() patch.  I was attempting to do this, and is 
> why I sent the full text to you, in case I couldn't do it (as you 
> explained above).
> 
> I'm guessing this subject is now closed?

yeah - unless we are forced to do a full rebase or something like that.

	Ingo
