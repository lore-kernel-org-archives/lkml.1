Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYIFRRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYIFRRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYIFRRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:17:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYIFRRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:17:08 -0400
Date: Sat, 6 Sep 2008 19:16:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck updates for tip/kmemcheck
Message-ID: <20080906171646.GI4856@elte.hu>
References: <20080829211921.GA1135@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829211921.GA1135@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0477]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi Ingo,
> 
> A rather large update, most of it is implementing the correct REP 
> MOVS/STOS handling on P4s. I've tested it on both 32-bit and 64-bit 
> and everything seems good! Also included is the DMA API hooks which 
> prevents false-positive reports from reads in DMA-able memory.

pulled, thanks Vegard. Great progress on a rather difficult aspect of 
kmemcheck!

	Ingo
