Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYABV64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYABV64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYABV6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:58:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54608 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbYABV6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:58:45 -0500
Date: Wed, 2 Jan 2008 22:58:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH -mm] x86 compat_binfmt_elf
Message-ID: <20080102215814.GB17797@elte.hu>
References: <20071223183920.GA13976@elte.hu> <20071223211603.3FFB126F8E7@magilla.localdomain> <20071230163614.GB1384@elte.hu> <20080102044157.A5CC526F99F@magilla.localdomain> <20080102111431.GD14731@elte.hu> <20080102191030.GA11217@uranus.ravnborg.org> <20080102210831.9F80426F9A0@magilla.localdomain> <20080102211243.D7CFA26F9A0@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102211243.D7CFA26F9A0@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> This patch replaces the earlier patch by the same title already in 
> x86/mm:
> 
> 	commit a9014d2dfcb253fb3ce5f4e3318849f743b85427
> 	Author: Roland McGrath <roland@redhat.com>
> 
> 	    x86 compat_binfmt_elf
> 
> It requires the new patch I just posted, titled "compat_binfmt_elf 
> Kconfig".

thanks, applied.

	Ingo
