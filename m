Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYBAOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYBAOza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYBAOzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:55:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41667 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbYBAOzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:55:18 -0500
Date: Fri, 1 Feb 2008 15:54:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika Penttil? <mika.penttila@kolumbus.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
Message-ID: <20080201145436.GA19653@elte.hu>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801281802.01748.rjw@sisk.pl> <20080201135125.GA16249@elte.hu> <200802011528.17423.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802011528.17423.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > no strong preference here - pick the one you like best and send a 
> > patch please :-)
> 
> Here you go, but I think it falls into the ACPI category.

agreed - Len, would you mind to pick this patch up?

Acked-by: Ingo Molnar <mingo@elte.hu>
	
	Ingo
