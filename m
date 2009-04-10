Return-Path: <linux-kernel-owner+w=401wt.eu-S935279AbZDJM3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935279AbZDJM3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZDJM2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:28:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbZDJM2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:28:53 -0400
Date: Fri, 10 Apr 2009 14:28:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] x86: cacheinfo: cache_disable fixes/cleanup
Message-ID: <20090410122846.GS21506@elte.hu>
References: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409125659.GD31527@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> These patches primarily split up Mark's latest patch
> 
>   [PATCH][retry 6] Conform L3 Cache Index Disable to Linux Standards
>   (see http://marc.info/?l=linux-kernel&m=123922420925908&w=2)
> 
> into smaller pieces. I prefer to revert the last two patches on
> tip/x86/cpu to get a cleaner changelog for the following fixes.
> 
> Patches are against tip/x86/cpu as of today.
> 
> Please apply.

thanks, applied - this series looks much nicer!

I rebased the topic to get rid of the double revert sequence, and 
have started testing it.

Thanks,

	Ingo
