Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYK0MBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYK0MBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYK0MAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:00:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYK0MAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:00:54 -0500
Date: Thu, 27 Nov 2008 13:00:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] x86: entry_64.S - use X86_EFLAGS_IF instead of
	hardcoded number
Message-ID: <20081127120045.GA4259@elte.hu>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com> <1227782278.31536.1287041953@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227782278.31536.1287041953@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> On Wed, 26 Nov 2008 22:17:02 +0300, gorcunov@gmail.com said:
> > From: Cyrill Gorcunov <gorcunov@gmail.com>
> > 
> > Impact: cleanup
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

applied, thanks guys!

	Ingo
