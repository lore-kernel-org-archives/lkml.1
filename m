Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYJWNBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYJWNBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYJWNBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:01:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYJWNBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:01:39 -0400
Date: Thu, 23 Oct 2008 15:01:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Message-ID: <20081023130111.GA20321@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <49007410.8090700@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49007410.8090700@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0409]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> > I fixed the From: line oddities - please holler if they are wrong 
> > anywhere, we can still rebase this.
> 
> I found two of them and had resubmitted them, but perhaps that didn't 
> take either?

i had to fix up about 20.

	Ingo
