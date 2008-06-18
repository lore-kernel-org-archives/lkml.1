Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYFRNQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYFRNQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbYFRNQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:16:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbYFRNQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:16:19 -0400
Date: Wed, 18 Jun 2008 15:15:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080618131545.GD11501@elte.hu>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806172244.24026.rjw@sisk.pl> <200806180019.49628.rjw@sisk.pl> <200806180025.20504.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806180025.20504.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Ah.  If your fix is replaced with the appended one, the system 
> > happily works with C1E and highres.
> 
> Scratch that.  The symptoms appeared later this time, that's all.  
> I've just got b43 consuming 90+ % of the CPU time. :-(

ah, ok. Discarded the patch :-/

	Ingo
