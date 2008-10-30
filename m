Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYJ3SId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYJ3SId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbYJ3SIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:08:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54525 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbYJ3SIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:08:24 -0400
Date: Thu, 30 Oct 2008 19:07:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Aristeu Rozanski <aris@redhat.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nmi_watchdog: update procfs nmi_watchdog file
	documentation v2
Message-ID: <20081030180759.GB4675@elte.hu>
References: <20081030151712.GO771@redhat.com> <20081030091921.79c04ec6.randy.dunlap@oracle.com> <20081030170850.GQ771@redhat.com> <4909EB4B.3090300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4909EB4B.3090300@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > +If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
> > +NMI watchdog shares registers with oprofile. By disabling the NMI watchdog,
> > +oprofile may have more registers to utilize.
> >  
> >  msgmni
> >  ------
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks.

applied to tip/x86/nmi-watchdog, thanks guys!

	Ingo
