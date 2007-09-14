Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXINIOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXINIOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 04:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXININt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 04:13:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37119 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbXININs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 04:13:48 -0400
Date: Fri, 14 Sep 2007 10:13:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dimm <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070914081341.GB16159@elte.hu>
References: <1189723870.4485.18.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189723870.4485.18.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* dimm <dmitry.adamushko@gmail.com> wrote:

> unless we are very eager to keep an additional layer of abstraction, 
> 'struct load_stat' is redundant now so let's get rid of it.

yeah - good one, it's indeed redundant. Applied.

	Ingo
