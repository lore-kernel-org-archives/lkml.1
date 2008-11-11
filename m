Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYKKI4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYKKI4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYKKI4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:56:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbYKKI4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:56:22 -0500
Date: Tue, 11 Nov 2008 09:56:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] doc: fix grub spell
Message-ID: <20081111085607.GA10293@elte.hu>
References: <20081111114723.6176.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111114723.6176.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> I met okuji-san (GRUB maintainer) yesterday.
> He said GRuB isn't correct spell and he want to fix it.
> 
> So, I'd like to do that.
> 
> 
> ------------------------------------------------------------
> GRuB isn't correct spell.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  Documentation/x86/boot.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/x86/doc, thanks!

	Ingo
