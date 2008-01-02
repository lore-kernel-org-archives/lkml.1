Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYABV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYABV62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYABV6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:58:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbYABV6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:58:18 -0500
Date: Wed, 2 Jan 2008 22:57:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH -mm] compat_binfmt_elf Kconfig
Message-ID: <20080102215738.GA17797@elte.hu>
References: <20071223183920.GA13976@elte.hu> <20071223211603.3FFB126F8E7@magilla.localdomain> <20071230163614.GB1384@elte.hu> <20080102044157.A5CC526F99F@magilla.localdomain> <20080102111431.GD14731@elte.hu> <20080102191030.GA11217@uranus.ravnborg.org> <20080102210831.9F80426F9A0@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102210831.9F80426F9A0@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> This patch should go in immediately after:
> 
> 	commit 5e45efc63e33ee2bae9ff4d500b53d3bf86d2b48
> 	Author: Roland McGrath <roland@redhat.com>
> 
> 	    compat_binfmt_elf
> 
> Thanks,
> Roland
> 
> ---
> [PATCH] compat_binfmt_elf Kconfig

thanks, applied.

	Ingo
