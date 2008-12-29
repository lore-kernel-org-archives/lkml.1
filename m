Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYL2MNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYL2MNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYL2MNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:13:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbYL2MNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:13:18 -0500
Date: Mon, 29 Dec 2008 13:13:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: mach-default setup.c cleanup
Message-ID: <20081229121307.GD9628@elte.hu>
References: <20081227141018.GA14658@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227141018.GA14658@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Impact: cleanup
> 
> Break THAT long lines into shorter form.
> Use pr_ macros instead of plain printk.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Nothing serious except loglevel of messages being
> printed is changed (was KERN_WARNING as by default).
> Yeah, it's not-fixing-anything-patch, so feel free
> to just drop it if it break a patch queue :-)
> 
>  arch/x86/mach-default/setup.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)

applied to tip/x86/cleanups, thanks Cyrill!

	Ingo
