Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZBEOb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZBEOb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbZBEObr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:31:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZBEObq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:31:46 -0500
Date: Thu, 5 Feb 2009 15:30:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Kirill Korotaev <dev@parallels.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kirill Korotaev <dev@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
Message-ID: <20090205143054.GF28443@elte.hu>
References: <C5B07536.B77D%dev@parallels.com> <498AB837.1040404@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498AB837.1040404@openvz.org>
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


* Pavel Emelyanov <xemul@openvz.org> wrote:

> Reported-by: Kirill Korotaev <dev@openvz.org>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> This one also works. Should I re-send this patch in a proper way?

Yes, please do. Also, please have a look at the helper function cleanup 
suggestion from Linus - such a patch would be welcome too.

	Ingo

