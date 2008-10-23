Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbYJWKoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbYJWKoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 06:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYJWKoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 06:44:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbYJWKoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 06:44:13 -0400
Date: Thu, 23 Oct 2008 12:43:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/35] cpumask: deprecate any_online_cpu() in favour of
	cpumask_any/cpumask_any_and From: Rusty Russell
	<rusty@rustcorp.com.au>
Message-ID: <20081023104348.GA18733@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020830.685972000@polaris-admin.engr.sgi.com> <20081023102523.GA2351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023102523.GA2351@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Mike Travis <travis@sgi.com> wrote:
> 
> > any_online_cpu() is a good name, but it takes a cpumask_t, not a
> > pointer.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Mike Travis <travis@sgi.com>
> 
> almost all the patches have a missing \n and thus wrong authorship...

ok, i fixed them up.

	Ingo
