Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYLaHxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYLaHxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 02:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYLaHxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 02:53:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55536 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbYLaHxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 02:53:14 -0500
Date: Wed, 31 Dec 2008 08:52:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org
Subject: Re: [patch] powerpc: change u64/s64 to a long long integer type
Message-ID: <20081231075256.GA10448@elte.hu>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au> <b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com> <20081222070426.GD29160@elte.hu> <20081222181932.5dd9514e.sfr@canb.auug.org.au> <20081222080341.GA18897@elte.hu> <20081231154027.457d9197.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231154027.457d9197.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> So, would you like me to push this along - including splitting it up a
> bit (keeping your Signed-off-by, of course)?

Sure, feel free - this should really be done by someone with more PowerPC 
interest/experience than me.

	Ingo
