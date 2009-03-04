Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZCDLNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZCDLNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZCDLNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:13:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZCDLNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:13:06 -0500
Date: Wed, 4 Mar 2009 12:12:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Mike Galbraith <efault@gmx.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Large amount of scsi-sgpool objects
Message-ID: <20090304111235.GA14593@elte.hu>
References: <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de> <20090303234834.GA13389@elte.hu> <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de> <alpine.LFD.2.00.0903041004300.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903041004300.29264@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Stefan,
> 
> On Wed, 4 Mar 2009, Stefan Richter wrote:
> > As I said, I recommend that people do not receive those off-topic
> > patches by default, only on demand.  (Because I sometimes work with -rt
> > users.)
> 
> And as I said before, I missed to remove the patch before pushing out
> the -rt tree. So I really do not need repeated advise on how to do my
> work.

yeah. I dont think Stefan ever maintained a high-volume generic 
tree before. Kibitzing from the sidelines always makes it seem 
so easy ;-)

	Ingo
