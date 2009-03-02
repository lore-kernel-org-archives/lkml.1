Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZCBIhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZCBIhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbZCBIhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:37:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605AbZCBIhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:37:33 -0500
Date: Mon, 2 Mar 2009 09:37:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: linux-next: Linus' tree build warnings
Message-ID: <20090302083719.GA6040@elte.hu>
References: <20090302183511.a1415086.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302183511.a1415086.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (i386 defconfig) produced these warnings:
> 
> In file included from drivers/gpu/drm/i915/i915_drv.h:36,
>                  from drivers/gpu/drm/i915/i915_drv.c:35:
> include/linux/io-mapping.h: In function 'io_mapping_map_wc':
> include/linux/io-mapping.h:95: warning: ISO C90 forbids mixed declarations and code
> 
> And several more of the same.

yes, a patch for that was already sent.

	Ingo
