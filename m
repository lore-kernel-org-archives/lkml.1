Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYIXHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYIXHj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYIXHjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:39:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58102 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYIXHjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:39:18 -0400
Date: Wed, 24 Sep 2008 09:39:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: signal: cosmetic unification of do_signal()
Message-ID: <20080924073859.GC3655@elte.hu>
References: <48D987A0.50508@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D987A0.50508@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0131]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Make do_signal() same.
> Thia patch modifies only comments in signal_64.c.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

applied your patches to tip/x86/signal:

 86d3237: x86: signal: cosmetic unification of handle_signal()
 ee847c5: x86: signal: cosmetic unification of do_notify_resume()
 5fd9333: x86: signal: cosmetic unification of do_signal()

thanks!

	Ingo
