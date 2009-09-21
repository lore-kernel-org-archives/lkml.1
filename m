Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZIUJDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZIUJDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZIUJDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:03:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbZIUJDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:03:44 -0400
Date: Mon, 21 Sep 2009 11:03:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] events process running on wrong cpu
Message-ID: <20090921090324.GA7701@elte.hu>
References: <20090921085155.GB4649@osiris.boeblingen.de.ibm.com> <1253523777.8439.155.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253523777.8439.155.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0411]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2009-09-21 at 10:51 +0200, Heiko Carstens wrote:
> > Hi,
> > 
> > with todays git from time to time I get this (s390 defconfig):
> 
> Yep, I messed up..
> 
> Does your kernel contain the below?

FYI, that fix will go Linuswards later today.

	Ingo
