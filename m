Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531Ab0ARHur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0ARHur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441Ab0ARHuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:50:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab0ARHup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:50:45 -0500
Date: Mon, 18 Jan 2010 08:50:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20100118075025.GA22476@elte.hu>
References: <20100118180841.96628ee6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118180841.96628ee6.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> scripts/recordmcount.pl between commit
> b82a4045f7962483a78a874343dc6e31b79c96c1 ("tracing/x86: Derive arch from
> bits argument in recordmcount.pl") from Linus' tree and commit
> dfaa9e2c5707b2c217c0121aac796e0fa3051482 ("tracing: Use appropriate perl
> constructs in recordmcount.pl") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

FYI, i resolved the conflict already in tip:master yesterday, a bit 
differently.

Thanks,

	Ingo
