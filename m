Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZLNJjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZLNJjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZLNJjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:39:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZLNJjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:39:22 -0500
Date: Mon, 14 Dec 2009 10:39:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 2/2] x86, mce: Introduce intel_thermal_supported()
Message-ID: <20091214093906.GA4020@elte.hu>
References: <4B25FDDC.407@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B25FDDC.407@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> It looks better to have a common function.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)

Applied both patches, thanks!

	Ingo
