Return-Path: <linux-kernel-owner+w=401wt.eu-S1760490AbYAHQBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490AbYAHQBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYAHQAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:00:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40633 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYAHQAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:00:53 -0500
Date: Tue, 8 Jan 2008 16:59:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: just.for.lkml@googlemail.com, tomof@acm.org, akpm@linux-foundation.org,
       jarkao2@gmail.com, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, neilb@suse.de, bfields@fieldses.org,
       netdev@vger.kernel.org, tom@opengridcomputing.com
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080108155948.GC26114@elte.hu>
References: <64bb37e0801060335k4afb3134u9c6fadb57d525dc5@mail.gmail.com> <20080106223650E.tomof@acm.org> <64bb37e0801061203l503f29f0hd922a1347f8169ac@mail.gmail.com> <20080107151639P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107151639P.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> The patches are available at:
> 
> http://www.kernel.org/pub/linux/kernel/people/tomo/iommu/
> 
> Or if you prefer the git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git 
> iommu-sg-fixes

btw., these improvements to the IOMMU code are in -mm and will go into 
v2.6.25, right? The changes look robust to me.

	Ingo
