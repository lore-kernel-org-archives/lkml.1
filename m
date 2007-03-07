Return-Path: <linux-kernel-owner+w=401wt.eu-S1422641AbXCGJO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641AbXCGJO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422643AbXCGJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:14:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422641AbXCGJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:14:27 -0500
Date: Wed, 7 Mar 2007 10:13:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6 -rt] powerpc 2.6.20-rt8: fix boot/runtime errors/warnings for PowerPC(ppc64)
Message-ID: <20070307091340.GB1783@elte.hu>
References: <yyi8xe925vg.wl@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yyi8xe925vg.wl@toshiba.co.jp>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tsutomu OWA <tsutomu.owa@toshiba.co.jp> wrote:

> 
> Hi Ingo,
> 
>   Please consider for inclusion in your rt tree.
> 
>   This series of patches fixes boot and runntime errors/warnings for
> powerpc (esp. 64 bit).  This applies to linux-2.6.20, patch-2.6.20-rt8
> and previous my patch set;
>   http://ozlabs.org/pipermail/linuxppc-dev/2007-March/032640.html
>   http://lkml.org/lkml/2007/3/6/503

thanks, applied.

	Ingo
