Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYA1MqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYA1MqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYA1MqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:46:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43995 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbYA1MqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:46:08 -0500
Date: Mon, 28 Jan 2008 13:45:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Message-ID: <20080128124554.GD32496@elte.hu>
References: <200801272122.21823.gene.heskett@gmail.com> <18333.36746.819935.641383@harpo.it.uu.se> <1201521783.6149.33.camel@lappy> <18333.51681.780267.521513@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18333.51681.780267.521513@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Peter Zijlstra writes:
>  > 
>  > On Mon, 2008-01-28 at 09:17 +0100, Mikael Pettersson wrote:
>  > 
>  > > 1. Wrong mailing list; use linux-ide (@vger) instead.
>  > 
>  > What, and keep all us other interested people in the dark?
> 
> MAINTAINERS clearly lists linux-ide as the primary mailing list for 
> all things IDE/ATA.
>
> The original report only went to LKML, thus it has a high chance of 
> being missed or ignored by those most capable of dealing with it.

that is a fatal misunderstanding on your part. lkml is a perfectly fine 
place to report Linux bugs, why should testers be aware of the zillions 
of tiny, mostly irrelevant lists mentioned in the MAINTAINERS file?

Maintainers are required to read lkml for bugreports regarding their 
subsystems - not the other way around. If a tester manages to Cc: a 
maintainer (be that a person or a list alias) that's a bonus, but not a 
requirement at all ...

	Ingo
