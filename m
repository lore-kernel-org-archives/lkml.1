Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbYHULtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbYHULtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYHULtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:49:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbYHULtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:49:24 -0400
Date: Thu, 21 Aug 2008 13:48:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/4]array interface pageattr APIs for AGP
Message-ID: <20080821114856.GD30667@elte.hu>
References: <1219286763.18007.38.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219286763.18007.38.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Shaohua Li <shaohua.li@intel.com> wrote:

> These are Dave Airlie's array interface patches for pageattr. I
> refreshed them and did bug fixing. The purpose of the patches is to
> reduce tlb/cache flush in agp gart memory allocation.
> 
> the patches apply to tip tree, but please remove my two patches first
> 1ac2f7d55b7ee1613c90631e87fea22ec06781e5
> 466ae837424dcc538b1af2a0eaf53be32edcdbe7

applied to tip/x86/pat, thanks Shaohua!

	Ingo
