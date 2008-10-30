Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYJ3TaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYJ3TaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYJ3TaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:30:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41884 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYJ3TaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:30:03 -0400
Date: Thu, 30 Oct 2008 20:29:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jike Song <albcamus@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix inline assembly constraints
Message-ID: <20081030192953.GH27407@elte.hu>
References: <1225297937-2917-1-git-send-email-albcamus@gmail.com> <20081029163400.GA14866@elte.hu> <df9815e70810291931i4c00966u8f4493386e376b28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70810291931i4c00966u8f4493386e376b28@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jike Song <albcamus@gmail.com> wrote:

> On Thu, Oct 30, 2008 at 12:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jike Song <albcamus@gmail.com> wrote:
> >>
> >> --
> >
> > that was an easy patch to act upon ;-)
> >
> >        Ingo
> >
> Sorry Ingo, I missed your point. Do you mean this patch is trivial or
> unnecessary?

nah, it was a joke - you sent two mails, one of them was empty ;-)

	Ingo
