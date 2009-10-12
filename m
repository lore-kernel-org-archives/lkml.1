Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZJLGuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZJLGuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZJLGug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:50:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36062 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZJLGuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:50:35 -0400
Date: Mon, 12 Oct 2009 08:49:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: tip tree question
Message-ID: <20091012064944.GA32027@elte.hu>
References: <20091012145609.c3cc78aa.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012145609.c3cc78aa.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> I noticed that the auto-latest branch of the tip tree (which is what 
> is included in linux-next) has had the tip out-of-tree branch merged 
> into it. [...]

That was unintended. tip:out-of-tree is like the tail section of -mm: 
for useful but never-for-upstream patches.

Fixed it - thanks Stephen,

	Ingo
