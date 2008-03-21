Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYCULJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYCULJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYCULJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:09:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbYCULJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:09:45 -0400
Date: Fri, 21 Mar 2008 12:09:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-kernel@vger.kernel.org, bugme-daemon@kernel-bugs.osdl.org
Subject: Re: [patch] sync_bitops: fix wrong comments [Bug 10247]
Message-ID: <20080321110930.GZ20420@elte.hu>
References: <681011.80694.qm@web52002.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681011.80694.qm@web52002.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

> Fix wrong function name and references to non-x86 architectures.

thanks, applied.

	Ingo
