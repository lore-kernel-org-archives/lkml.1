Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZCUMFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZCUMFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZCUMF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:05:27 -0400
Received: from www.tglx.de ([62.245.132.106]:54365 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZCUMF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:05:26 -0400
Date: Sat, 21 Mar 2009 13:05:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       john.williams@petalogix.com
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
In-Reply-To: <49C4D628.7060805@monstr.eu>
Message-ID: <alpine.LFD.2.00.0903211303360.29264@localhost.localdomain>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>  <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>  <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>  <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
  <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>  <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>  <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> 
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>  <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>  <49C2AB09.9040300@monstr.eu>  <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>  <1237515861.7106.215.camel@jstultz-laptop>
  <49C34558.6030006@monstr.eu> <1237581607.7191.51.camel@localhost.localdomain> <49C4C3BD.9090905@monstr.eu> <alpine.LFD.2.00.0903211206090.29264@localhost.localdomain> <49C4D628.7060805@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009, Michal Simek wrote:
> Yes, I see it. I think I sent my log in any previous email in this thread too +
> I see it on my heartbeat led too.
> 
> Thanks for explanation,

Welcome. Thanks for working on the review issues. I looked through
your timer and interrupt code and I'm quite happy with it.

Please add: Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

to both.

Thanks,

	tglx
