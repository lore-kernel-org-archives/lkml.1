Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZDLRZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZDLRZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZDLRYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:24:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55285 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbZDLRYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:24:48 -0400
Date: Sun, 12 Apr 2009 19:24:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: hpa@zytor.com, tglx@linutronix.de, xemul@openvz.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, macro@linux-mips.org, andi@firstfloor.org
Subject: Re: [rfc 0/4] x86 - apic dummy ops with cleanups
Message-ID: <20090412172431.GA26459@elte.hu>
References: <20090412164738.967602112@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412164738.967602112@openvz.org>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Hi,
> 
> here is a series of patches with some tiny
> cleanup and one bugfix I believe (and most
> probably why fixing one issue new one could
> be introduced as well :-)
> 
> Please review and test if possible. _Any_ kind
> of feedback is highly appreciated!

This series looks very good and is well-structured,
i've applied it to tip:x86/apic and started testing
it, thanks Cyrill!

	Ingo
