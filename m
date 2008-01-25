Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYAYX7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYAYX7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAYX7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:59:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbYAYX7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:59:32 -0500
Date: Sat, 26 Jan 2008 00:59:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] ./drivers/crypto/hifn_795x.c
Message-ID: <20080125235914.GA22357@elte.hu>
References: <20080125222150.GA22401@elte.hu> <20080125235131.GA19980@elte.hu> <20080125235357.GA4128@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125235357.GA4128@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0199]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Sat, Jan 26, 2008 at 12:51:31AM +0100, Ingo Molnar wrote:
> >
> > find a workaround below - but i'm not sure it's the right one.
> 
> Thanks, but I've already checked in a fix :)

hey, that's my punishment for not reading my email promptly :) Could 
have saved me some time in the Kconfig web of dependencies :-/

	Ingo
